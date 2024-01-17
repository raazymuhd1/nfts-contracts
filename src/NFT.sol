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
import { UUPSUpgradeable } from "@openzeppelin/upgradeable-contracts/proxy/utils/UUPSUpgradeable.sol";
import { Initializable } from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import { OwnableUpgradeable } from "@openzeppelin/upgradeable-contracts/access/OwnableUpgradeable.sol";

/**
 * @author Mohammed Raazy
 * @notice This is a simple single or NFT collections contract
 * @dev This code will be test it
 */

contract NFT is ERC721 {

    ////////////////////// ERRORS //////////////////////////
    error NFT_AddressIsZero();
    error NFT_BalanceIsZero();
    error NFT_CanOnlyMintTwice();
    error NFT_MintFeeNeeded();
    error NFT_NotOwner();
    error NFT_FeeBalanceIsZero();
    error NFT_WithdrawFailed();
    error NFT_NotWhitelisted();
    error NFT_AlreadyWhitelisted();

    NftDetails private s_nft;

    uint256 private constant MINT_FEE = 0.001 ether;
    address[] private s_whitelists;
    uint256 private s_tokenCounter = 0;
    address private s_owner;

    mapping(uint256 tokenId => string tokenUri) private s_tokenUri;
    mapping(address user => bool whitelisted) private s_isWhitelisted;

    ///////////////// EVENTS ///////////////////
    event NFTMinted(string indexed tokenUri, address indexed minter);
    event WithdrawSuccess(address indexed owner, uint256 amount);
    event Whitelisted(address[] indexed whitelisters);

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

    modifier IsWhitelisted {
        if(!s_isWhitelisted[msg.sender]) {
            revert NFT_NotWhitelisted();
        }

        _;
    }

    constructor(string memory nftName,
    string memory nftSymbol, address owner_) ERC721(nftName, nftSymbol) {
        // _disableInitializers(); // this line tells to disable constructor from initialize any state variables
        s_owner = owner_;
    }

    // function initialize(string memory nftName, string memory nftSymbol) public initializer {
    //     __Ownable_init(msg.sender);
    //     __UUPSUpgradeable_init();

    //     s_nftName = nftName;
    //     s_nftSymbol = nftSymbol;
    // }

    receive() external payable {
        mintNFT(string.concat(_baseURI(), "QmSxqYRqvG5eSTZsKytVDx2JCQs1P3Tb2hBjPNDLkGv8rB/metadata1.json"));
    }

    //////////////// Internal & Private functions ///////////////////
     function _baseURI() internal pure override returns(string memory baseUri) {
         baseUri = "https://ipfs.io/ipfs/";
    }

    function _addWhitelist(address[] memory whitelists) internal OnlyOwner {
         address[] memory whitelisters = new address[](whitelists.length);

         for(uint i = 0; i < whitelisters.length; i++) {
            s_whitelists.push(whitelists[i]);
             if(s_isWhitelisted[whitelists[i]] == true) {
                revert NFT_AlreadyWhitelisted();
             }
              s_isWhitelisted[whitelists[i]] = true;
         }

        emit Whitelisted(whitelists);
    }
    
    ///////////////// Public & External Functions ////////////////////

    function addWhitelist(address[] memory whitelists) external OnlyOwner returns(bool) {
        _addWhitelist(whitelists);
        return true;
    }

    // function transferOwnership() external returns(address) {

    // }

    function mintNFT(string memory tokenUri) public payable NotZeroAddress BalanceMoreThanZero IsWhitelisted {
        if(balanceOf(msg.sender) >= 2) {
            revert NFT_CanOnlyMintTwice();
        }

        if(msg.value <= 0 || msg.value < MINT_FEE) {
            revert NFT_MintFeeNeeded();
        }

        s_tokenUri[s_tokenCounter] = tokenUri;
        _safeMint(msg.sender, s_tokenCounter, "");
        emit NFTMinted(tokenURI(s_tokenCounter), msg.sender);
        s_tokenCounter += 1;
    }

    function withdrawMintFee(uint256 wdAmount) external payable OnlyOwner NotZeroAddress returns(bool) {
        address owner = s_owner;
        
        if(address(this).balance <= 0) {
            revert NFT_FeeBalanceIsZero();
        }
        (bool success,) = payable(owner).call{value: wdAmount}("");

        if(!success) {
            revert NFT_WithdrawFailed();
        }
        
        emit WithdrawSuccess(owner, address(this).balance);
        return success;
    }


    /**
     * @dev transfer NFT { "from" to "to" }
     */
    function transferNft(uint256 tokenId, address to_) external NotZeroAddress returns(bool success) {
        if(balanceOf(msg.sender) <= 0) {
            revert NFT_BalanceIsZero();
        }
        _safeTransfer(msg.sender, to_, tokenId);
        success = true;
    }


    function tokenURI(uint256 tokenId_) public view override returns(string memory uri) {
         string memory baseUri = _baseURI();
         uri = string.concat(baseUri, s_tokenUri[tokenId_]);
    }

    function getTokenCounter() public view returns(uint256 tokenCounter) {
        tokenCounter = s_tokenCounter;
    }

    function getBaseURI() external pure returns(string memory baseUri) {
        baseUri = _baseURI();
    }

    function getWhitelistedWallet() public view returns(address[] memory whitelisted) {
        whitelisted = s_whitelists;
    } 

    function checkIsWhitelisted(address user) public view returns(bool) {
        bool whitelisted = s_isWhitelisted[user];

        if(whitelisted == true) {
            return true;
        }

        return false;
    }

}
