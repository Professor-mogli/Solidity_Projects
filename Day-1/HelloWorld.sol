// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract HelloWorld {
    string public greeting = "Hello, World!";

    event Greeted(
        address indexed sender,
        string oldGreeting,
        string newGreeting
    );

    function setGreeting(string calldata _newGreeting) public {
        string memory old = greeting;
        greeting = _newGreeting;
        emit Greeted(msg.sender, old, _newGreeting);
    }

    function getGreeting() public view returns (string memory) {
        return greeting;
    }
}
