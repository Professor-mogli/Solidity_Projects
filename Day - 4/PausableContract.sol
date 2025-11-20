// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Pausable Contract
/// @notice Emergency stop pattern via pause/unpause
contract PausableContract {
    bool public paused;
    address public owner;

    event Paused(address indexed by);
    event Unpaused(address indexed by);
    
// --- Wrapped Modifiers (Recommended by Foundry) ---

    modifier onlyOwner() {
        _onlyOwner();
        _;
    }

    modifier notPaused() {
        _notPaused();
        _;
    }

    function _onlyOwner() internal view {
        require(msg.sender == owner, "Not owner");
    }
    
    function _notPaused() internal view {
        require(!paused, "Paused");
    }

    //===============================================================
    cconstructor() {
        owner = msg.sender;
    }

    function pause() external onlyOwner {
        paused = true;
        emit Paused(msg.sender);
    }

    function unpause() external onlyOwner {
        paused = false;
        emit Unpaused(msg.sender);
    }

    function doWork() external view notPaused returns (string memory) {
        return "Work executed";
    }
}

// Concepts used in this contract:
// 1. State Variables: Storing the paused state and owner address.
// 2. Events: Emitting events for pause and unpause actions.
// 3. Modifiers: Wrapping logic for access control and pause checks.
// 4. Pause/Unpause Functions: Allowing the owner to toggle the paused state.
// 5. Function with Pause Check: Example function that can only be executed when not paused.

// Here are the definitions of some concepts and functionalities used in this contract:
// 1. State Variables: Variables that are stored on the blockchain. In this contract, 'paused' indicates whether the contract is paused, and 'owner' stores the address of the contract owner.
// 2. Events: Mechanism to log information on the blockchain. Events like 'Paused' and 'Unpaused' help track when the contract is paused or unpaused and by whom.
// 3. Modifiers: Reusable code blocks that can be applied to functions to enforce certain conditions. The 'onlyOwner' modifier restricts access to the contract owner, while the 'notPaused' modifier ensures that certain functions can only be executed when the contract is not paused.
// 4. Pause/Unpause Functions: Functions that allow the contract owner to change the paused state of the contract. This is useful for emergency situations where contract functionality needs to be temporarily disabled.
// 5. Function with Pause Check: An example function 'doWork' that demonstrates how to use the 'notPaused' modifier to restrict its execution when the contract is paused.
// This function will only execute if the contract is not paused.
// It returns a simple string indicating that work has been executed.

