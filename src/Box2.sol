// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.10;

import { UUPSUpgradeable } from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol"; // contains all the upgrade logic
import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";


contract Box2 is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    uint256 internal count;

    // u cannot initialize anything inside a constructor of an upgradable contract ( could cause a clash with proxy contract )
    // we can just omit/remove this constructor, but, its good practice to have it with disableInitilizers function in it
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
        count += 2;

        return count;
    }

    function version() external pure returns(uint256 version_) {
        version_ = 2;
    }

    function getCount() external view returns(uint256 count_) {
        count_ = count;
    }

    // authorize an upgrade ability
    function _authorizeUpgrade(address newImplementation) internal virtual override {}

}