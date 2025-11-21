// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Array Utilities (uint256)
contract ArrayUtils {
    uint256[] private items;

    event ItemAdded(uint256 value);
    event ItemRemoved(uint256 value);

    function pushItem(uint256 _v) external {
        items.push(_v);
        emit ItemAdded(_v);
    }

    function findIndex(
        uint256 _v
    ) public view returns (bool found, uint256 index) {
        for (uint256 i = 0; i < items.length; i++) {
            if (items[i] == _v) return (true, i);
        }
        return (false, type(uint256).max);
    }

    // INTERNAL CORE LOGIC
    function _removeByIndex(uint256 _index) internal {
        require(_index < items.length, "Index OOB");
        uint256 val = items[_index];
        items[_index] = items[items.length - 1];
        items.pop();
        emit ItemRemoved(val);
    }

    // EXTERNAL WRAPPER
    function removeByIndex(uint256 _index) external {
        _removeByIndex(_index);
    }

    function removeByValue(uint256 _v) external {
        (bool found, uint256 idx) = findIndex(_v);
        require(found, "Value not found");
        _removeByIndex(idx);
    }

    function getAll() external view returns (uint256[] memory) {
        return items;
    }

    function length() external view returns (uint256) {
        return items.length;
    }
}

//Concepts Used:
// - Dynamic Arrays: Managing a dynamic array of uint256 values.
// - Events: Emitting events on addition and removal of items.
// - Internal Functions: Core logic for removal encapsulated in an internal function.
// - External Wrapper Functions: Public functions that call internal logic for better modularity.
// - Search Functionality: Finding the index of a value in the array.
// - Error Handling: Using require statements to handle out-of-bounds and not-found scenarios.
// - View Functions: Functions to retrieve the entire array and its length without modifying state.

// Here are the definition of some concepts and functionalities used in this contract:
// 1. Dynamic Arrays: The contract uses a dynamic array 'items' to store uint256 values, allowing for flexible storage that can grow or shrink as needed.
// 2. Events: The contract defines and emits 'ItemAdded' and 'ItemRemoved' events to log when items are added or removed from the array, facilitating off-chain tracking of these actions.
// 3. Internal Functions: The core logic for removing an item by index is encapsulated in the internal function '_removeByIndex', promoting code reuse and modularity.
// 4. External Wrapper Functions: Public functions like 'removeByIndex' and 'removeByValue' serve as wrappers that call the internal removal logic, providing a clean interface for users of the contract.
// 5. Search Functionality: The 'findIndex' function allows users to search for a value in the array and retrieve its index, returning a boolean to indicate if the value was found.
// 6. Error Handling: The contract employs 'require' statements to ensure that operations like removal are only performed when valid conditions are met, such as checking for out-of-bounds indices and confirming the existence of values before removal.
// 7. View Functions: The contract includes view functions like 'getAll' and 'length' that allow users to retrieve the entire array and its length without modifying the contract's state.
// These functions are marked as 'view' to indicate they do not alter the blockchain state.
