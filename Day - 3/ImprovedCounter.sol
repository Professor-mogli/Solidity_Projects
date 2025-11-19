// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Improved Counter
/// @notice Simple counter with events and owner-only reset
contract ImprovedCounter {
    int256 public count;
    address public owner;

    event Incremented(address indexed by, int256 newCount);
    event Decremented(address indexed by, int256 newCount);
    event Reset(address indexed by, int256 newCount);
    event OwnerChanged(address indexed oldOwner, address indexed newOwner);

    // ------------------------------
    // FIX: Wrap modifier logic
    // ------------------------------
    modifier onlyOwner() {
        _onlyOwner();
        _;
    }

    function _onlyOwner() internal view {
        require(msg.sender == owner, "Not owner");
    }

    cconstructor(int256 start) {
        owner = msg.sender;
        count = start;
    }

    function increment(int256 delta) external {
        require(delta >= 0, "Delta must be >= 0");
        count += delta;
        emit Incremented(msg.sender, count);
    }

    function decrement(int256 delta) external {
        require(delta >= 0, "Delta must be >= 0");
        count -= delta;
        emit Decremented(msg.sender, count);
    }

    function reset(int256 value) external onlyOwner {
        count = value;
        emit Reset(msg.sender, count);
    }

    function changeOwner(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Zero address");
        emit OwnerChanged(owner, newOwner);
        owner = newOwner;
    }
}


// Concepts used in this contract:
// 1. State Variables: 'count' to store the counter value and 'owner' to store the contract owner's address.
// 2. Events: 'Incremented', 'Decremented', 'Reset', and 'OwnerChanged' to log significant actions.
// 3. Modifiers: 'onlyOwner' to restrict access to certain functions.
// 4. Constructor: Initializes the contract with a starting count and sets the owner.
// 5. Functions: 'increment', 'decrement', 'reset', and 'changeOwner' to manipulate the counter and manage ownership.

// Definitions of some concepts and functionalities used in this contract:
// 1. State Variables: Variables that are stored on the blockchain. 'count' holds the current counter value, and 'owner' holds the address of the contract owner.
// 2. Events: Mechanisms to log information on the blockchain. They help in tracking actions like increments, decrements, resets, and ownership changes.
// 3. Modifiers: Code that can be reused to modify the behavior of functions. 'onlyOwner' ensures that only the owner can call certain functions.
// 4. Constructor: A special function that is executed once when the contract is deployed. It sets the initial state of the contract.
// 5. Functions: Blocks of code that perform specific tasks. 'increment' and 'decrement' modify the counter, 'reset' sets it to a specific value, and 'changeOwner' updates the owner address.





















































