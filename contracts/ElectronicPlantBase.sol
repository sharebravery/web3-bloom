// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

/**
 * @title ElectronicPlantBase 植物基础公共合约
 * @author sharebravery
 * @notice 公共合约，提供植物基础功能
 */
contract ElectronicPlantBase {
    using EnumerableSet for EnumerableSet.UintSet;

    // 植物信息
    struct PlantMetadata {
        string plantName;
        string plantSpecies;
        uint256 creationTime;
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
        Flower
    }

    // 存储植物信息的映射
    mapping(uint256 => Plant) public plantMap;

    // 存储植物ID的集合
    EnumerableSet.UintSet private _plantIds;

    /**
     * 事件，记录植物被浇水情况
     * @param plantId plantId
     * @param waterAmount 水量
     */
    event PlantWatered(uint256 plantId, uint8 waterAmount);

    /**
     * 事件，记录植物被提供光照情况
     * @param plantId plantId
     * @param lightDuration 光照时长
     */
    event LightProvided(uint256 plantId, uint8 lightDuration);

    /**
     * 事件，记录植物生长阶段变化
     * @param plantId plantId
     * @param newStage newStage
     */
    event PlantGrown(uint256 plantId, PlantStage newStage);

    /**
     * 修饰器，确保植物存在
     * @param plantId plantId
     */
    modifier plantExists(uint256 plantId) {
        require(_plantIds.contains(plantId), "Plant does not exist");
        _;
    }

    /**
     * 内部方法，检查植物健康状况
     * @param plantId plantId
     */
    function _checkPlantHealth(uint256 plantId) internal {
        if (
            plantMap[plantId].waterLevel <= 0 ||
            plantMap[plantId].lightLevel <= 0
        ) {
            plantMap[plantId].isAlive = false;
            plantMap[plantId].currentStage = PlantStage.Seed; // 重置为种子状态
        }
    }

    /**
     * @notice 获取植物状态信息
     * @param plantId 植物ID
     * @return plantName 植物名称
     * @return plantSpecies 植物品种
     * @return waterLevel 水分级别
     * @return lightLevel 光照级别
     * @return isAlive 植物是否存活
     * @return currentStage 当前生长阶段
     * @return creationTime 植物创建时间
     */
    function getPlantStatus(
        uint256 plantId
    )
        public
        view
        plantExists(plantId)
        returns (
            string memory,
            string memory,
            uint8,
            uint8,
            bool,
            PlantStage,
            uint256
        )
    {
        return (
            plantMap[plantId].metadata.plantName,
            plantMap[plantId].metadata.plantSpecies,
            plantMap[plantId].waterLevel,
            plantMap[plantId].lightLevel,
            plantMap[plantId].isAlive,
            plantMap[plantId].currentStage,
            plantMap[plantId].metadata.creationTime
        );
    }

    /**
     * @notice 给植物浇水
     * @param plantId 植物ID
     * @param waterAmount 水量
     */
    function waterPlant(
        uint256 plantId,
        uint8 waterAmount
    ) public plantExists(plantId) {
        require(plantMap[plantId].isAlive, "The plant is not alive.");

        // 更新水分级别
        plantMap[plantId].waterLevel = uint8(
            plantMap[plantId].waterLevel + waterAmount > 100
                ? 100
                : plantMap[plantId].waterLevel + waterAmount
        );

        // 发送事件，记录浇水行为
        emit PlantWatered(plantId, waterAmount);

        // 更新植物状态
        _checkPlantHealth(plantId);
    }

    /**
     * @notice 提供光照
     * @param plantId 植物ID
     * @param lightDuration 光照时长
     */
    function provideLight(
        uint256 plantId,
        uint8 lightDuration
    ) public plantExists(plantId) {
        require(plantMap[plantId].isAlive, "The plant is not alive.");

        // 更新光照级别
        plantMap[plantId].lightLevel = uint8(
            plantMap[plantId].lightLevel + lightDuration > 100
                ? 100
                : plantMap[plantId].lightLevel + lightDuration
        );

        // 发送事件，记录提供光照行为
        emit LightProvided(plantId, lightDuration);

        // 更新植物状态
        _checkPlantHealth(plantId);
    }

    /**
     * @notice 促使植物生长
     * @param plantId 植物ID
     */
    function growPlant(uint256 plantId) public plantExists(plantId) {
        require(plantMap[plantId].isAlive, "The plant is not alive.");

        // 处理生长
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

        // 更新植物状态
        _checkPlantHealth(plantId);
    }

    /**
     * 创建植物并返回植物ID
     * @param plantName 植物名称
     * @param plantSpecies 植物品种
     * @param creationTime 植物的创建时间  记录植物合约创建的时间戳
     */
    function createPlant(
        string memory plantName,
        string memory plantSpecies,
        uint256 creationTime
    ) external returns (uint256) {
        uint256 plantId = _plantIds.length() + 1;

        // 创建新植物
        plantMap[plantId] = Plant({
            waterLevel: 0,
            lightLevel: 0,
            isAlive: true,
            currentStage: PlantStage.Seed,
            metadata: PlantMetadata({
                plantName: plantName,
                plantSpecies: plantSpecies,
                creationTime: creationTime
            })
        });

        // 将植物ID添加到集合中
        _plantIds.add(plantId);

        return plantId;
    }

    /**
     * 获取植物ID集合
     */
    function getPlantIds() external view returns (uint256[] memory) {
        uint256[] memory plantIds = new uint256[](_plantIds.length());
        for (uint256 i = 0; i < _plantIds.length(); i++) {
            plantIds[i] = _plantIds.at(i);
        }
        return plantIds;
    }
}
