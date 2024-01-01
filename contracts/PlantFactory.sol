// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./PlantBase.sol";

/**
 * @title PlantFactory 植物工厂合约
 * @author sharebravery
 * @notice 创建不同类型植物的工厂合约
 */
contract PlantFactory is Ownable {
    // 存储创建的 ElectronicPlantBase 合约地址
    mapping(address => address) public userPlantContracts;

    constructor(address initialOwner) Ownable(initialOwner) {}

    /**
     * 植物元信息
     * @param plantContractAddress 植物名称
     * @param plantCreationData 植物品种
     */
    struct PlantCreationData {
        string plantName;
        PlantBase.PlantSpecies plantSpecies;
    }

    /**
     * 创建植物
     * @param plantContractAddress 植物合约地址 （预留扩展的 后续可用plants目录下的植物合约进行植物行为定制）
     * @param plantCreationData 植物元信息
     */
    function createPlant(
        address plantContractAddress,
        PlantCreationData memory plantCreationData
    ) external returns (uint256) {
        require(
            plantContractAddress != address(0),
            "Invalid plant contract address"
        );

        // 检查植物种类的有效性
        require(
            plantCreationData.plantSpecies == PlantBase.PlantSpecies.Flower ||
                plantCreationData.plantSpecies == PlantBase.PlantSpecies.Tree ||
                plantCreationData.plantSpecies == PlantBase.PlantSpecies.Shrub,
            "Invalid plant species"
        );

        PlantBase plantContract = PlantBase(plantContractAddress);
        // 设置新属性的值
        uint256 creationTime = block.timestamp;

        uint256 plantId = plantContract.createPlant(
            plantCreationData.plantName,
            plantCreationData.plantSpecies,
            creationTime
        );

        userPlantContracts[msg.sender] = plantContractAddress;

        return plantId;
    }

    /**
     * @notice 获取用户植物合约地址
     * @param userAddress 用户地址
     * @return 用户植物合约地址
     */
    function getUserPlantContractAddress(
        address userAddress
    ) external view returns (address) {
        return userPlantContracts[userAddress];
    }
}
