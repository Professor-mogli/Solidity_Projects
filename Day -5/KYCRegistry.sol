// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Simple KYC Registry
contract KYCRegistry {
    address public owner;
    mapping(address => bool) public isKycApproved;

    event KycApproved(address indexed user, address indexed by);
    event KycRevoked(address indexed user, address indexed by);
    event OwnerChanged(address indexed previousOwner, address indexed newOwner);

    // --------------------------
    // Wrapped Modifier (Foundry Style)
    // --------------------------
    modifier onlyOwner() {
        _onlyOwner();
        _;
    }

    function _onlyOwner() internal view {
        require(msg.sender == owner, "Not owner");
    }

    // --------------------------
    // Constructor
    // --------------------------
    constructor() {
        owner = msg.sender;
    }

    // --------------------------
    // KYC Functions
    // --------------------------
    function approveKyc(address _user) external onlyOwner {
        isKycApproved[_user] = true;
        emit KycApproved(_user, msg.sender);
    }

    function revokeKyc(address _user) external onlyOwner {
        isKycApproved[_user] = false;
        emit KycRevoked(_user, msg.sender);
    }

    // --------------------------
    // Owner Transfer
    // --------------------------
    function changeOwner(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "Zero address");
        emit OwnerChanged(owner, _newOwner);
        owner = _newOwner;
    }

    // --------------------------
    // View Function
    // --------------------------
    function checkKyc(address _user) external view returns (bool) {
        return isKycApproved[_user];
    }
}
// Concepts used in this contract:
// 1. State Variables: 'owner' stores the contract owner, and 'isKycApproved' maps user addresses to their KYC approval status.
// 2. Events: 'KycApproved', 'KycRevoked', and 'OwnerChanged' events log important actions in the contract.
// 3. Modifier: 'onlyOwner' restricts certain functions to be callable only by  the owner.
// 4. KYC Management Functions: 'approveKyc' and 'revokeKyc' allow the owner to manage KYC status of users.
// 5. Owner Transfer Function: 'changeOwner' allows the current owner to transfer ownership to a new address.
// 6. View Function: 'checkKyc' allows anyone to check if a user has KYC approval.

// Here are the definitions of some concepts and functionalities used in this contract:
// 1. State Variables: Variables that are stored on the blockchain. In this contract, 'owner' holds the address of the contract owner, while 'isKycApproved' is a mapping that tracks whether a user's address has been approved for KYC.
// 2. Events: Events are used to log significant actions within the contract. In this case, events are emitted whenever a user's KYC status is approved or revoked, as well as when ownership of the contract changes. This provides a transparent log of important actions.
// 3. Modifier: A reusable code block that can be applied to functions to enforce certain conditions. The 'onlyOwner' modifier checks if the caller of a function is the owner of the contract before allowing the function to execute.
// 4. KYC Management Functions: The 'approveKyc' and 'revokeKyc' functions allow the owner to manage the KYC status of users by updating the 'isKycApproved' mapping and emitting corresponding events.
// 5. Owner Transfer Function: The 'changeOwner' function allows the current owner to transfer ownership of the contract to a new address, ensuring that the new owner address is not the zero address.
// 6. View Function: The 'checkKyc' function is a read-only function that allows anyone to check if a specific user's address has been approved for KYC by returning the corresponding value from the 'isKycApproved' mapping.
