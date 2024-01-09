// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Test, console } from "forge-std/Test.sol";
import { DeployNFT } from "../../script/DeployNFT.s.sol";
import { NFT } from "../../src/NFT.sol";

contract NFTTest is Test {
    NFT nft;
    DeployNFT deployer;

    uint256 constant INITIAL_BALANCE = 10 ether;
    uint256 constant TEST_FEE = 1 ether;
    string constant BASE_URI = 'https://ipfs.io/ipfs/';
    string constant COLLECTION_URIS = 'QmSxqYRqvG5eSTZsKytVDx2JCQs1P3Tb2hBjPNDLkGv8rB/';
    string constant TEST_TOKEN_URI = 'QmSxqYRqvG5eSTZsKytVDx2JCQs1P3Tb2hBjPNDLkGv8rB/metadata1.json';

    address USER = makeAddr("USER");
    string[] private nftUris = ['metadata1.json', 'metadata2.json'];


    function setUp() public {
        deployer = new DeployNFT();
        nft = deployer.run();

        vm.deal(USER, INITIAL_BALANCE);
        vm.prank(USER);
        nft.mintNFT{value: TEST_FEE}(TEST_TOKEN_URI);
    }

    function test_tokenURI() public {
        for(uint256 i = 0; i < nftUris.length; i++) {
            vm.prank(USER);
            nft.mintNFT(string.concat(COLLECTION_URIS, nftUris[i]));
        }
        
        string memory expectedUri = 'https://ipfs.io/ipfs/QmSxqYRqvG5eSTZsKytVDx2JCQs1P3Tb2hBjPNDLkGv8rB/metadata1.json';

        console.log(nft.tokenURI(1));
        console.log(nft.getTokenCounter());
        assert(keccak256(abi.encodePacked((nft.tokenURI(0)))) == keccak256(abi.encodePacked((expectedUri))));
    }

    function test_BaseUri() public {
        string memory expectedBaseUri = 'https://ipfs.io/ipfs/';
        string memory actualBaseUri = nft.getBaseURI();

        console.log(expectedBaseUri, actualBaseUri);

        assert(keccak256(abi.encodePacked(expectedBaseUri)) == keccak256(abi.encodePacked(actualBaseUri)));
    }

    function test_transferNft() public payable {
        address to_ = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

        vm.startPrank(USER);
        nft.transferNft(0, to_);
        uint256 balanceTo = nft.balanceOf(to_);
        uint256 balanceFrom = nft.balanceOf(USER);

        console.log(balanceFrom);
        console.log(nft.balanceOf(to_));

        assert(balanceFrom == 0);
        assert(balanceTo == 1);
        vm.stopPrank();
    }
}