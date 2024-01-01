// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.20;

import "../PlantBase.sol";
import "../PlantFactory.sol";

/**
 * @title SevenDayFlower 七日花合约
 * @author sharebravery
 * @notice 七日花植物的实现
 */
contract SevenDayFlower is PlantBase {
    struct PlantAttributes {
        uint256 customAttribute;
        string color;
        string shape;
        uint8 growthSpeed;
        string name;
    }

    PlantAttributes public plantAttributes;

    /**
     * @notice 构造函数，初始化
     * @param params 创建植物的参数
     */
    constructor(PlantAttributes memory params) {
        plantAttributes.customAttribute = params.customAttribute;
        plantAttributes.color = params.color;
        plantAttributes.shape = params.shape;
        plantAttributes.growthSpeed = params.growthSpeed;
        plantAttributes.name = params.name;
    }
}
