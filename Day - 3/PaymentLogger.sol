// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Payment Logger
/// @notice Receives ETH, emits events, tracks per-sender totals, owner withdraws
contract PaymentLogger {
    address public owner;
    mapping(address => uint256) public paidTotal;
    uint256 public totalReceived;

    event Received(address indexed from, uint256 amount, uint256 senderTotal);
    event Withdrawn(address indexed to, uint256 amount);

    // -------------------------------------------------
    // FIX: wrap modifier logic into an internal function
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
    }

    receive() external payable {
        _logPayment(msg.sender, msg.value);
    }

    fallback() external payable {
        _logPayment(msg.sender, msg.value);
    }

    function pay() external payable {
        _logPayment(msg.sender, msg.value);
    }

    function _logPayment(address from, uint256 value) internal {
        require(value > 0, "No ETH sent");
        paidTotal[from] += value;
        totalReceived += value;
        emit Received(from, value, paidTotal[from]);
    }

    function withdraw(uint256 amount) external onlyOwner {
        require(address(this).balance >= amount, "Insufficient balance");

        (bool ok, ) = payable(owner).call{value: amount}("");
        require(ok, "Transfer failed");

        emit Withdrawn(owner, amount);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

// Concepts used in this contract:
// 1. State Variables: 'owner', 'paidTotal', and 'totalReceived' to track ownership and payments.
// 2. Events: 'Received' and 'Withdrawn' to log significant actions.
// 3. Modifiers: 'onlyOwner' to restrict access to the withdraw function.
// 4. Receive and Fallback Functions: To handle incoming ETH payments.
// 5. Functions: 'pay', '_logPayment', 'withdraw', and 'getBalance' to manage payments and withdrawals.

// Here are the definitions of some concepts and functionalities used in this contract:
// 1. State Variables: Variables that are stored on the blockchain. 'owner' holds the contract owner's address, 'paidTotal' maps addresses to their total payments, and 'totalReceived' tracks the total ETH received by the contract.
// 2. Events: Mechanisms to log activities on the blockchain. 'Received' logs incoming payments, while 'Withdrawn' logs ETH withdrawals by the owner.
// 3. Modifiers: Code that can be reused to restrict access to functions. 'onlyOwner' ensures that only the contract owner can call the 'withdraw' function.
// 4. Receive and Fallback Functions: Special functions that allow the contract to accept ETH payments. The 'receive' function is called when ETH is sent with no data, while the 'fallback' function is called when data is sent or if no other function matches.
// 5. Functions: 'pay' allows users to send ETH, '_logPayment' updates payment records and emits events, 'withdraw' allows the owner to withdraw ETH, and 'getBalance' returns the contract's current ETH balance.





































    
