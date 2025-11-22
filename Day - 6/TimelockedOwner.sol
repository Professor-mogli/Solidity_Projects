// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TimelockedOwner — delayed owner actions
contract TimelockedOwner {
    address public owner;
    uint256 public delaySeconds;

    struct PendingOwnerChange {
        address newOwner;
        uint256 readyAt;
        bool exists;
    }

    PendingOwnerChange public pending;

    event TimelockScheduled(address indexed newOwner, uint256 readyAt);
    event TimelockExecuted(
        address indexed previousOwner,
        address indexed newOwner
    );
    event TimelockCancelled();

    modifier onlyOwner() {
        _onlyOwner();
        _;
    }

    function _onlyOwner() internal view {
        require(msg.sender == owner, "Not owner");
    }

    constructor(uint256 _delaySeconds) {
        require(_delaySeconds > 0, "Zero delay");
        owner = msg.sender;
        delaySeconds = _delaySeconds;
    }

    function scheduleOwnerChange(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "Zero address");
        pending = PendingOwnerChange({
            newOwner: _newOwner,
            readyAt: block.timestamp + delaySeconds,
            exists: true
        });
        emit TimelockScheduled(_newOwner, pending.readyAt);
    }

    function executeOwnerChange() external {
        require(pending.exists, "No pending");
        require(block.timestamp >= pending.readyAt, "Not ready");
        address prev = owner;
        owner = pending.newOwner;
        delete pending;
        emit TimelockExecuted(prev, owner);
    }

    function cancelScheduledChange() external onlyOwner {
        require(pending.exists, "No pending");
        delete pending;
        emit TimelockCancelled();
    }
}

//Concept used in this contract:
//1. Ownership Management: The contract establishes an owner who has exclusive rights to schedule and cancel ownership changes.
//2. Timelock Mechanism: The contract implements a timelock mechanism that requires a delay before an ownership change can be executed. This delay is set during contract deployment.
//3. Struct for Pending Changes: A struct is used to store details of the pending ownership change, including the new owner's address, the timestamp when the change can be executed, and a flag indicating if a pending change exists.
//4. Events: The contract emits events to log significant actions, such as scheduling, executing, and canceling ownership changes. This provides transparency and an audit trail for ownership transitions.
//5. Modifiers: The onlyOwner modifier restricts certain functions to be callable only by the current owner, enforcing access control.
//6. Error Handling: The contract uses require statements to enforce conditions, such as ensuring the new owner address is not zero and that the timelock period has elapsed before executing the ownership change.
//7. State Variables: The contract maintains state variables to track the current owner, the delay duration, and the details of any pending ownership change.

// Here are the definitions of some concepts and functionalities used in this contract:
//1. Ownership Management: A common pattern in smart contracts where a specific address (the owner) has special privileges to perform certain actions within the contract.
//2. Timelock Mechanism: A security feature that introduces a delay between the scheduling of an action and its execution, allowing time for review or cancellation.
//3. Structs: A way to group related data together in Solidity. In this contract, a struct is used to encapsulate the details of a pending ownership change.
//4. Events: Events are used to log significant actions within the contract, providing transparency and allowing external systems to monitor contract activity.
//5. Modifiers: Modifiers are used to encapsulate common access control logic, making the code cleaner and more maintainable.
//6. Error Handling with require: The contract uses require statements to enforce conditions and validate inputs, reverting the transaction if the conditions are not met.
//7. State Variables: Variables that hold the state of the contract, such as the current owner, delay duration, and pending ownership change details.
