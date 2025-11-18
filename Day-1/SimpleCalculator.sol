// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract SimpleCalculator {
    function add(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b;
    }

    function sub(uint256 a, uint256 b) public pure returns (uint256) {
        return a - b;
    }

    function multiply(uint256 a, uint256 b) public pure returns (uint256) {
        return a * b;
    }

    function divide(uint256 a, uint256 b) public pure returns (uint256) {
        return a / b;
    }
}



//these are the concepts used in this contract
//1. Pure Functions: All functions are marked as pure since they do not read or modify state.
//2. Basic Arithmetic Operations: Implements addition, subtraction, multiplication, and division.
//3. Public Visibility: Functions are declared public to allow external calls.
//4. Return Values: Each function returns the result of the arithmetic operation.

//here are the defination of some concepts and functinalities used in this contract:
//1. Pure Functions: Functions that do not read or modify the contract's state. They only use the input parameters to compute and return a value.
//2. Basic Arithmetic Operations: Fundamental mathematical operations such as addition, subtraction, multiplication, and division.
//3. Public Visibility: A function visibility modifier that allows the function to be called from outside the contract.
//4. Return Values: The output of a function that is sent back to the caller after execution.
