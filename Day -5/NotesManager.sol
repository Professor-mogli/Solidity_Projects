// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Notes Manager (per-user CRUD)
contract NotesManager {
    struct Note {
        uint256 id;
        string text;
        uint256 timestamp;
        bool exists;
    }

    mapping(address => Note[]) private notes;
    mapping(address => uint256) private nextNoteId;

    event NoteAdded(address indexed user, uint256 id);
    event NoteUpdated(address indexed user, uint256 id);
    event NoteDeleted(address indexed user, uint256 id);

    function addNote(string calldata _text) external returns (uint256) {
        uint256 id = nextNoteId[msg.sender]++;

        notes[msg.sender].push(
            Note({
                id: id,
                text: _text,
                timestamp: block.timestamp,
                exists: true
            })
        );

        emit NoteAdded(msg.sender, id);
        return id;
    }

    function updateNote(uint256 _id, string calldata _text) external {
        Note[] storage arr = notes[msg.sender];
        bool found = false;

        for (uint256 i = 0; i < arr.length; i++) {
            if (arr[i].id == _id && arr[i].exists) {
                arr[i].text = _text;
                arr[i].timestamp = block.timestamp;
                found = true;
                emit NoteUpdated(msg.sender, _id);
                break;
            }
        }

        require(found, "Note not found");
    }

    function deleteNote(uint256 _id) external {
        Note[] storage arr = notes[msg.sender];

        for (uint256 i = 0; i < arr.length; i++) {
            if (arr[i].id == _id && arr[i].exists) {
                arr[i].exists = false; // soft delete
                emit NoteDeleted(msg.sender, _id);
                return;
            }
        }

        revert("Note not found");
    }

    function getMyNotes() external view returns (Note[] memory) {
        return notes[msg.sender];
    }
}

//Concepts used in this contract:
// - Structs
// - Mappings
// - Arrays
// - Events
// - CRUD operations
// - Per-user data management

// Here are some concepts used in this contract:
// 1. Structs: The contract defines a 'Note' struct to encapsulate note properties such as id, text, timestamp, and existence flag.
// 2. Mappings: It uses mappings to associate each user's address with their array of notes and to track the next note ID for each user.
// 3. Arrays: Each user's notes are stored in a dynamic array, allowing for flexible management of multiple notes.
// 4. Events: The contract emits events for adding, updating, and deleting notes to provide transparency and facilitate off-chain tracking.
// 5. CRUD Operations: The contract implements Create, Read, Update, and Delete functionalities for managing notes.
// 6. Per-user Data Management: Each user has their own isolated set of notes, ensuring privacy and individualized data handling.
