// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetwork;

    struct NetworkConfig {
        address nftContract;
    }

    constructor() {
        if (block.chainid == 11555111) {
            activeNetwork = getSepoliaNetwork();
        } else {
            activeNetwork = getAnvilNetwork();
        }
    }

    function getSepoliaNetwork() public view returns (NetworkConfig memory) {}

    function getAnvilNetwork() public view returns (NetworkConfig memory) {}
}
