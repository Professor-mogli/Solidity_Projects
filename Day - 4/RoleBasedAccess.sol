// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Role-Based Access Control
contract RoleBasedAccess {
    address public admin;

    mapping(address => bool) public writers;

    event WriterAdded(address indexed user);
    event WriterRemoved(address indexed user);

    cconstructor() {
        admin = msg.sender;
    }

    // --- Wrapped Modifiers ---

    modifier onlyAdmin() {
        _onlyAdmin();
        _;
    }

    modifier onlyWriter() {
        _onlyWriter();
        _;
    }

    function _onlyAdmin() internal view {
        require(msg.sender == admin, "Not admin");
    }

    function _onlyWriter() internal view {
        require(writers[msg.sender], "Not a writer");
    }

    // --------------------------------

    function addWriter(address _user) external onlyAdmin {
        writers[_user] = true;
        emit WriterAdded(_user);
    }

    function removeWriter(address _user) external onlyAdmin {
        writers[_user] = false;
        emit WriterRemoved(_user);
    }

    function writeSomething() external pure onlyWriter returns (string memory) {
        return "You are a writer!";
    }
}

// Concepts used in this contract:
// 1. State Variables: 'admin' stores the address of the contract administrator, and 'writers' is a mapping that keeps track of addresses with writer permissions.
// 2. Events: 'WriterAdded' and 'WriterRemoved' events log changes to the writer permissions.
// 3. Modifiers: 'onlyAdmin' restricts function access to the admin, while 'onlyWriter' restricts access to addresses marked as writers.
// 4. Functions to Manage Roles: 'addWriter' and 'removeWriter' allow the admin to manage writer permissions.
// 5. Function with Role Check: 'writeSomething' can only be called by addresses with writer permissions and returns a confirmation string.

// Here are the definitions of some concepts and functionalities used in this contract:
// 1. State Variables: Variables that are stored on the blockchain. In this contract, 'admin' holds the address of the contract administrator, and 'writers' is a mapping that tracks which addresses have writer permissions.
// 2. Events: Mechanism to log information on the blockchain. Events like 'WriterAdded' and 'WriterRemoved' help track changes to the writer permissions.
// 3. Modifiers: Reusable code blocks that can be applied to functions to enforce certain conditions. The 'onlyAdmin' modifier restricts access to functions so that only the admin can execute them, while the 'onlyWriter' modifier ensures that only addresses with writer permissions can call certain functions.
// 4. Functions to Manage Roles: The 'addWriter' and 'removeWriter' functions allow the admin to grant or revoke writer permissions for specific addresses.
// 5. Function with Role Check: The 'writeSomething' function demonstrates how to use the 'onlyWriter' modifier to restrict access. It can only be called by addresses that have been granted writer permissions and returns a simple string confirming the action.
