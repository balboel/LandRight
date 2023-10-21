// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTLand is ERC721, ERC165, Ownable {
    uint256 public tokenCounter;
    mapping(uint256 => uint256) public certificateLandNumberToTokenId;
    mapping(uint256 => uint256) public tokenIdToPrice;
    mapping(uint256 => bool) public tokenIdToIsForSale;

    constructor() ERC721("NFTLand", "NFTL") {}

    function mintNFTFromCertificateLandNumber(uint256 certificateLandNumber, string memory tokenURI) public onlyOwner returns (uint256) {
        require(certificateLandNumberToTokenId[certificateLandNumber] == 0, "NFTLand: NFT with this certificate land number already exists");
        uint256 tokenId = tokenCounter;
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenURI);
        certificateLandNumberToTokenId[certificateLandNumber] = tokenId;
        tokenCounter = tokenCounter + 1;
        return tokenId;
    }

    function setTokenPrice(uint256 tokenId, uint256 price) public {
        require(_exists(tokenId), "NFTLand: Token does not exist");
        require(ownerOf(tokenId) == msg.sender, "NFTLand: Only the owner can set the price");
        tokenIdToPrice[tokenId] = price;
    }

    function getTokenPrice(uint256 tokenId) public view returns (uint256) {
        require(_exists(tokenId), "NFTLand: Token does not exist");
        return tokenIdToPrice[tokenId];
    }

    function putTokenForSale(uint256 tokenId) public {
        require(_exists(tokenId), "NFTLand: Token does not exist");
        require(ownerOf(tokenId) == msg.sender, "NFTLand: Only the owner can put the token for sale");
        tokenIdToIsForSale[tokenId] = true;
    }

    function removeTokenFromSale(uint256 tokenId) public {
        require(_exists(tokenId), "NFTLand: Token does not exist");
        require(ownerOf(tokenId) == msg.sender, "NFTLand: Only the owner can remove the token from sale");
        tokenIdToIsForSale[tokenId] = false;
    }

    function buyToken(uint256 tokenId) public payable {
        require(_exists(tokenId), "NFTLand: Token does not exist");
        require(tokenIdToIsForSale[tokenId], "NFTLand: Token is not for sale");
        require(msg.value == tokenIdToPrice[tokenId], "NFTLand: Incorrect amount of Ether sent");
        address payable tokenOwner = payable(ownerOf(tokenId));
        tokenOwner.transfer(msg.value);
        _transfer(tokenOwner, msg.sender, tokenId);
        tokenIdToIsForSale[tokenId] = false;
    }

    event Transfer (
        address indexed _from,
        address indexed _to,
        uint256 indexed _tokenId
    );
    
    event Approval (
        address indexed _owner,
        address indexed _approved,
        uint256 indexed _tokenId
    );


    function balanceOf(address owner) public view returns (uint256) {
        return balanceOf(owner);
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        return ownerOf(tokenId);
    }

    function getApproved(uint256 tokenId) public view returns (address) {
        return getApproved(tokenId);
    }

    function isApprovedForAll(address owner, address operator) public view returns (bool) {
        return isApprovedForAll(owner, operator);
    }

    function setApprovalForAll(address operator, bool _approved) public {
        setApprovalForAll(operator, _approved);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public {
        safeTransferFrom(from, to, tokenId, data);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, ERC721) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}