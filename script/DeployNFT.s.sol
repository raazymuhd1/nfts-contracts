// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Script, console } from "forge-std/Script.sol";
import { NFT } from "../src/NFT.sol";

contract DeployNFT is Script {

    address INITIAL_OWNER = 0x34699bE6B2a22E79209b8e9f9517C5e18db7eB89;
    NFT nft;


    function run(address initial_owner) public returns(NFT) {
         vm.startBroadcast();

         if(initial_owner != address(0)) {
            nft = new NFT("Bull", "Bull", initial_owner);
         } else {
            nft = new NFT("Bull", "Bull", INITIAL_OWNER);
         } 

         console.log(address(nft));

         vm.stopBroadcast();

         return nft;
    }
}