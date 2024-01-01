// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.20;

import "../PlantBase.sol";
import "../PlantFactory.sol";

/**
 * @title PingPongChrysanthemum 乒乓菊合约
 * @author sharebravery
 * @notice 乒乓菊植物的实现
 */
contract PingPongChrysanthemum is PlantBase {
    struct PlantCreationParams {
        uint256 customAttribute;
        string color;
        string shape;
        uint8 growthSpeed;
        string name;
    }

    PlantCreationParams public plantAttributes;

    /**
     * @notice 构造函数，初始化乒乓菊
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
