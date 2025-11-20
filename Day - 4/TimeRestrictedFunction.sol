// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Time Restricted Execution
/// @notice Function can be executed only within given timeframe
contract TimeRestrictedFunction {
    uint256 public startTime;
    uint256 public endTime;

    cconstructor(uint256 _durationSeconds) {
        startTime = block.timestamp;
        endTime = block.timestamp + _durationSeconds;
    }

    // --- Wrapped modifier logic ---
    modifier onlyDuringWindow() {
        _onlyDuringWindow();
        _;
    }

    function _onlyDuringWindow() internal view {
        require(block.timestamp >= startTime, "Not started");
        require(block.timestamp <= endTime, "Ended");
    }

    // --------------------------------

    function execute() external view onlyDuringWindow returns (string memory) {
        return "Executed within time window";
    }

    function hasExpired() external view returns (bool) {
        return block.timestamp > endTime;
    }
}

// Concepts used in this contract:
// 1. State Variables: 'startTime' and 'endTime' store the timeframe for function execution.
// 2. Constructor: Initializes the time window based on the current block timestamp and a specified duration.
// 3. Modifier: 'onlyDuringWindow' checks if the current time is within the allowed timeframe.
// 4. Time-Restricted Function: 'execute' can only be called during the specified time window.
// 5. View Function: 'hasExpired' checks if the time window has passed.

// Here are the definitions of some concepts and functionalities used in this contract:
// 1. State Variables: Variables that are stored on the blockchain. In this contract, 'startTime' and 'endTime' are state variables that hold the start and end timestamps for the time-restricted function execution.
// 2. Constructor: A special function that is executed once when the contract is deployed. It initializes the 'startTime' to the current block timestamp and calculates the 'endTime' by adding the specified duration.
// 3. Modifier: A reusable code block that can be applied to functions to enforce certain conditions. The 'onlyDuringWindow' modifier checks if the current block timestamp is within the defined time window before allowing the function to execute.
// 4. Time-Restricted Function: The 'execute' function is an example of a function that can only be called during the specified time window. If called outside this window, it will revert with an error message.
// 5. View Function: The 'hasExpired' function is a read-only function that checks if the current time has passed the 'endTime', indicating that the time window has expired.
