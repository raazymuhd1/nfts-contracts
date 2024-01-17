// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.10;

/**
 * @dev staging test is test on testnet / mainnet, to make sure it work as we expected after we deploy the contract to mainnet/testnet
 */

import { Test, console } from "forge-std/Test.sol";
import { NFT } from "../../src/NFT.sol";
import { DeployNFT } from "../../script/DeployNFT.s.sol";

contract NFTStagingTest is Test {

    DeployNFT deployer;
    NFT nft;

    address USER = 0x34699bE6B2a22E79209b8e9f9517C5e18db7eB89;
    address ANOTHER_USER = makeAddr("ANOTHER_USER");
    uint256 INITIAL_BALANCE = 10 ether;
    uint256 MINT_FEE = 1 ether;
    string constant BASE_URI = 'https://ipfs.io/ipfs/';
    string constant TEST_TOKEN_URI = 'QmSxqYRqvG5eSTZsKytVDx2JCQs1P3Tb2hBjPNDLkGv8rB/metadata1.json';

    string MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");

    address[] whitelisters = [USER, ANOTHER_USER];
    string tokenUri = string.concat(BASE_URI, TEST_TOKEN_URI);
    uint256 mainnetFork;

    function setUp() public {
        mainnetFork = vm.createFork(MAINNET_RPC_URL);
        // vm.selectFork(mainnetFork);
        deployer = new DeployNFT();
        nft = deployer.run(USER);

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

        nft.withdrawMintFee( address(nft).balance);
        uint256 nftContractBalance = address(nft).balance;
        uint256 ownerBalance = USER.balance;

        console.log(nftContractBalance == 0);
        console.log(ownerBalance == INITIAL_BALANCE);

        if(block.chainid == 1) {
            console.log("---------------------------");
            console.log("you're running test on the mainnet forked", block.chainid);
            console.log("---------------------------");
        }

        vm.stopPrank();

        assertEq(ownerBalance, INITIAL_BALANCE);
        assertEq(nftContractBalance, 0);
        assert(userAfterBalance > userPrevBalance);
        assert(totalWhitelistedUser == 2);
    }

}