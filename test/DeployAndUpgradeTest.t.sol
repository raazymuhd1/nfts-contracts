// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.10;

import { Test, console } from "forge-std/Test.sol";
import { DeployBox } from "../script/DeployBox.s.sol";
import { UpgradeBox } from "../script/UpgradeBox.s.sol";
import { Box1 } from "../src/Box1.sol";
import { Box2 } from "../src/Box2.sol";

contract DeployAndUpgradeTest is Test {
    DeployBox boxDeployer;
    UpgradeBox boxUpgrader;
    Box2 box2;
    address proxy;

    function setUp() public {
        boxDeployer = new DeployBox();
        boxUpgrader = new UpgradeBox();
        box2 = new Box2();
        proxy = boxDeployer.run();
         boxUpgrader.upgradeBox(proxy, address(box2));
    }

    function test_upgradeBox() public {
        uint256 expectedVersion = 2;
        console.log(expectedVersion == box2.version());
        assert(expectedVersion == box2.version());
    }

    function test_addNumber() public {
        uint256 expectedCount = 2;
        Box2 box2_ = Box2(proxy);
       
       box2_.setCount();
       uint256 countValue = box2_.getCount();
       console.log(countValue);

       assert(expectedCount == 2);
    }
}