// SPDX-License-Identifier: MIT

// deploy and upgrade contracts BoxV1 to BoxV2

pragma solidity ^0.8.18;

import {Test, console} from "../lib/forge-std/src/Test.sol";
import {StdCheats} from "../lib/forge-std/src/StdCheats.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
import {ERC1967Proxy} from "../lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";

contract TestUpgrade is Test {
    DeployBox public deployer;
    UpgradeBox public upgrader;
    address public proxy;
    address public OWNER = makeAddr("owner");

    function setUp() public {
        deployer = new DeployBox();
        upgrader = new UpgradeBox();
        proxy = deployer.run(); // points to boxv1
    }

    //test that the proxy starts at V1 by calling a function that exist only on V2 and can only be called if it has been updated to V2
    function testProxyStartsAtV1() public {
        vm.expectRevert();
        BoxV2(proxy).setNumber(10);
    }

    function testUpgrade() public {
        BoxV2 box2 = new BoxV2();
        //upgrade V1 to V2
        upgrader.upgradeBoxV1(proxy, address(box2));

        uint256 expectedValue = 2;

        assertEq(expectedValue, BoxV2(proxy).version()); //BoxV2 on the Proxy's version

        BoxV2(proxy).setNumber(10);
        uint256 number = BoxV2(proxy).getNumber();
        assertEq(number, 10);
    }
}
