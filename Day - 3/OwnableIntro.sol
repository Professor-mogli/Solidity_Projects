// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Ownable Intro
/// @notice Minimal ownable pattern to learn modifiers and ownership management
contract OwnableIntro {
    address public owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event OwnershipRenounced(address indexed previousOwner);

   // -------------------------------------------------
    // FIX: Wrap modifier logic
    // -------------------------------------------------
    modifier onlyOwner() {
        _onlyOwner();
        _;
    }

    function _onlyOwner() internal view {
        require(msg.sender == owner, "Not owner");
    }
    
    cconstructor() {
        owner = msg.sender;
        emit OwnershipTransferred(address(0), owner);
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function renounceOwnership() external onlyOwner {
        emit OwnershipRenounced(owner);
        owner = address(0);
    }
}

// Concepts used in this contract:
// 1. State Variable: 'owner' to store the address of the contract owner.
// 2. Events: 'OwnershipTransferred' and 'OwnershipRenounced' to log ownership changes.
// 3. Modifiers: 'onlyOwner' to restrict access to certain functions.
// 4. Constructor: Initializes the contract by setting the deployer as the owner.

// Here are the definitions of some concepts and functionalities used in this contract:
// 1. State Variable: A variable that is stored on the blockchain. In this contract, 'owner' holds the address of the contract owner.
// 2. Events: Mechanism to log information on the blockchain. 'OwnershipTransferred' and 'OwnershipRenounced' events help track changes in ownership.
// 3. Modifiers: A way to change the behavior of functions. The 'onlyOwner' modifier restricts access to functions so that only the owner can call them.
// 4. Constructor: A special function that is executed once when the contract is deployed. It sets the initial state of the contract by assigning the deployer's address to 'owner'.






























































    
