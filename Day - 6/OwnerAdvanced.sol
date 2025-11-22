// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title OwnerAdvanced — ownership with nomination pattern
contract OwnerAdvanced {
    address public owner;
    address public nominatedOwner;

    event OwnershipNominated(
        address indexed currentOwner,
        address indexed nominated
    );
    event OwnershipAccepted(
        address indexed previousOwner,
        address indexed newOwner
    );
    event OwnershipRenounced(address indexed previousOwner);

    error NotOwner();
    error NotNominated();
    error ZeroAddress();

    modifier onlyOwner() {
        _onlyOwner();
        _;
    }

    modifier onlyNominated() {
        _onlyNominated();
        _;
    }

    function _onlyOwner() internal view {
        if (msg.sender != owner) revert NotOwner();
    }

    function _onlyNominated() internal view {
        if (msg.sender != nominatedOwner) revert NotNominated();
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice nominate a new owner (must be accepted by nominee)
    function nominateNewOwner(address _newOwner) external onlyOwner {
        if (_newOwner == address(0)) revert ZeroAddress();
        nominatedOwner = _newOwner;
        emit OwnershipNominated(owner, _newOwner);
    }

    /// @notice accept ownership (called by nominated owner)
    function acceptOwnership() external onlyNominated {
        address prev = owner;
        owner = nominatedOwner;
        nominatedOwner = address(0);
        emit OwnershipAccepted(prev, owner);
    }

    /// @notice renounce ownership (explicit)
    function renounceOwnership() external onlyOwner {
        address prev = owner;
        owner = address(0);
        emit OwnershipRenounced(prev);
    }
}

//Concept that uses in this code.
//1. Ownership Nomination Pattern: The contract implements a two-step ownership transfer process where the current owner nominates a new owner, and the nominated owner must explicitly accept the ownership. This pattern enhances security by preventing accidental transfers and ensuring that the new owner is aware of their role.
//2. Custom Error Handling: Instead of using traditional require statements with error messages, the contract defines custom error types (NotOwner, NotNominated, ZeroAddress) and uses revert statements. This approach is more gas-efficient and provides clearer error handling.
//3. Events for Transparency: The contract emits events (OwnershipNominated, OwnershipAccepted, OwnershipRenounced) to log significant actions related to ownership changes. This transparency is crucial for tracking ownership history and auditing contract interactions.
//4. Access Control Modifiers: The contract uses modifiers (onlyOwner, onlyNominated) to restrict access to certain functions based on the caller's role. This ensures that only authorized parties can perform sensitive operations like nominating or accepting ownership.
//5. State Variables: The contract maintains state variables (owner, nominatedOwner) to keep track of the current owner and the nominated owner. These variables are essential for enforcing access control and managing ownership transitions.

//Here are the definitions of some concepts and functionalities used in this contract:
//1. Ownership Nomination Pattern: A security pattern where the current owner of a contract nominates a new owner, who must then accept the nomination to become the new owner. This two-step process helps prevent accidental ownership transfers.
//2. Custom Error Handling: Instead of using require statements with error messages, custom error types are defined and used with revert statements. This method is more gas-efficient and provides clearer error handling.
//3. Events: Events are used to log significant actions in the contract, such as nominating a new owner, accepting ownership, and renouncing ownership. These logs can be monitored off-chain for transparency and auditing.
//4. Access Control Modifiers: Modifiers are reusable code blocks that restrict access to certain functions based on the caller's role (e.g., only the owner or only the nominated owner can call specific functions).
//5. State Variables: Variables that store the current state of the contract, such as the current owner and the nominated owner. These variables are essential for managing ownership and enforcing access control.
