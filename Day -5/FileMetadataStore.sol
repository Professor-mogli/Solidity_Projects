// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title On-Chain File Metadata Storage
contract FileMetadataStore {
    struct FileMeta {
        uint256 id;
        string name;
        uint256 size;
        address uploader;
        uint256 timestamp;
        bool exists;
    }

    mapping(uint256 => FileMeta) private files;
    uint256[] private fileIds;
    uint256 private nextId;

    event FileAdded(uint256 indexed id, string name, address indexed uploader);
    event FileUpdated(uint256 indexed id, string name);
    event FileDeleted(uint256 indexed id);

    function addFile(
        string calldata _name,
        uint256 _size
    ) external returns (uint256) {
        uint256 id = nextId++;

        files[id] = FileMeta({
            id: id,
            name: _name,
            size: _size,
            uploader: msg.sender,
            timestamp: block.timestamp,
            exists: true
        });

        fileIds.push(id);
        emit FileAdded(id, _name, msg.sender);
        return id;
    }

    function updateFileName(uint256 _id, string calldata _newName) external {
        require(files[_id].exists, "File not found");
        require(files[_id].uploader == msg.sender, "Not uploader");

        files[_id].name = _newName;
        emit FileUpdated(_id, _newName);
    }

    function deleteFile(uint256 _id) external {
        require(files[_id].exists, "File not found");
        require(files[_id].uploader == msg.sender, "Not uploader");

        delete files[_id];

        // swap-pop removal from fileIds
        for (uint256 i = 0; i < fileIds.length; i++) {
            if (fileIds[i] == _id) {
                fileIds[i] = fileIds[fileIds.length - 1];
                fileIds.pop();
                break;
            }
        }

        emit FileDeleted(_id);
    }

    function getFile(uint256 _id) external view returns (FileMeta memory) {
        require(files[_id].exists, "File not found");
        return files[_id];
    }

    function listFiles() external view returns (FileMeta[] memory list) {
        uint256 len = fileIds.length;
        list = new FileMeta[](len);
        for (uint256 i = 0; i < len; i++) {
            list[i] = files[fileIds[i]];
        }
        return list;
    }
}

// Concepts used in this contract:
// 1. Structs: 'FileMeta' struct to store file metadata.
// 2. Mappings: 'files' mapping to associate file IDs with their metadata.
// 3. Dynamic Arrays: 'fileIds' array to keep track of all file IDs.
// 4. Events: 'FileAdded', 'FileUpdated', and 'FileDeleted' events  for logging actions.
// 5. Functions: 'addFile', 'updateFileName', 'deleteFile', 'getFile', and 'listFiles' to manage file metadata.

// Here are the definitions of some concepts and functionalities used in this contract:
// 1. Structs: A struct is a custom data type that groups related variables. The 'FileMeta' struct holds information about each file, including its ID, name, size, uploader address, timestamp, and existence status.
// 2. Mappings: A mapping is a key-value store used to associate data. In this contract, the 'files' mapping links a unique file ID to its corresponding 'FileMeta' struct.
// 3. Dynamic Arrays: A dynamic array is an array that can change in size. The 'fileIds' array stores all the file IDs added to the contract, allowing for easy enumeration of files.
// 4. Events: Events are used to log significant actions within the contract. The contract emits events whenever a file is added, updated, or deleted, providing a transparent log of these actions.
// 5. Functions: The contract includes several functions to manage file metadata:
