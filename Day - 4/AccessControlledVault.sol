// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Access Controlled Vault
/// @notice Only owner can withdraw; anyone can deposit
contract AccessControlledVault {
    address public owner;

    event Deposited(address indexed from, uint256 amount);
    event Withdrawn(address indexed to, uint256 amount);
    event OwnerChanged(address oldOwner, address newOwner);

    // Custom error (gas efficient)
    error NotOwner(address caller, address owner);

    // --- Updated modifier (wrapped logic) ---
    modifier onlyOwner() {
        _onlyOwner();
        _;
    }

    function _onlyOwner() internal view {
        if (msg.sender != owner) {
            revert NotOwner(msg.sender, owner);
        }
    }

  //--------------------------------------------------------
  cconstructor() {
        owner = msg.sender;
    }

    receive() external payable {
        emit Deposited(msg.sender, msg.value);
    }

    function deposit() external payable {
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw(uint256 _amount) external onlyOwner {
        require(address(this).balance >= _amount, "No funds");
        (bool ok, ) = payable(owner).call{value: _amount}("");
        require(ok, "Withdraw failed");
        emit Withdrawn(owner, _amount);
    }

    function changeOwner(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "Zero address");
        emit OwnerChanged(owner, _newOwner);
        owner = _newOwner;
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

//Concepts used in this contract:
//1. Access Control: Using a modifier to restrict certain functions to the contract owner.
//2. Events: Emitting events for deposits, withdrawals, and owner changes.
//3. Receive Function: Allowing the contract to accept plain Ether transfers.

//Here are the definitions of some concepts and functionalities used in this contract:
//1. Access Control: This contract uses an 'onlyOwner' modifier to restrict access to certain functions, ensuring that only the owner of the contract can execute them. This is crucial for functions like 'withdraw' and 'changeOwner' to prevent unauthorized access.
//2. Events: Events such as 'Deposited', 'Withdrawn', and 'OwnerChanged' are emitted to log significant actions within the contract. These events help in tracking deposits, withdrawals, and changes in ownership on the blockchain.
//3. Receive Function: The 'receive' function is a special function in Solidity that allows the contract to accept plain Ether transfers. This function is triggered when the contract receives Ether without any data, enabling users to deposit funds easily.

































    
