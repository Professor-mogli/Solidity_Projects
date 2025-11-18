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



//these are the concepts used in this contract
//1. State Variables: Store the greeting message.
//2. Events: Emit an event when the greeting is changed.    

//Here are some keywords defined used in this contract:
//1. State Variables: Variables that hold the state of the contract. In this case, 'greeting' is a state variable that stores the greeting message.
//2. Events: Mechanisms to log information on the blockchain. The 'Greeted' event logs the sender's address, the old greeting, and the new greeting whenever the greeting is changed.
//3. Functions: Blocks of code that perform specific tasks. 'setGreeting' updates the greeting message, while 'getGreeting' retrieves the current greeting.
//4. Calldata: A data location that contains function arguments. It is used here for the '_newGreeting' parameter in 'setGreeting' to optimize gas usage.
