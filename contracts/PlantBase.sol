// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

/**
 * @title Plant 植物基础公共合约
 * @author sharebravery
 * @notice 公共合约，提供植物基础功能
 */
contract PlantBase {
    using EnumerableSet for EnumerableSet.UintSet;

    event PlantWatered(uint256 plantId, uint8 waterAmount);
    event LightProvided(uint256 plantId, uint8 lightDuration);
    event PlantGrown(uint256 plantId, PlantStage newStage);
    event PlantHarvested(uint256 plantId, address reciver);
    event PlantTransferred(uint256 plantId, address form, address to);

    // 植物品种
    enum PlantSpecies {
        Tree,
        Flower,
        Shrub
    }

    // 植物信息
    struct PlantMetadata {
        string plantName;
        PlantSpecies plantSpecies;
    }

    // 植物状态
    struct Plant {
        uint8 waterLevel; // 0~100
        uint8 lightLevel; // 0~100
        bool isAlive;
        PlantStage currentStage;
        PlantMetadata metadata;
    }

    // 植物生长阶段
    enum PlantStage {
        Seed,
        Sprout,
        Mature,
        Flower,
        Harvest
    }

    // 存储植物信息的映射
    mapping(uint256 => Plant) public plantMap;

    // 存储植物ID的集合
    EnumerableSet.UintSet private _plantIds;

    // 存储用户地址拥有的植物ID数组的映射
    mapping(address => uint256[]) public userPlantIds;

    /**
     * @notice 创建植物并返回植物ID
     * @param plantName 植物名称
     * @param plantSpecies 植物品种
     */
    function createPlant(
        string memory plantName,
        PlantSpecies plantSpecies
    ) external returns (uint256) {
        uint256 plantId = _plantIds.length();

        // 创建新植物
        plantMap[plantId] = Plant({
            waterLevel: 25,
            lightLevel: 25,
            isAlive: true,
            currentStage: PlantStage.Seed,
            metadata: PlantMetadata({
                plantName: plantName,
                plantSpecies: plantSpecies
            })
        });

        // 将植物ID添加到集合中
        _plantIds.add(plantId);

        // 将植物ID添加到用户地址对应的植物ID数组中
        userPlantIds[msg.sender].push(plantId);

        return plantId;
    }

    /**
     * @notice 获取用户地址拥有的植物ID数组
     */
    function getUserPlantIds() external view returns (uint256[] memory) {
        return userPlantIds[msg.sender];
    }

    /**
     * @notice 获取植物ID集合
     */
    function getPlantIds() external view returns (uint256[] memory) {
        uint256[] memory plantIds = new uint256[](_plantIds.length());
        for (uint256 i = 0; i < _plantIds.length(); i++) {
            plantIds[i] = _plantIds.at(i);
        }
        return plantIds;
    }

    /**
     * @notice 获取植物状态信息
     * @param plantId 植物ID
     */
    function getPlantStatus(
        uint256 plantId
    )
        public
        view
        returns (
            string memory,
            PlantSpecies,
            uint8,
            uint8,
            bool,
            PlantStage,
            uint256
        )
    {
        require(_plantIds.contains(plantId), "Plant does not exist");
        require(plantMap[plantId].isAlive, "The plant is not alive.");
        require(
            _isPlantOwner(msg.sender, plantId),
            "Not the owner of the plant"
        );

        return (
            plantMap[plantId].metadata.plantName,
            plantMap[plantId].metadata.plantSpecies,
            plantMap[plantId].waterLevel,
            plantMap[plantId].lightLevel,
            plantMap[plantId].isAlive,
            plantMap[plantId].currentStage,
            plantId
        );
    }

    /**
     * @notice 给植物浇水
     * @param plantId 植物ID
     * @param waterAmount 水量
     */
    function waterPlant(uint256 plantId, uint8 waterAmount) public {
        _updatePlantStatus(plantId, waterAmount, 0);
    }

    /**
     * @notice 提供光照
     * @param plantId 植物ID
     * @param lightDuration 光照时长
     */
    function provideLight(uint256 plantId, uint8 lightDuration) public {
        _updatePlantStatus(plantId, 0, lightDuration);
    }

    /**
     * @notice 合并状态更新操作，减少 gas 消耗
     * @param plantId 植物ID
     * @param waterAmount 水量
     * @param lightDuration 光照时长
     */
    function _updatePlantStatus(
        uint256 plantId,
        uint8 waterAmount,
        uint8 lightDuration
    ) internal {
        require(_plantIds.contains(plantId), "Plant does not exist");
        require(plantMap[plantId].isAlive, "The plant is not alive.");
        require(
            _isPlantOwner(msg.sender, plantId),
            "Not the owner of the plant"
        );

        // 更新水分级别
        plantMap[plantId].waterLevel = uint8(
            plantMap[plantId].waterLevel + waterAmount > 100
                ? 100
                : plantMap[plantId].waterLevel + waterAmount
        );

        // 更新光照级别
        plantMap[plantId].lightLevel = uint8(
            plantMap[plantId].lightLevel + lightDuration > 100
                ? 100
                : plantMap[plantId].lightLevel + lightDuration
        );

        // 发送事件，记录状态更新行为
        emit PlantWatered(plantId, waterAmount);
        emit LightProvided(plantId, lightDuration);

        _growPlant(plantId);
    }

    /**
     * @notice 促使植物生长
     * @param plantId 植物ID
     */
    function _growPlant(uint256 plantId) internal {
        require(_plantIds.contains(plantId), "Plant does not exist");
        require(plantMap[plantId].isAlive, "The plant is not alive.");
        require(
            _isPlantOwner(msg.sender, plantId),
            "Not the owner of the plant"
        );

        // 处理生长,
        if (
            plantMap[plantId].currentStage == PlantStage.Seed &&
            plantMap[plantId].waterLevel >= 20 &&
            plantMap[plantId].lightLevel >= 20
        ) {
            plantMap[plantId].currentStage = PlantStage.Sprout;
        } else if (
            plantMap[plantId].currentStage == PlantStage.Sprout &&
            plantMap[plantId].waterLevel >= 40 &&
            plantMap[plantId].lightLevel >= 40
        ) {
            plantMap[plantId].currentStage = PlantStage.Mature;
        } else if (
            plantMap[plantId].currentStage == PlantStage.Mature &&
            plantMap[plantId].waterLevel >= 60 &&
            plantMap[plantId].lightLevel >= 60
        ) {
            plantMap[plantId].currentStage = PlantStage.Flower;
        }

        // 发送事件，记录生长行为
        emit PlantGrown(plantId, plantMap[plantId].currentStage);

        // 检查植物状态
        _checkPlantHealth(plantId);
    }

    /**
     * @notice 检查植物是否健康，如果水分或光照不足，植物将死亡
     * @param plantId 植物ID
     */
    function _checkPlantHealth(uint256 plantId) internal {
        require(_plantIds.contains(plantId), "Plant does not exist");
        require(plantMap[plantId].isAlive, "The plant is not alive.");

        if (
            plantMap[plantId].waterLevel <= 0 ||
            plantMap[plantId].lightLevel <= 0
        ) {
            plantMap[plantId].isAlive = false;
            plantMap[plantId].currentStage = PlantStage.Seed; // 重置为种子状态
        }
    }

    /**
     * @notice 检查用户是否拥有指定植物
     * @param userAddress 用户地址
     * @param plantId 植物ID
     */
    function _isPlantOwner(
        address userAddress,
        uint256 plantId
    ) internal view returns (bool) {
        uint256[] memory plantIds = userPlantIds[userAddress];
        for (uint256 i = 0; i < plantIds.length; i++) {
            if (plantIds[i] == plantId) {
                return true;
            }
        }
        return false;
    }

    /**
     * 收获植物
     * @param plantId plant id
     */
    function harvestPlant(uint256 plantId) public {
        require(_plantIds.contains(plantId), "Plant does not exist");
        require(plantMap[plantId].isAlive, "The plant is not alive.");
        require(
            _isPlantOwner(msg.sender, plantId),
            "Not the owner of the plant"
        );
        require(
            plantMap[plantId].currentStage == PlantStage.Flower,
            "The plant is not mature enough to harvest."
        );

        // 标记植物为已收获状态
        plantMap[plantId].currentStage = PlantStage.Harvest;
        plantMap[plantId].isAlive = false; // 将植物标记为不再存活

        // 发放奖励，例如代币或其他资源
        // 这里可以添加发放奖励的逻辑

        // 发送事件，记录植物被收获
        emit PlantHarvested(plantId, msg.sender);
    }

    /**
     * 以下为交易植物功能
     * @param to to
     * @param plantId plantId
     */
    function transferPlant(address to, uint256 plantId) public {
        require(_plantIds.contains(plantId), "Plant does not exist");
        require(plantMap[plantId].isAlive, "The plant is not alive.");
        require(
            _isPlantOwner(msg.sender, plantId),
            "Not the owner of the plant"
        );

        // 移除原始所有者的植物ID
        _removePlantOwnership(msg.sender, plantId);
        // 将植物所有权转移给新的所有者
        _addPlantOwnership(to, plantId);

        // 发送事件，记录植物被转移
        emit PlantTransferred(plantId, msg.sender, to);
    }

    function _removePlantOwnership(address from, uint256 plantId) internal {
        uint256[] storage plantIds = userPlantIds[from];
        for (uint256 i = 0; i < plantIds.length; i++) {
            if (plantIds[i] == plantId) {
                // 从用户植物ID数组中删除指定植物ID
                plantIds[i] = plantIds[plantIds.length - 1];
                plantIds.pop();
                return;
            }
        }
    }

    function _addPlantOwnership(address to, uint256 plantId) internal {
        userPlantIds[to].push(plantId);
    }
}
