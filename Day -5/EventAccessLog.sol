// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Event-Based Access Log System (Optimized for Foundry Lint)
contract EventAccessLog {
    // -----------------------------
    // State Variables
    // -----------------------------
    address public owner;

    mapping(address => bool) public writers;
    mapping(address => bool) public readers;

    // -----------------------------
    // Events
    // -----------------------------
    event WriterAdded(address indexed user);
    event WriterRemoved(address indexed user);
    event ReaderAdded(address indexed user);
    event ReaderRemoved(address indexed user);

    // -----------------------------
    // Constructor
    // -----------------------------
    constructor() {
        owner = msg.sender;
    }

    // -----------------------------
    // Wrapped Modifiers (Recommended by forge-lint)
    // -----------------------------
    modifier onlyOwner() {
        _onlyOwner();
        _;
    }

    modifier onlyWriter() {
        _onlyWriter();
        _;
    }

    modifier onlyReader() {
        _onlyReader();
        _;
    }

    function _onlyOwner() internal view {
        require(msg.sender == owner, "Only owner");
    }

    function _onlyWriter() internal view {
        require(writers[msg.sender], "Only writer");
    }

    function _onlyReader() internal view {
        require(readers[msg.sender], "Only reader");
    }

    // -----------------------------
    // Role Management (Owner-only)
    // -----------------------------
    function addWriter(address _user) external onlyOwner {
        writers[_user] = true;
        emit WriterAdded(_user);
    }

    function removeWriter(address _user) external onlyOwner {
        writers[_user] = false;
        emit WriterRemoved(_user);
    }

    function addReader(address _user) external onlyOwner {
        readers[_user] = true;
        emit ReaderAdded(_user);
    }

    function removeReader(address _user) external onlyOwner {
        readers[_user] = false;
        emit ReaderRemoved(_user);
    }

    // -----------------------------
    // Access Functions
    // -----------------------------

    /// @notice Only writer can access this
    function writeAccess() external view onlyWriter returns (string memory) {
        return "Writer access granted.";
    }

    /// @notice Only reader can access this
    function readAccess() external view onlyReader returns (string memory) {
        return "Reader access granted.";
    }
}

// Concepts used in this contract:
// 1. State Variables: 'owner', 'writers', and 'readers' manage access control.
// 2. Events: Emitted when roles are added or removed for logging purposes.
// 3. Constructor: Sets the deployer as the owner.
// 4. Modifiers: 'onlyOwner', 'onlyWriter', and 'onlyReader' restrict function access based on roles.
// 5. Role Management Functions: Allow the owner to add or remove writers and readers.
// 6. Access Functions: 'writeAccess' and 'readAccess' demonstrate role-based access control.

// Here are the definitions of some concepts and functionalities used in this contract:
// 1. State Variables: Variables that are stored on the blockchain. In this contract, 'owner' holds the address of the contract owner, while 'writers' and 'readers' are mappings that track which addresses have writer and reader permissions, respectively.
// 2. Events: Events are used to log significant actions within the contract. In this case, events are emitted whenever a writer        or reader is added or removed, providing a transparent log of role changes.
// 3. Constructor: A special function that is executed once when the contract is deployed. It initializes the 'owner' variable to the address that deployed the contract.
// 4. Modifiers: Reusable code blocks that can be applied to functions to enforce certain conditions. The 'onlyOwner', 'onlyWriter', and 'onlyReader' modifiers ensure that only addresses with the appropriate permissions can call certain functions.
// 5. Role Management Functions: Functions that allow the owner to manage writer and reader roles by adding or removing addresses from the respective mappings.
// 6. Access Functions: Functions that demonstrate role-based access control by allowing only writers to call 'writeAccess' and only readers to call    'readAccess', returning confirmation strings when access is granted.
