// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Test, console } from "forge-std/Test.sol";
import { DeployNFT } from "../../script/DeployNFT.s.sol";
import { NFT } from "../../src/NFT.sol";

contract NFTTest is Test {
    NFT nft;
    DeployNFT deployer;

    uint256 constant INITIAL_BALANCE = 10 ether;
    string constant COLLECTION_BASE_URIS = 'QmSxqYRqvG5eSTZsKytVDx2JCQs1P3Tb2hBjPNDLkGv8rB/';
    address USER = makeAddr("USER");
    string[] private nftUris = ['metadata1.json', 'metadata2.json'];


    function setUp() public {
        deployer = new DeployNFT();
        nft = deployer.run();

        vm.deal(USER, INITIAL_BALANCE);
    }

    function test_tokenURI() public {
        for(uint256 i = 0; i < nftUris.length; i++) {
            vm.prank(USER);
            nft.mintNFT(string.concat(COLLECTION_BASE_URIS, nftUris[i]));
        }
        
        string memory expectedUri = 'https://ipfs.io/ipfs/QmSxqYRqvG5eSTZsKytVDx2JCQs1P3Tb2hBjPNDLkGv8rB/metadata1.json';

        console.log(nft.tokenURI(1));
        console.log(nft.getTokenCounter());
        assert(keccak256(abi.encodePacked((nft.tokenURI(0)))) == keccak256(abi.encodePacked((expectedUri))));
    }

    function test_mintNft() public {

    }
}