// // SPDX-License-Identifier: GPL-3.0-or-later
// pragma solidity ^0.8.20;

// import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";

// /**
//  * @title PlantNFT 植物标本NFT合约
//  * @dev 基于 ERC721 标准
//  */
// contract PlantNFT is ERC721, Ownable {
//     using EnumerableSet for EnumerableSet.UintSet;

//     // 记录每种植物的下一个 tokenId
//     mapping(string => uint256) private _nextTokenId;

//     // 存储每种植物已经发行的 tokenId 集合
//     mapping(string => EnumerableSet.UintSet) private _issuedTokens;

//     /**
//      * @notice 构造函数
//      * @param name NFT的名称
//      * @param symbol NFT的符号
//      */
//     constructor(
//         string memory name,
//         string memory symbol
//     ) ERC721(name, symbol) {} // Pass name and symbol parameters to ERC721 constructor

//     /**
//      * @notice 创建植物标本
//      * @param plantType 植物类型
//      * @param owner 标本的拥有者
//      * @return 新标本的 tokenId
//      */
//     function createPlantSpecimen(
//         string memory plantType,
//         address owner
//     ) external onlyOwner returns (uint256) {
//         uint256 tokenId = _nextTokenId[plantType];

//         // 确保 tokenId 未被使用
//         require(
//             !_issuedTokens[plantType].contains(tokenId),
//             "Token already issued"
//         );

//         // 发行新的植物标本
//         _safeMint(owner, tokenId);

//         // 记录 tokenId 已被使用
//         _issuedTokens[plantType].add(tokenId);

//         // 增加下一个 tokenId
//         _nextTokenId[plantType]++;

//         return tokenId;
//     }

//     /**
//      * @notice 获取指定类型植物的已发行标本数量
//      * @param plantType 植物类型
//      * @return 已发行标本数量
//      */
//     function getIssuedSpecimenCount(
//         string memory plantType
//     ) external view returns (uint256) {
//         return _issuedTokens[plantType].length();
//     }

//     /**
//      * @notice 获取指定类型植物的所有标本 tokenId
//      * @param plantType 植物类型
//      * @return 所有标本 tokenId
//      */
//     function getAllSpecimenIds(
//         string memory plantType
//     ) external view returns (uint256[] memory) {
//         uint256 length = _issuedTokens[plantType].length();
//         uint256[] memory ids = new uint256[](length);

//         for (uint256 i = 0; i < length; i++) {
//             ids[i] = _issuedTokens[plantType].at(i);
//         }

//         return ids;
//     }
// }
