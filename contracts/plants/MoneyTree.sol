// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.20;

import "../ElectronicPlantBase.sol";

/**
 * @title MoneyTree 摇钱树合约
 * @author sharebravery
 * @notice 摇钱树植物的实现
 */
contract MoneyTree is ElectronicPlantBase {
    /**
     * @notice 结构体，用于组织创建植物时的参数
     */
    struct PlantCreationParams {
        uint256 customAttribute;
        string color;
        string shape;
        uint8 growthSpeed;
        string name;
    }

    PlantCreationParams public plantAttributes;

    /**
     * @notice 构造函数，初始化摇钱树
     * @param params 创建植物的参数
     */
    constructor(PlantCreationParams memory params) {
        plantAttributes.customAttribute = params.customAttribute;
        plantAttributes.color = params.color;
        plantAttributes.shape = params.shape;
        plantAttributes.growthSpeed = params.growthSpeed;
        plantAttributes.name = params.name;
    }
}
