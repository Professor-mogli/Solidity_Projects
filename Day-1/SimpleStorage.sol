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
