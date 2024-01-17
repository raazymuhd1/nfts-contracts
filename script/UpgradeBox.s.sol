// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.10;

import { Script } from "forge-std/Script.sol";
import { Box2 } from "../src/Box2.sol";
import { Box1 } from "../src/Box1.sol";
import { DevOpsTools } from "@foundry-devops/DevOpsTools.sol";

contract UpgradeBox is Script {

    function run() public returns(address proxy) {
        address recentlyDployed = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);

        vm.startBroadcast();
        Box2 box2 = new Box2();
        vm.stopBroadcast();   

        // proxy = upgradeBox(recentlyDployed, address(box2));
    }

    function upgradeBox(address proxy_, address newImplementation) public returns(address) {
        vm.startBroadcast();
        // proxy address here is an old implementation contract that call upgradeToAndCall() to upgrade to new implementation contract 
        // we use a proxy contract address and pass it to box1 contract
        // here we use a box1 interface to proxy contract
        // whenever we call this proxy contract, proxy contract will call a fallback function if no function exist with that signatures then it will delegate call to the implementation contract instead with that function signature

        /**
         * after we deployed these (proxy, implementation) contract, we always use the proxy contract on the implementation as an interface 
         */
        Box1 proxy = Box1(proxy_);
        // calling upgrade to upgrade to new implementation contract
        proxy.upgradeToAndCall(newImplementation, "");
        vm.stopBroadcast();

        return address(proxy);
    }
}
