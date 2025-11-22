// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Simple MultiSig (learning version)
contract SimpleMultiSig {
    address[] public owners;
    mapping(address => bool) public isOwner;
    uint256 public required; // approvals required

    struct Tx {
        address to;
        uint256 value;
        bytes data;
        bool executed;
        uint256 approvals;
    }

    Tx[] public transactions;
    mapping(uint256 => mapping(address => bool)) public approved; // txId => owner => bool

    event TxSubmitted(
        uint256 indexed txId,
        address indexed by,
        address to,
        uint256 value
    );
    event TxApproved(uint256 indexed txId, address indexed by);
    event TxExecuted(uint256 indexed txId, address indexed by);

    modifier onlyOwner() {
        _onlyOwner();
        _;
    }

    function _onlyOwner() internal view {
        require(isOwner[msg.sender], "Not owner");
    }

    constructor(address[] memory _owners, uint256 _required) {
        require(_owners.length > 0, "Owners required");
        require(
            _required > 0 && _required <= _owners.length,
            "Invalid required count"
        );

        for (uint256 i = 0; i < _owners.length; i++) {
            address o = _owners[i];
            require(o != address(0), "Zero owner");
            require(!isOwner[o], "Duplicate owner");
            isOwner[o] = true;
            owners.push(o);
        }
        required = _required;
    }

    receive() external payable {}

    function submitTx(
        address _to,
        uint256 _value,
        bytes calldata _data
    ) external onlyOwner returns (uint256) {
        Tx memory txObj = Tx({
            to: _to,
            value: _value,
            data: _data,
            executed: false,
            approvals: 0
        });
        transactions.push(txObj);
        uint256 txId = transactions.length - 1;
        emit TxSubmitted(txId, msg.sender, _to, _value);
        return txId;
    }

    function approveTx(uint256 _txId) external onlyOwner {
        require(_txId < transactions.length, "Tx not found");
        require(!approved[_txId][msg.sender], "Already approved");
        require(!transactions[_txId].executed, "Already executed");

        approved[_txId][msg.sender] = true;
        transactions[_txId].approvals += 1;
        emit TxApproved(_txId, msg.sender);

        if (transactions[_txId].approvals >= required) {
            _executeTx(_txId);
        }
    }

    function _executeTx(uint256 _txId) internal {
        Tx storage txObj = transactions[_txId];
        require(!txObj.executed, "Executed");
        txObj.executed = true;
        (bool ok, ) = txObj.to.call{value: txObj.value}(txObj.data);
        require(ok, "Execution failed");
        emit TxExecuted(_txId, msg.sender);
    }

    function getTxCount() external view returns (uint256) {
        return transactions.length;
    }
}

//Concept used  in this contract.
//1. Owner Management: The contract maintains a list of owners and a mapping to quickly check if an address is an owner. This allows for efficient verification of ownership.
//2. Transaction Struct: A struct is defined to represent a transaction, encapsulating all necessary details such as the recipient address, value, data, execution status, and approval count.
//3. Transaction Submission: Owners can submit new transactions, which are stored in an array. An event is emitted to log the submission.
//4. Approval Mechanism: Owners can approve transactions. The contract tracks approvals using a nested mapping, ensuring that each owner can only approve a transaction once.
//5. Automatic Execution: Once a transaction receives the required number of approvals, it is automatically executed. The execution involves sending the specified value and data to the target address.
//6. Events for Transparency: Events are emitted for transaction submissions, approvals, and executions, providing transparency and an audit trail for all significant actions within the contract.
//7. Modifiers for Access Control: The onlyOwner modifier restricts certain functions to be callable only by owners, enforcing access control throughout the contract.

//Here are the definitions of some concepts and functionalities used in this contract:
//1. Owner Management: The contract uses an array and a mapping to manage and verify owners. The array stores the list of owner addresses, while the mapping allows for quick checks to see if a given address is an owner.
//2. Transaction Struct: A struct is a custom data type that groups related variables. In this contract, the Tx struct encapsulates all relevant information about a transaction, making it easier to manage and pass around transaction data.
//3. Transaction Submission: The submitTx function allows owners to create new transactions. It initializes a Tx struct with the provided details and adds it to the transactions array, emitting an event to log the action.
//4. Approval Mechanism: The approveTx function enables owners to approve transactions. It checks that the transaction exists, that the owner hasn't already approved it, and that it hasn't been executed yet. It then records the approval and increments the approval count.
//5. Automatic Execution: The contract automatically executes a transaction once it has received the required number of approvals. The _executeTx internal function handles the execution logic, ensuring that the transaction is only executed once and that the call to the target address is successful.
//6. Events for Transparency: Events are used to log significant actions within the contract, such as transaction submissions, approvals, and executions. This provides an audit trail and allows external systems to monitor contract activity.
//7. Modifiers for Access Control: The onlyOwner modifier is used to restrict access to certain functions, ensuring that only owners can submit and approve transactions. This helps maintain the integrity of the multi-signature process.
