// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ContactBook {
    struct Contact {
        string name;
        string phone;
        bool exists;
    }

    mapping(address => Contact[]) private contacts;

    event ContactAdded(address indexed user, string name, string phone);
    event ContactUpdated(address indexed user, uint256 id);
    event ContactDeleted(address indexed user, uint256 id);

    function addContact(string calldata name, string calldata phone) external {
        contacts[msg.sender].push(
            Contact({name: name, phone: phone, exists: true})
        );

        emit ContactAdded(msg.sender, name, phone);
    }

    function updateContact(
        uint256 id,
        string calldata name,
        string calldata phone
    ) external {
        require(id < contacts[msg.sender].length, "Invalid contact");

        contacts[msg.sender][id].name = name;
        contacts[msg.sender][id].phone = phone;

        emit ContactUpdated(msg.sender, id);
    }

    function deleteContact(uint256 id) external {
        require(id < contacts[msg.sender].length, "Invalid contact");

        contacts[msg.sender][id] = contacts[msg.sender][
            contacts[msg.sender].length - 1
        ];

        contacts[msg.sender].pop();

        emit ContactDeleted(msg.sender, id);
    }

    function getMyContacts() external view returns (Contact[] memory) {
        return contacts[msg.sender];
    }
}

// Concepts used in this contract:
//1. Structs: Define a Contact struct to hold contact details.
//2. Mappings: Use a mapping to associate users with their contact lists.
//3. Events: Emit events for contact addition, update, and deletion.
//4. Basic CRUD Operations: Implement functions to create, read, update, and delete contacts

//Here are some keywords defined used in this contract:
//1. Structs: Custom data types that group related variables. In this contract, 'Contact' is a struct that holds a contact's name, phone number, and existence status.
//2. Mappings: A data structure that associates keys with values. The 'contacts' mapping associates each user's address with an array of their Contact structs.
//3. Events: Mechanisms to log information on the blockchain. The 'ContactAdded', 'ContactUpdated', and 'ContactDeleted' events log actions performed on contacts.
//4. Basic CRUD Operations: Functions that allow users to create (addContact), read (getMyContacts), update (updateContact), and delete (deleteContact) contacts in their contact book.
