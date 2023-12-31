// // SPDX-License-Identifier: GPL-3.0-or-later
// pragma solidity ^0.8.20;

// import "@openzeppelin/contracts/access/Ownable.sol";
// import "./PlantNFT.sol";
// import "./plants/PingPongChrysanthemum.sol";

// /**
//  * @title PlantFactory 植物工厂合约
//  * @author sharebravery
//  * @notice 创建不同类型植物的工厂合约
//  */
// contract PlantFactory is Ownable {
//     /**
//      * @notice 枚举，用于表示不同的植物类型
//      */
//     enum PlantType {
//         PingPongChrysanthemum,
//         MoneyTree,
//         SevenDayFlower
//     }

//     // 存储 NFT 合约地址
//     PlantNFT public plantNFT;

//     // 在合约开头定义 PlantCreationParams 结构体
//     struct PlantCreationParams {
//         string customAttribute;
//         string color;
//         string shape;
//         uint256 growthSpeed;
//         string name;
//     }

//     /**
//      * @notice 设置 NFT 合约地址
//      * @param _plantNFTAddress NFT 合约地址
//      */
//     function setPlantNFTAddress(address _plantNFTAddress) external onlyOwner {
//         plantNFT = PlantNFT(_plantNFTAddress);
//     }

//     /**
//      * @notice 创建植物
//      * @param plantType 植物类型
//      * @param params 创建植物的参数
//      * @param plantNFT 植物标本NFT合约地址
//      * @return 新植物合约地址
//      */
//     function createPlant(
//         PlantType plantType,
//         PlantCreationParams memory params,
//         PlantNFT plantNFT
//     ) external onlyOwner returns (address) {
//         address newPlantAddress;

//         // 直接通过枚举获取合约地址
//         newPlantAddress = getPlantContractAddress(plantType, params);

//         // 将新植物的地址添加到 ElectronicPlantBase 集合中
//         ElectronicPlantBase(0).getPlantIds().add(uint256(newPlantAddress));

//         // 创建植物标本并转让给合约拥有者
//         uint256 tokenId = plantNFT.createPlantSpecimen(
//             plantTypeToString(plantType),
//             owner()
//         );
//         plantNFT.transferFrom(owner(), newPlantAddress, tokenId);

//         // 返回新植物的地址
//         return newPlantAddress;
//     }

//     /**
//      * @notice 获取植物合约地址
//      * @param plantType 植物类型
//      * @param params 植物的参数
//      * @return 植物合约地址
//      */
//     function getPlantContractAddress(
//         PlantType plantType,
//         PlantCreationParams memory params
//     ) internal view returns (address) {
//         // 使用 require 来检查植物类型，如果无效则回滚
//         require(plantType != PlantType.SevenDayFlower, "Invalid plant type");

//         // 根据枚举选择创建对应的植物合约
//         if (plantType == PlantType.PingPongChrysanthemum) {
//             return address(new PingPongChrysanthemum(params));
//         } else if (plantType == PlantType.MoneyTree) {
//             // 添加 MoneyTree 类型的逻辑
//         } else if (plantType == PlantType.SevenDayFlower) {
//             // 添加 SevenDayFlower 类型的逻辑
//         } else {
//             revert("Invalid plant type");
//         }
//     }

//     /**
//      * @notice 将植物类型转为字符串
//      * @param plantType 植物类型
//      * @return 字符串表示
//      */
//     function plantTypeToString(
//         PlantType plantType
//     ) internal pure returns (string memory) {
//         if (plantType == PlantType.PingPongChrysanthemum) {
//             return "PingPongChrysanthemum";
//         } else if (plantType == PlantType.MoneyTree) {
//             return "MoneyTree";
//         } else if (plantType == PlantType.SevenDayFlower) {
//             return "SevenDayFlower";
//         } else {
//             revert("Invalid plant type");
//         }
//     }
// }
