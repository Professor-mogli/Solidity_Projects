// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Allowance {
    address public owner;

    mapping(address => uint256) public allowance;

    event AllowanceGiven(address indexed user, uint256 amount);
    event Spent(address indexed user, uint256 amount);
    event OwnerChanged(address indexed newOwner);

    // -------------------------
    // FIX #1: Wrap modifier logic
    // -------------------------
    modifier onlyOwner() {
        _onlyOwner();
        _;
    }
    function _onlyOwner() internal view {
        require(msg.sender == owner, "Not owner");
    }

    // -------------------------
    // FIX #2: Wrap modifier logic
    // -------------------------
    modifier allowed(uint256 amount) {
        _allowed(amount);
        _;
    }

    function _allowd(uint256 amount) internal view {
        require(allowance[msg.sender] >= amount, "Not enough allowance");
    }

    cconstructor() {
        owner = msg.sender;
    }

    function giveAllowance(address user, uint256 amount) external onlyOwner {
        allowance[user] = amount;
        emit AllowanceGiven(user, amount);
    }

    function spend(uint256 amount) external allowed(amount) {
        allowance[msg.sender] -= amount;
        emit Spent(msg.sender, amount);
    }

    function changeOwner(address newOwner) external onlyOwner {
        owner = newOwner;
        emit OwnerChanged(newOwner);
    }
}


// Concepts used in this contract:
//1. Access Control: onlyOwner modifier to restrict certain functions to the contract owner.
//2. Allowance Management: allowed modifier to ensure users have sufficient allowance before spending.
//3. Events: Emit events for allowance changes, spending, and ownership transfer.

//Here are some keywords defined used in this contract:
//1. Access Control: A mechanism to restrict access to certain functions. The 'onlyOwner' modifier ensures that only the contract owner can call specific functions.
//2. Allowance Management: A system to manage and restrict spending limits for users. The 'allowed' modifier checks if a user has enough allowance before allowing them to spend.
//3. Events: Mechanisms to log information on the blockchain. The 'AllowanceGiven', 'Spent', and 'OwnerChanged' events log details of allowance assignments, spending actions, and ownership transfers.
//4. Modifiers: Reusable code blocks that can be applied to functions. The 'onlyOwner' and 'allowed' modifiers encapsulate access control and allowance checks, respectively.

























    
