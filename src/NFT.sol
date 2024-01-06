// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";

contract NFT is ERC721 {
    error NFT_AddressIsZero();
    error NFT_BalanceIsZero();

    uint256 private s_tokenCounter = 0;

    address private s_owner;

    constructor(string memory nftName, string memory nftSymbol) ERC721(nftName, nftSymbol) {
        s_owner = msg.sender;
    }

    modifier NotZeroAddress() {
        if (msg.sender == address(0)) {
            revert NFT_AddressIsZero();
        }

        _;
    }

    modifier BalanceMoreThanZero() {
        if (msg.sender.balance <= 0) {
            revert NFT_BalanceIsZero();
        }

        _;
    }

    function mintNFT() external NotZeroAddress BalanceMoreThanZero {
        _safeMint(msg.sender, s_tokenCounter, "");
        s_tokenCounter += 1;
    }

    function _baseURI() internal pure override returns(string memory) {
         string memory baseUri = "ipfs://";
         return baseUri;
    }

    function tokenURI(uint256 tokenId) public pure override returns(string memory) {
         string memory baseUri = _baseURI();
         string memory tokenUri = string.concat(string(bytes(abi.encodePacked(baseUri, Strings.toString(tokenId)))));
         return tokenUri;
    }
}
