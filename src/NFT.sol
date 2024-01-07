// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";


/**
 * @author Mohammed Raazy
 * @notice This is a simple single or NFT collections contract
 * @dev This code will be test it
 */

contract NFT is ERC721 {

    ////////////////////// ERRORS //////////////////////////
    error NFT_AddressIsZero();
    error NFT_BalanceIsZero();
    error NFT_CanOnlyMintOnce();
    error NFT_MintFeeNeeded();
    error NFT_NotOwner();
    error NFT_FeeBalanceIsZero();
    error NFT_WithdrawFailed();

    NftDetails private s_nft;

    uint256 private constant MINT_FEE = 0.001 ether;
    uint256 private s_tokenCounter = 0;
    address private s_owner;

    mapping(uint256 tokenId => string tokenUri) private s_tokenUri;

    ///////////////// EVENTS ///////////////////
    event NFTMinted(string indexed tokenUri, address indexed minter);
    event WithdrawSuccess(address indexed owner, uint256 amount);

    struct NftDetails {
        string tokenUri;
        uint256 tokenId;
    }

    ////////////////// MODIFIERS ///////////////////
    modifier NotZeroAddress() {
        if (msg.sender == address(0)) {
            revert NFT_AddressIsZero();
        }

        _;
    }

    modifier OnlyOwner() {
        if(msg.sender != s_owner) {
            revert NFT_NotOwner();
        }
        _;
    }

    modifier BalanceMoreThanZero() {
        if (msg.sender.balance <= 0) {
            revert NFT_BalanceIsZero();
        }

        _;
    }

    constructor(string memory nftName, string memory nftSymbol) ERC721(nftName, nftSymbol) {
        s_owner = msg.sender;
    }

    receive() external payable {
        mintNFT(string.concat(_baseURI(), "QmSxqYRqvG5eSTZsKytVDx2JCQs1P3Tb2hBjPNDLkGv8rB/metadata1.json"));
    }

    //////////////// Internal & Private functions ///////////////////
     function _baseURI() internal pure override returns(string memory baseUri) {
         baseUri = "https://ipfs.io/ipfs/";
    }
    
    ///////////////// Public & External Functions ////////////////////
    function mintNFT(string memory tokenUri) public payable NotZeroAddress BalanceMoreThanZero {
        if(balanceOf(msg.sender) >= 2) {
            revert NFT_CanOnlyMintOnce();
        }

        if(msg.value <= 0 || msg.value < MINT_FEE) {
            revert NFT_MintFeeNeeded();
        }

        s_tokenUri[s_tokenCounter] = tokenUri;
        _safeMint(msg.sender, s_tokenCounter, "");
        emit NFTMinted(tokenURI(s_tokenCounter), msg.sender);
        s_tokenCounter += 1;
    }

    function withdrawMintFee() external payable OnlyOwner NotZeroAddress returns(bool) {
        address owner = s_owner;

        if(address(this).balance <= 0) {
            revert NFT_FeeBalanceIsZero();
        }
        (bool success,) = s_owner.call{value: address(this).balance}("");

        if(!success) {
            revert NFT_WithdrawFailed();
        }
        
        emit WithdrawSuccess(owner, address(this).balance);
        return success;
    }

    function tokenURI(uint256 tokenId_) public view override returns(string memory uri) {
         string memory baseUri = _baseURI();
         uri = string.concat(baseUri, s_tokenUri[tokenId_]);
    }

    function getTokenCounter() public view returns(uint256 tokenCounter) {
        tokenCounter = s_tokenCounter;
    }

}
