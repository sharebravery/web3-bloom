// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./ElectronicPlantBase.sol";

/**
 * @title PlantFactory 植物工厂合约
 * @author sharebravery
 * @notice 创建不同类型植物的工厂合约
 */
contract PlantFactory is Ownable {
    // 存储创建的 ElectronicPlantBase 合约地址
    mapping(uint8 => address) public plantContracts;

    // 植物种类
    enum PlantType {
        Flower,
        Tree,
        Shrub
    }

    constructor(address initialOwner) Ownable(initialOwner) {}

    /**
     * @notice 创建植物
     * @param plantType 植物类型
     * @param plantName 植物名称
     * @param plantSpecies 植物品种
     * @return 新植物合约地址
     */
    function createPlant(
        PlantType plantType,
        string memory plantName,
        string memory plantSpecies
    ) external onlyOwner returns (uint256) {
        require(uint8(plantType) <= 2, "Invalid plant type"); // Adjust the limit based on the number of plant types

        ElectronicPlantBase plantContract = new ElectronicPlantBase();
        // 设置新属性的值
        uint256 creationTime = block.timestamp;

        uint256 plantId = plantContract.createPlant(
            plantName,
            plantSpecies,
            creationTime
        );

        plantContracts[uint8(plantType)] = address(plantContract);

        return plantId;
    }

    /**
     * @notice 获取植物合约地址
     * @param plantType 植物类型
     * @return 植物合约地址
     */
    function getPlantContractAddress(
        uint8 plantType
    ) external view returns (address) {
        return plantContracts[plantType];
    }
}
