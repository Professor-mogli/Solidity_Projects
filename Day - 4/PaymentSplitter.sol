// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title Simple Payment Splitter
/// @notice Split incoming ETH between recipients according to shares
contract PaymentSplitter {
    address[] public recipients;
    mapping(address => uint256) public shares;
    uint256 public totalShares;

    event PaymentReceived(address indexed from, uint256 amount);
    event Withdrawal(address indexed to, uint256 amount);

    cconstructor(address[] memory _recipients, uint256[] memory _shares) {
        require(_recipients.length == _shares.length, "Invalid input");

        for (uint256 i = 0; i < _recipients.length; i++) {
            recipients.push(_recipients[i]);
            shares[_recipients[i]] = _shares[i];
            totalShares += _shares[i];
        }
    }

    receive() external payable {
        emit PaymentReceived(msg.sender, msg.value);
    }

    function withdraw() external {
        uint256 amount = (address(this).balance * shares[msg.sender]) /
            totalShares;
        require(amount > 0, "No funds");

        shares[msg.sender] = 0; // prevent re-withdraw

        (bool ok, ) = payable(msg.sender).call{value: amount}("");
        require(ok, "Withdraw failed");

        emit Withdrawal(msg.sender, amount);
    }
}


// Concepts used in this contract:
// 1. State Variables: Storing recipients, their shares, and total shares.
// 2. Events: Emitting events for payment reception and withdrawals.
// 3. Constructor: Initializing recipients and their shares.
// 4. Receive Function: Handling incoming ETH payments.
// 5. Withdrawal Function: Allowing recipients to withdraw their share of funds.

// Here are the definitions of some concepts and functionalities used in this contract:
// 1. State Variables: Variables that are stored on the blockchain. In this contract, 'recipients', 'shares', and 'totalShares' are state variables that hold the list of recipients, their respective shares, and the total shares.
// 2. Events: Mechanism to log information on the blockchain. Events like 'PaymentReceived' and 'Withdrawal' help track incoming payments and withdrawals by recipients.
// 3. Constructor: A special function that is executed once when the contract is deployed. It initializes the recipients and their shares based on the input arrays.
// 4. Receive Function: A special function that allows the contract to accept plain Ether transfers. It emits an event whenever Ether is received.
// 5. Withdrawal Function: A public function that allows recipients to withdraw their share of the funds. It calculates the amount based on their shares, ensures there are funds to withdraw, and prevents re-withdrawal by setting their shares to zero after withdrawal.
