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
     * @notice 创建植物
     * @param plantContractAddress 植物合约地址
     * @param plantName 植物名称
     * @param plantSpecies 植物品种
     * @return 新植物ID
     */
    function createPlant(
        address plantContractAddress,
        string memory plantName,
        PlantBase.PlantSpecies plantSpecies
    ) external returns (uint256) {
        require(
            plantContractAddress != address(0),
            "Invalid plant contract address"
        );

        PlantBase plantContract = PlantBase(plantContractAddress);
        // 设置新属性的值
        uint256 creationTime = block.timestamp;

        uint256 plantId = plantContract.createPlant(
            plantName,
            plantSpecies,
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
