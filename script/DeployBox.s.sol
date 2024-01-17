pragma solidity ^0.8.10;

import { Script } from "forge-std/Script.sol";
import { Box1 } from "../src/Box1.sol";
import { ERC1967Proxy } from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployBox is Script {

    function run() public returns(address proxy) {
        proxy = deployBox();
    }

    function deployBox() public returns(address) {
        Box1 box = new Box1();
        
        /**
         * @param - address of implementation contract
         * @param - bytes data, passing a function initilize selector
         */
        ERC1967Proxy proxy = new ERC1967Proxy(address(box), "");

        return address(proxy);
    }

}