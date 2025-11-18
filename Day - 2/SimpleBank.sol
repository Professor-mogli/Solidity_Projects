// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleBank {
    struct Account {
        uint256 balance;
        bool exists;
    }

    mapping(address => Account) private accounts;

    // -------------------------------
    // FIX #1: Wrap modifier logic
    // -------------------------------
    modifier onlyExistingUser() {
        _onlyExistingUser();
        _;
    }

    function _onlyExistingUser() internal view {
        require(accounts[msg.sender].exists, "Account does not exist");
    }

    event AccountCreated(address user);
    event Deposited(address user, uint256 amount);
    event Withdrawn(address user, uint256 amount);

    function createAccount() external {
        require(!accounts[msg.sender].exists, "Already exists");

        // -------------------------------
        // FIX #2: Use named struct fields
        // -------------------------------
        accounts[msg.sender] = Account({balance: 0, exists: true});

        emit AccountCreated(msg.sender);
    }

    function deposit() external payable onlyExistingUser {
        accounts[msg.sender].balance += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external onlyExistingUser {
        require(accounts[msg.sender].balance >= amount, "Insufficient balance");

        accounts[msg.sender].balance -= amount;

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Withdraw failed");

        emit Withdrawn(msg.sender, amount);
    }

    function getMyBalance() external view returns (uint256) {
        return accounts[msg.sender].balance;
    }
}

// Concepts used in this contract:
// 1. Structs: Define a struct to hold account details.
// 2. Mappings: Use a mapping to associate addresses with their accounts.
// 3. Modifiers: Implement a modifier to restrict access to existing users.

// Here are some keywords defined used in this contract:
// 1. Structs: Custom data types that group related variables. In this contract, 'Account' is a struct that holds an account's balance and existence status.
// 2. Mappings: A data structure that associates keys with values. The 'accounts' mapping links an address to its corresponding Account struct.
// 3. Modifiers: Reusable code blocks that can be applied to functions. The 'onlyExistingUser' modifier ensures that only users with existing accounts can call certain functions.
// 4. Events: Mechanisms to log information on the blockchain. The 'AccountCreated', 'Deposited', and 'Withdrawn' events log actions performed on user accounts.
