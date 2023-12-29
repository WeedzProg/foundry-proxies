// SPDX-License-Identifier: MIT

//uups proxy
// this contract contains all the upgradibility of the proxy as well
pragma solidity ^0.8.18;

// import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
// import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
//import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {UUPSUpgradeable} from "../lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "../lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "../lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";

contract BoxV2 is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    //actually proxy cant have a constructor, so we need to use initializer from openzeppelin to initialize the implementation first and then do the upgrade
    // the below is a verbose way to do it, we could just delete it, it would be the same
    //@custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    //but let say that if we do want or need to have a constructor we do the below
    function initialize() public initializer {
        // and if we want to set an owner at deployment like in a normal contract by using a constructor we can do the below
        __Ownable_init(msg.sender);

        //Optional but good to have, to say "this is an UUPS contract treat as such"
        __UUPSUpgradeable_init();

        //we need to call the initializer of the parent contract
        //we need to do this because we are using multiple inheritance
        //and we need to initialize all the contracts
        // so instead of the implementation having the storage by using a constructor, we want the proxy to have the storage by using the initializer
    }

    uint256 internal number;

    function setNumber(uint256 _number) external {
        number = _number;
    }

    function getNumber() external view returns (uint256) {
        return number;
    }

    function version() public pure returns (uint256) {
        return 2;
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}
