// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

/**
 * @title PlantNFT 植物标本NFT合约
 * @dev 基于 ERC721 标准
 */
contract PlantNFT is ERC721Enumerable, Ownable {
    uint256 public constant MAX_SUPPLY = 2100 * (10 ** 4);
    uint256 public constant PRICE = 0.01 ether;
    uint256 public constant MAX_SINGLE_MINT = 10; // 单次可mint最大数量

    uint256 private _nextTokenId;

    string public baseTokenURI;
    mapping(uint256 => string) private _tokenURIs;

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) Ownable(msg.sender) {}

    error Unauthorized();
    error NotEnoughNFTs();
    error NotEnoughEtherPurchaseNFTs();
    error CannotMintSpecifiedNumber();
    error CannotZeroBalance();

    // 无聊猿 ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/
    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }

    function setBaseURI(string memory _baseTokenURI) public onlyOwner {
        baseTokenURI = _baseTokenURI;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        return string(abi.encodePacked(baseTokenURI, _tokenURIs[tokenId]));
    }

    function _mintSingleNFT() private {
        uint256 tokenId = _nextTokenId;
        _safeMint(msg.sender, tokenId);
        _nextTokenId++;
    }

    /**
     * 铸造NFT
     * @param _count 铸造数量
     */
    function mint(uint256 _count) public payable returns (uint256) {
        if (_count == 0 || _count > MAX_SINGLE_MINT) {
            revert CannotMintSpecifiedNumber();
        }

        if (msg.value < _count * PRICE) {
            revert NotEnoughEtherPurchaseNFTs();
        }

        if (MAX_SUPPLY - _nextTokenId < _count) {
            revert NotEnoughNFTs();
        }

        for (uint256 i = 0; i < _count; i++) {
            _mintSingleNFT();
        }

        return _nextTokenId;
    }

    /**
     *  预留NFT
     * @param _count 保留NFT数量
     */
    function reserveNFTs(uint256 _count) public onlyOwner {
        if (_count + _nextTokenId > MAX_SUPPLY) {
            revert NotEnoughNFTs();
        }

        for (uint256 i = 0; i < _count; i++) {
            _mintSingleNFT();
        }
    }

    /**
     * 查询用户所拥有的代币
     * @param _owner 拥有者
     */
    function getTokensOfOwner(
        address _owner
    ) external view returns (uint256[] memory) {
        uint256 tokenCount = balanceOf(_owner);
        uint256[] memory tokenIdList = new uint256[](tokenCount);

        for (uint256 i = 0; i < tokenCount; i++) {
            tokenIdList[i] = tokenOfOwnerByIndex(_owner, i);
        }

        return tokenIdList;
    }

    /**
     * 提取合约余额
     */
    function withdraw() external onlyOwner {
        uint256 _balance = address(this).balance;

        if (_balance <= 0) {
            revert CannotZeroBalance();
        }

        address payable ownerPayable = payable(owner());
        ownerPayable.transfer(_balance);
    }
}
