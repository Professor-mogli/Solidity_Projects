// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Student Registry
/// @notice Simple CRUD for student records keyed by roll number
contract StudentRegistry {
    struct Student {
        uint256 roll;
        string name;
        uint8 age;
        bool exists;
    }

    mapping(uint256 => Student) private students; // roll -> Student
    uint256[] private rolls; // list to iterate if needed

    event StudentAdded(uint256 indexed roll, string name, uint8 age);
    event StudentUpdated(uint256 indexed roll, string name, uint8 age);
    event StudentDeleted(uint256 indexed roll);

    function addStudent(
        uint256 roll,
        string calldata name,
        uint8 age
    ) external {
        require(!students[roll].exists, "Student exists");

        // -------- FIXED: Use named struct fields --------
        students[roll] = Student({
            roll: roll,
            name: name,
            age: age,
            exists: true
        });

        rolls.push(roll);
        emit StudentAdded(roll, name, age);
    }

    function updateStudent(
        uint256 roll,
        string calldata name,
        uint8 age
    ) external {
        require(students[roll].exists, "Student not found");
        students[roll].name = name;
        students[roll].age = age;
        emit StudentUpdated(roll, name, age);
    }

    function deleteStudent(uint256 roll) external {
        require(students[roll].exists, "Student not found");
        delete students[roll];

        // remove from rolls array (swap-pop)
        for (uint256 i = 0; i < rolls.length; i++) {
            if (rolls[i] == roll) {
                rolls[i] = rolls[rolls.length - 1];
                rolls.pop();
                break;
            }
        }

        emit StudentDeleted(roll);
    }

    function getStudent(
        uint256 roll
    ) external view returns (uint256, string memory, uint8, bool) {
        Student storage s = students[roll];
        return (s.roll, s.name, s.age, s.exists);
    }

    function getAllRolls() external view returns (uint256[] memory) {
        return rolls;
    }
}

// Concepts used in this contract:
// 1. Structs: 'Student' struct to encapsulate student data.
// 2. Mappings: 'students' mapping to store student records by roll number.
// 3. Arrays: 'rolls' array to keep track of all roll numbers.
// 4. Events: 'StudentAdded', 'StudentUpdated', and 'StudentDeleted' to log significant actions.
// 5. Functions: 'addStudent', 'updateStudent', 'deleteStudent', 'getStudent', and 'getAllRolls' to manage student records.

// Here are the definitions of some concepts and functionalities used in this contract:
// 1. Structs: Custom data types that group related variables. The 'Student' struct holds information about each student.
// 2. Mappings: Key-value pairs for efficient data retrieval. The 'students' mapping allows quick access to student records using their roll number.
// 3.   Arrays: Ordered collections of elements. The 'rolls' array stores all roll numbers for iteration purposes.
// 4. Events: Mechanisms to log activities on the blockchain. Events like 'StudentAdded' help track changes to the student registry.
// 5. Functions: Blocks of code that perform specific tasks. Functions in this contract allow adding, updating, deleting, and retrieving student records.
