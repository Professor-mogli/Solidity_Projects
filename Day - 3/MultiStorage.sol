// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Multi-Variable Storage
/// @notice Example contract storing different types of variables
contract MultiStorage {
    uint256 public myUint;
    string public myString;
    bool public myBool;
    address public myAddress;

    event UintUpdated(uint256 oldValue, uint256 newValue);
    event StringUpdated(string oldValue, string newValue);
    event BoolUpdated(bool oldValue, bool newValue);
    event AddressUpdated(address oldValue, address newValue);

    function setUint(uint256 _v) external {
        emit UintUpdated(myUint, _v);
        myUint = _v;
    }

    function setString(string calldata _s) external {
        emit StringUpdated(myString, _s);
        myString = _s;
    }

    function setBool(bool _b) external {
        emit BoolUpdated(myBool, _b);
        myBool = _b;
    }

    function setAddress(address _a) external {
        require(_a != address(0), "Zero address");
        emit AddressUpdated(myAddress, _a);
        myAddress = _a;
    }
}

// Concepts used in this contract:
// 1. State Variables: Storing different data types (uint256, string, bool, address).
// 2. Events: Emitting events on updates to track changes.
// 3. Public Functions: Functions to set each variable with appropriate checks.

// Here are the definitions of some concepts and functionalities used in this contract:
// 1. State Variables: Variables that are stored on the blockchain. In this contract, 'myUint', 'myString', 'myBool', and 'myAddress' are state variables that hold different types of data.
// 2. Events: Mechanism to log information on the blockchain. Events like 'UintUpdated', 'StringUpdated', 'BoolUpdated', and 'AddressUpdated' help track changes to the stored variables.
// 3. Public Functions: Functions that can be called from outside the contract. Functions like 'setUint', 'setString', 'setBool', and 'setAddress' allow users to update the respective state variables.
// 4. Require Statements: Used to enforce conditions, such as ensuring the address is not zero before updating 'myAddress'.
