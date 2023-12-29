// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "../lib/forge-std/src/Script.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";
import {BoxV2} from "../src/BoxV2.sol";
import {ERC1967Proxy} from "../lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {BoxV1} from "../src/BoxV1.sol";

contract UpgradeBox is Script {
    function run() external returns (address) {
        // use the most recently deployed contract to interact with
        address mostRecentlyDeployedLogic = DevOpsTools.get_most_recent_deployment(
            "ERC1967Proxy",
            block.chainid
        );

        //deploy BoxV2
        vm.startBroadcast();
        BoxV2 newBox = new BoxV2();
        vm.stopBroadcast();

        address proxy = upgradeBoxV1(mostRecentlyDeployedLogic, address(newBox));
        return proxy;
    }

    function upgradeBoxV1(address _proxy, address _newLogic) public returns (address) {
        //since we cant call function on an address, we need to call on the ABI the function we need

        vm.startBroadcast();
        //gives to the proxy address, the BoxV1 ABI
        BoxV1 proxy = BoxV1(_proxy); // can also be wrapped directly in the call of BoxV2 , or directly call the function
        //upgradeTo, is a function of the UUPSUpgradeable contract
        // Upgrade BoxV1 to BoxV2
        proxy.upgradeToAndCall(address(_newLogic), "");
        vm.stopBroadcast();
        return address(_proxy);
    }
}
