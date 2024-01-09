// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Script, console } from "forge-std/Script.sol";
import { NFT1155 } from "../src/ERC1155NFT.sol";

contract DeployNFT1155 is Script {

    function run() public returns(NFT1155) {
         vm.startBroadcast();
         NFT1155 nftErc1155 = new NFT1155();
         console.log(address(nftErc1155));

         vm.stopBroadcast();

         return nftErc1155;
    }
}