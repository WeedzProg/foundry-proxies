// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// NOTE: Deploy this contract first
contract B {
    // NOTE: storage layout must be the same as contract A
    uint public num;
    address public sender;
    uint public value;

    function setVars(uint _num) public payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract A {
    //what if we change the type of the 0th slot
    uint public num;
    //if boolean if zero = false, if other than zero returns true
    //bool public num;
    // if an address num become an hexadecimal value, let say we pass 0123 it will then become : 0x000000000000000000000000000000000000007B
    //address public num;
    address public sender;
    uint public value;

    function setVars(address _contract, uint _num) public payable {
        // A's storage is set, B is not modified.
        (bool success, bytes memory data) = _contract.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
    }
}
