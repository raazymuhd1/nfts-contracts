// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.10;

import { Test, console } from "forge-std/Test.sol";
import { NFT } from "../../src/NFT.sol";
import { DeployNFT } from "../../script/DeployNFT.s.sol";

contract NFTINtegrationTest is Test {
    DeployNFT deployer;
    NFT nft;

    address USER = makeAddr("USER");
    address ANOTHER_USER = makeAddr("ANOTHER_USER");
    uint256 INITIAL_BALANCE = 10 ether;
    uint256 MINT_FEE = 1 ether;
    string constant BASE_URI = 'https://ipfs.io/ipfs/';
    string constant TEST_TOKEN_URI = 'QmSxqYRqvG5eSTZsKytVDx2JCQs1P3Tb2hBjPNDLkGv8rB/metadata1.json';

    address[] whitelisters = [USER, ANOTHER_USER];
    string tokenUri = string.concat(BASE_URI, TEST_TOKEN_URI);

    function setUp() public {
        deployer = new DeployNFT();
        nft = deployer.run(USER);

        console.log(address(nft));
        vm.deal(USER, INITIAL_BALANCE);
    }

    function test_mintNft() public {
        vm.startPrank(USER);
        uint256 userPrevBalance = nft.balanceOf(USER);

        nft.addWhitelist(whitelisters);
        uint256 totalWhitelistedUser = nft.getWhitelistedWallet().length;

        console.log(totalWhitelistedUser);

        nft.mintNFT{value: MINT_FEE}(tokenUri);
        uint256 userAfterBalance = nft.balanceOf(USER);
        console.log(userPrevBalance, userAfterBalance);

        vm.stopPrank();

        assert(userAfterBalance > userPrevBalance);
        assert(totalWhitelistedUser == 2);
    }


    function testFuzz_withdrawMintFeeWith(uint96 withdrawEth) public {
        vm.startPrank(USER);
        uint256 userPrevBalance = nft.balanceOf(USER);

        nft.addWhitelist(whitelisters);
        uint256 totalWhitelistedUser = nft.getWhitelistedWallet().length;

        console.log(totalWhitelistedUser);

        nft.mintNFT{value: MINT_FEE}(tokenUri);
        uint256 userAfterBalance = nft.balanceOf(USER);
        console.log(userPrevBalance, userAfterBalance);
        
        vm.assume(withdrawEth <= address(nft).balance);

        nft.withdrawMintFee(withdrawEth);
        uint256 nftContractBalance = address(nft).balance;
        uint256 ownerBalance = USER.balance;

        console.log(withdrawEth);

        console.log(nftContractBalance == 0);
        console.log(ownerBalance == INITIAL_BALANCE);

        vm.stopPrank();

        // assertEq(ownerBalance, INITIAL_BALANCE);
        // assertEq(nftContractBalance, 0);
        assert(userAfterBalance > userPrevBalance);
        assert(totalWhitelistedUser == 2);
    }
}