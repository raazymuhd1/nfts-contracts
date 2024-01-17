// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Test, console } from "forge-std/Test.sol";
import { Vm } from "forge-std/Vm.sol";
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
    address ANOTHER_USER = makeAddr("ANOTHER_USER");
    address NON_WHITELIST = makeAddr("NON_WHITELIST");

    address[] whitelisters = [USER, ANOTHER_USER];
    string[] private nftUris = ['metadata1.json', 'metadata2.json'];
    string tokenUri = string.concat(BASE_URI, TEST_TOKEN_URI);


    function setUp() public {
        deployer = new DeployNFT();
        nft = deployer.run(USER);

        vm.deal(USER, INITIAL_BALANCE);

        // vm.prank(USER);
        // nft.addWhitelist(whitelisters);
    }


    modifier Whitelisted{
        vm.prank(USER);
        nft.addWhitelist(whitelisters);
        _;
    }


    function test_addWhitelistNotByOwner() public {
        vm.prank(ANOTHER_USER);
        uint256 totalWhitelisted = nft.getWhitelistedWallet().length;

        vm.expectRevert(NFT.NFT_NotOwner.selector);
        nft.addWhitelist(whitelisters);

        assert(totalWhitelisted == 2);
    }

    function test_addWhitelistByOwner() public {
        vm.startPrank(USER);
        nft.addWhitelist(whitelisters);
        uint256 totalWhitelisted = nft.getWhitelistedWallet().length;
        bool isWhitelisted = nft.checkIsWhitelisted(USER);
        vm.stopPrank();

        console.log(totalWhitelisted);
        console.log(isWhitelisted);
        assertEq(isWhitelisted, true);
        assertEq(totalWhitelisted, 2);
    }

    function test_shouldEmitWhitelistedEvent() public {
        // this will also check event topic), topic2, topic3
        // topic0 always true by default
        vm.expectEmit(true, false, false, false, address(nft));
        vm.recordLogs();
        emit NFT.Whitelisted(whitelisters);

        Vm.Log[] memory logs = vm.getRecordedLogs();

        console.log(logs.length);

        vm.prank(USER);
        nft.addWhitelist(whitelisters);

        // assert(USER == logs);
        assertEq(logs.length, 2);
    }

    function test_onlyCanMintOnce() public Whitelisted {
        vm.startPrank(USER);
        nft.mintNFT{value: TEST_FEE}(tokenUri);
        nft.mintNFT{value: TEST_FEE}(tokenUri);
        uint256 balance = nft.balanceOf(USER);

        console.log(balance);
        vm.stopPrank();

        vm.startPrank(USER);
        vm.expectRevert(NFT.NFT_CanOnlyMintTwice.selector);
        nft.mintNFT{value: TEST_FEE}(tokenUri);
        uint256 currentTokenId = nft.getTokenCounter();
        console.log(currentTokenId);
        vm.stopPrank();

        assertEq(balance, 2);
        assert(currentTokenId == 2);
    }

    function test_mintWithoutPassingFee() public Whitelisted {
        vm.startPrank(USER);
        uint256 userBalance = nft.balanceOf(USER);

        vm.expectRevert(NFT.NFT_MintFeeNeeded.selector);
        nft.mintNFT(tokenUri);

        vm.stopPrank();
        console.log(userBalance);

        assert(userBalance == 0);
    }

    function test_mintByNonWhitelistedUser() public {
         vm.startPrank(NON_WHITELIST);
         uint256 userBalance = nft.balanceOf(NON_WHITELIST);
         string memory expectedUri = nft.tokenURI(0);

         vm.stopPrank();

         vm.expectRevert(NFT.NFT_NotWhitelisted.selector);
         nft.mintNFT(string.concat(BASE_URI, TEST_TOKEN_URI));
         console.log(userBalance);

         assert(userBalance == 0);
         assert(keccak256(abi.encodePacked(expectedUri)) == keccak256(abi.encodePacked(BASE_URI)));
    }

    function test_mintNftByWhitelistedUser() public Whitelisted {
        vm.startPrank(USER);
        uint256 prevBalance = nft.balanceOf(USER);

        nft.mintNFT{value: TEST_FEE}(tokenUri);
        uint256 afterBalance = nft.balanceOf(USER);

        vm.stopPrank();
        console.log(afterBalance, prevBalance);

        assert(prevBalance != afterBalance);
        assertEq(afterBalance, 1);
    }

    function test_tokenURI() public {
        for(uint256 i = 0; i < nftUris.length; i++) {
            vm.prank(USER);
            nft.mintNFT{value: 0.2 ether}(string.concat(COLLECTION_URIS, nftUris[i]));
        }
        
        string memory expectedUri = 'https://ipfs.io/ipfs/QmSxqYRqvG5eSTZsKytVDx2JCQs1P3Tb2hBjPNDLkGv8rB/metadata1.json';

        // console.log(nft.getTokenCounter());
        vm.prank(USER);
        string memory tokenZero = nft.tokenURI(0);
        console.log(tokenZero);
        assert(keccak256(abi.encodePacked((tokenZero))) == keccak256(abi.encodePacked((expectedUri))));
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
        nft.mintNFT{value: TEST_FEE}(string.concat(BASE_URI, TEST_TOKEN_URI));
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