// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.10;

import { UUPSUpgradeable } from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol"; // contains all the upgrade logic
import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";


contract Box1 is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    uint256 internal count;

    // u cannot initialize anything inside a constructor of an upgradable contract ( could cause a clash with proxy contract )
    constructor() {
        _disableInitializers(); // this will prevent any initialization to any state variable of this implementation contract inside this constructor
    }

    /**
     * @dev this initilize function will be call by proxy contract only once, cannot be call from this contract
     */
    function _initialize() public initializer {
        __Ownable_init(msg.sender); // initialze the owner as msg.sender;
        __UUPSUpgradeable_init();
    }

    function setCount() external returns(uint256) {
        count += 1;

        return count;
    }

    function version() external pure returns(uint256 version_) {
        version_ = 1;
    }

    // authorize an upgrade ability
    function _authorizeUpgrade(address newImplementation) internal virtual override {}

}