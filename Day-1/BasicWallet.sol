// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// Basic Wallet - Deposit and withdraw ETH
contract BasicWallet {
    address public owner;

    event Deposited(address indexed from, uint256 amount);
    event Withdrawn(address indexed to, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        _onlyOwner(); // only the function call remains
        _;
    }

    function _onlyOwner() internal view {
        require(msg.sender == owner, "Not owner");
    }

    // deposit ETH into contract
    receive() external payable {
        emit Deposited(msg.sender, msg.value);
    }

    // fallback to accept ETH sent with data
    fallback() external payable {
        emit Deposited(msg.sender, msg.value);
    }

    // withdraw specified amount to owner
    function withdraw(uint256 _amount) external onlyOwner {
        require(address(this).balance >= _amount, "Insufficient balance");

        (bool sent, ) = payable(owner).call{value: _amount}("");
        require(sent, "Transfer failed");

        emit Withdrawn(owner, _amount);
    }

    // get contract balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

//these are the concepts used in this contract
//1. Access Control: onlyOwner modifier to restrict certain functions to the contract owner.
//2. Events: Deposited and Withdrawn events to log deposits and withdrawals.
//3. Payable Functions: receive and fallback functions to accept ETH deposits.
//4. Basic ETH Transfer: withdraw function  to transfer ETH from the contract to the owner.

//Here are some keywords defined used in this contract:
//1. Access Control: A mechanism to restrict access to certain functions. The 'onlyOwner' modifier ensures that only the contract owner can call specific functions.
//2. Events: Mechanisms to log information on the blockchain. The 'Deposited' and 'Withdrawn' events log details of ETH deposits and withdrawals.
//3. Payable Functions: Functions that can receive ETH. The 'receive' and 'fallback' functions are payable, allowing the contract to accept ETH sent to it.
//4. Basic ETH Transfer: The process of sending ETH from the contract to an external address. The 'withdraw' function transfers a specified amount of ETH to the contract owner.
