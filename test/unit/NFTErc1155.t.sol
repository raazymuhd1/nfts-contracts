// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import { Test, console } from "forge-std/Test.sol";
import { DeployNFT1155 } from "../../script/DeployERC1155.s.sol";
import { NFT1155 } from "../../src/ERC1155NFT.sol";

contract NFT1155Test is Test {
    DeployNFT1155 deployer;
    NFT1155 nft1155;

    string private constant BASE_URI = 'https://ipfs.io/ipfs/';
    uint256 private INITIAL_ID = 2;
    address private USER = makeAddr("USER");

    function setUp() public {
        deployer = new DeployNFT1155();
        nft1155 = deployer.run();

        vm.deal(USER, 10 ether);
    }

    function test_uri() public view {
        string memory expectedUri = string.concat(BASE_URI, 'QmSxqYRqvG5eSTZsKytVDx2JCQs1P3Tb2hBjPNDLkGv8rB/metadata1.json');
        string memory actualUri = nft1155.uri(0);

        console.log(actualUri, expectedUri);
        assert(keccak256(abi.encodePacked(expectedUri)) == keccak256(abi.encodePacked(actualUri)));
    }

    function test_userBalance() public  {
        vm.prank(USER);
        nft1155.mintNft(USER);
        uint256 userBalance = nft1155.getBalance(USER, INITIAL_ID);
        console.log(nft1155.getBalance(USER, 1));

        assert(userBalance == 1);
    }

    function test_transfer() public {
        address to_ = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        vm.prank(USER);
        nft1155.mintNft(USER);
        uint256 fromBalanceBfore = nft1155.getBalance(msg.sender, INITIAL_ID);
        uint256 toBalanceBfore = nft1155.getBalance(to_, INITIAL_ID);

        console.log(fromBalanceBfore);
        console.log(toBalanceBfore);
        vm.prank(USER);
        nft1155.tfInBatch(to_, 1, INITIAL_ID);
        uint256 fromBalanceAfter = nft1155.getBalance(msg.sender, INITIAL_ID);
        uint256 toBalanceAfter = nft1155.getBalance(to_, INITIAL_ID);

        assert(fromBalanceAfter == 0);
        assert(toBalanceAfter == 1);
        // vm.stopPrank();
    }
}