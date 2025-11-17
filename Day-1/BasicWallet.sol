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

