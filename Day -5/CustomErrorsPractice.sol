// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Custom Errors Practice
contract CustomErrorsPractice {
    mapping(address => uint256) public balances;

    error Unauthorized();
    error NotEnoughBalance(uint256 available, uint256 required);
    error InvalidId(uint256 id);

    event Deposited(address indexed who, uint256 amount);
    event Withdrawn(address indexed who, uint256 amount);
    event RecordAdded(uint256 indexed id);
    event RecordDeleted(uint256 indexed id);

    uint256 private nextRecordId;
    mapping(uint256 => bool) private records;

    function deposit() external payable {
        if (msg.value == 0) revert NotEnoughBalance(0, 1);
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw(uint256 _amount) external {
        uint256 bal = balances[msg.sender];
        if (bal < _amount) revert NotEnoughBalance(bal, _amount);
        balances[msg.sender] = bal - _amount;
        (bool ok, ) = payable(msg.sender).call{value: _amount}("");
        require(ok, "Transfer failed");
        emit Withdrawn(msg.sender, _amount);
    }

    function addRecord() external returns (uint256) {
        uint256 id = nextRecordId++;
        records[id] = true;
        emit RecordAdded(id);
        return id;
    }

    function deleteRecord(uint256 _id) external {
        if (!records[_id]) revert InvalidId(_id);
        delete records[_id];
        emit RecordDeleted(_id);
    }

    // admin-only example (owner pattern)
    address public owner = msg.sender;

    function adminOnlyAction() external view {
        if (msg.sender != owner) revert Unauthorized();
    }
}

//Concepts Used:
// - Custom Errors: Defined custom error types for better gas efficiency and clarity.
// - Events: Emitted events for deposit, withdrawal, record addition, and deletion.
// - Mappings: Used mappings to track user balances and record existence.
// - Basic Access Control: Implemented a simple owner check for admin-only actions.
// - Error Handling: Used custom errors to handle insufficient balance and invalid record IDs.
// - State Variables: Managed state variables for balances, records, and ownership.
// - Functions: Created functions for deposit, withdrawal, record management, and admin actions.

// Here are the definitions of some concepts and functionalities used in this contract:
// 1. Custom Errors: Custom errors are user-defined error types that can be used with the revert statement. They are more gas-efficient than traditional require statements with error strings, especially when the error data is complex. In this contract, custom errors like Unauthorized, NotEnoughBalance, and InvalidId are defined to handle specific error scenarios.
// 2. Events: Events are used to log significant    actions within the contract. In this case, events are emitted whenever a deposit or withdrawal occurs, as well as when records are added or deleted, providing a transparent log of these actions.
// 3. Mappings: A mapping is a key-value store used to associate data.
// 4. Basic Access Control: The contract implements a simple access control mechanism by designating an owner address. The adminOnlyAction function checks if the caller is the owner before allowing access to certain functionalities.
// 5. Error Handling: The contract uses custom errors to handle specific error conditions, such as insufficient balance during withdrawals and invalid record IDs during record deletion. This approach provides clearer error reporting and is more gas-efficient.
// 6. State Variables: State variables are used to store data on the blockchain. In this contract, state variables like balances, records, and owner are used to manage user balances, track record existence, and store the contract owner's address.
// 7. Functions: The contract includes several functions to manage deposits, withdrawals, record addition and deletion, and admin-only actions. Each function performs specific tasks while utilizing the defined custom errors and events for error handling and logging.
