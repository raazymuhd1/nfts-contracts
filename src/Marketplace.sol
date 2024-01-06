// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/**
 * @author Mohammed Raazy
 * @notice this is an NFT Marketplace built by Raazy's Team
 */

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NFTMarketplace {
    error NFTMarketplace_NotOwner();

    uint256 private s_listingFee = 0.01 ether;
    address private s_operator;

    mapping(address => ListingDetails) private s_listingDetails;
    mapping(address user => mapping(address nft => NftPrice)) private s_nftPrice;

    IERC721 s_nft;

    struct NftPrice {
        uint256 floorPrice;
        uint256 price;
    }

    struct ListingDetails {
        address owner;
        address contractAddr;
        string name;
        string symbol;
        string[] tokenUris;
        uint256[] tokenId;
    }

    constructor(address nftAddress) {
        s_nft = IERC721(nftAddress);
    }

    modifier OnlyOwner(address owner) {
        if (msg.sender != s_listingDetails[owner].owner) {
            revert NFTMarketplace_NotOwner();
        }

        _;
    }

    ///////////////// Internal & Private functions /////////////////

    function _listing() internal OnlyOwner(msg.sender) returns (bool) {
        s_nft.setApprovalForAll(address(this), true);
    }

    ////////////////// Public & External functions /////////////////
    function listing() external {}

    function cancelListing() external {}

    function buyNft() external {}

    function sellNft() external {}

    function getListingFee() external view returns (uint256 listFee) {
        listFee = s_listingFee;
    }
}
