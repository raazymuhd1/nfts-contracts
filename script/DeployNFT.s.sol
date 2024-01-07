// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Script, console } from "forge-std/Script.sol";
import { NFT } from "../src/NFT.sol";

contract DeployNFT is Script {

    function run() public returns(NFT) {
         vm.startBroadcast();
         NFT nft = new NFT("Bull", "Bull");
         console.log(address(nft));

         vm.stopBroadcast();

         return nft;
    }
}