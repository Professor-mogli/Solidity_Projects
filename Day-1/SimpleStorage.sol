// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

//Task is to Store and retrieve a single uint256 value.
contract SimpleStorage {
    uint256 private number;

    function setNumber(uint256 _num) public {
        number = _num;
    }

    function getNumber() public view returns (uint256) {
        return number;
    }
}

//these are the concepts used in this contract
//1. State Variables: Use a private state variable to store the number.
//2. Public Functions: Implement public functions to set and get the number.
//3. View Functions: Use a view function to read the state without modifying it.
//4. Data Types: Utilize the uint256 data type for storing numerical values.  

//Here are the defination of some concepts and functinalities used in this contract:
//1. State Variables: Variables that are stored on the blockchain. In this contract, 'number' is a state variable that holds a uint256 value.
//2. Public Functions: Functions that can be called from outside the contract. 'setNumber' and 'getNumber' are public functions.
//3. View Functions: Functions that do not modify the state and can be called without sending a transaction. 'getNumber' is a view function.
//4. Data Types: The type of data that can be stored in variables. 'uint256' is a data type representing an unsigned integer of 256 bits.
