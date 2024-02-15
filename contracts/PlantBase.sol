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

    // 存储用户地址拥有的植物ID数组的映射
    mapping(address => uint256[]) public userPlantIds;

    /**
     * 修饰器，确保植物存在且存活
     * @param plantId plantId
     */
    modifier plantExistsAndAlive(uint256 plantId) {
        require(_plantIds.contains(plantId), "Plant does not exist");
        require(plantMap[plantId].isAlive, "The plant is not alive.");
        _;
    }

    /**
     * @notice 创建植物并返回植物ID
     * @param plantName 植物名称
     * @param plantSpecies 植物品种
     * @param creationTime 植物的创建时间  记录植物合约创建的时间戳
     */
    function createPlant(
        string memory plantName,
        PlantSpecies plantSpecies,
        uint256 creationTime
    ) external returns (uint256) {
        uint256 plantId = _plantIds.length();

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

        // 将植物ID添加到用户地址对应的植物ID数组中
        userPlantIds[msg.sender].push(plantId);

        return plantId;
    }

    /**
     * @notice 获取用户地址拥有的植物ID数组
     */
    function getUserPlantIds(
        address userAddress
    ) external view returns (uint256[] memory) {
        return userPlantIds[userAddress];
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
        plantExistsAndAlive(plantId)
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

    // 其他函数保持不变
}
