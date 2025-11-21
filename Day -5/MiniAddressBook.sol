// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Mini Address Book (nested mappings)
contract MiniAddressBook {
    struct Contact {
        uint256 id;
        string name;
        string phone;
        bool exists;
    }

    mapping(address => mapping(uint256 => Contact)) private contacts;
    mapping(address => uint256[]) private contactIds;
    mapping(address => uint256) private nextContactId;

    event ContactAdded(address indexed user, uint256 id);
    event ContactUpdated(address indexed user, uint256 id);
    event ContactDeleted(address indexed user, uint256 id);

    function addContact(
        string calldata _name,
        string calldata _phone
    ) external returns (uint256) {
        uint256 id = nextContactId[msg.sender]++;

        contacts[msg.sender][id] = Contact({
            id: id,
            name: _name,
            phone: _phone,
            exists: true
        });

        contactIds[msg.sender].push(id);

        emit ContactAdded(msg.sender, id);
        return id;
    }

    function updateContact(
        uint256 _id,
        string calldata _name,
        string calldata _phone
    ) external {
        Contact storage c = contacts[msg.sender][_id];
        require(c.exists, "Contact not found");

        c.name = _name;
        c.phone = _phone;

        emit ContactUpdated(msg.sender, _id);
    }

    function deleteContact(uint256 _id) external {
        Contact storage c = contacts[msg.sender][_id];
        require(c.exists, "Contact not found");

        delete contacts[msg.sender][_id];

        uint256[] storage ids = contactIds[msg.sender];

        // swap-pop array removal
        for (uint256 i = 0; i < ids.length; i++) {
            if (ids[i] == _id) {
                ids[i] = ids[ids.length - 1];
                ids.pop();
                break;
            }
        }

        emit ContactDeleted(msg.sender, _id);
    }

    function getContact(uint256 _id) external view returns (Contact memory) {
        Contact memory c = contacts[msg.sender][_id];
        require(c.exists, "Contact not found");
        return c;
    }

    function listContactIds() external view returns (uint256[] memory) {
        return contactIds[msg.sender];
    }
}

//Concepts Used:
// - Nested Mappings: Mapping user addresses to their contacts.
// - Structs: Defining a Contact structure to hold contact details.
// - Events: Emitting events for adding, updating, and deleting contacts.
// - Dynamic Arrays: Storing contact IDs for each user to facilitate listing.
// - Swap-Pop Removal: Efficiently removing contact IDs from the array.
// - State Management: Keeping track of the next contact ID for each user.
// - Access Control: Ensuring users can only manage their own contacts.
// - Error Handling: Using require statements to handle non-existent contacts.
// - View Functions: Functions to retrieve contact details and list of contact IDs without modifying state.
