// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract ToDoList {
    struct Task {
        string description;
        bool completed;
    }

    Task[] private tasks;

    event TaskAdded(uint256 indexed taskId, string description);
    event TaskCompleted(uint256 indexed taskId);
    event TaskDeleted(uint256 indexed taskId);

    function addTask(string calldata description) public {
        tasks.push(Task({description: description, completed: false}));
        emit TaskAdded(tasks.length - 1, description);
    }

    function completeTask(uint256 taskId) public {
        require(taskId < tasks.length, "Task does not exist");
        tasks[taskId].completed = true;
        emit TaskCompleted(taskId);
    }

    function deleteTask(uint256 taskId) public {
        require(taskId < tasks.length, "Task does not exist");

        tasks[taskId] = tasks[tasks.length - 1];
        tasks.pop();
        emit TaskDeleted(taskId);
    }

    function getTask(uint256 taskId) public view returns (string memory, bool) {
        require(taskId < tasks.length, "Task does not exist");
        return (tasks[taskId].description, tasks[taskId].completed);
    }

    function getAllTasks() public view returns (Task[] memory) {
        return tasks;
    }
}


//4 concept used in this contract
//1. Structs: Define a Task struct to hold task details.
//2. Dynamic Arrays: Use a dynamic array to store tasks.
//3. Events: Emit events for task addition, completion, and deletion.
//4. Basic CRUD Operations: Implement functions to create, read, update, and delete tasks

//Here are some keywords defined used in this contract:
//1. Structs: Custom data types that group related variables. In this contract, 'Task' is a struct that holds a task's description and its completion status.
//2. Dynamic Arrays: Arrays that can change in size. The 'tasks' array is dynamic, allowing tasks to be added or removed.
//3. Events: Mechanisms to log information on the blockchain. The 'TaskAdded', 'TaskCompleted', and 'TaskDeleted' events log actions performed on tasks.
//4. Basic CRUD Operations: Functions that allow users to create (addTask), read (getTask, getAllTasks), update (completeTask), and delete (deleteTask) tasks in the to-do list
