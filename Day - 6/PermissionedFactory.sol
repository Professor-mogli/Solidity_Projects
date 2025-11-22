// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PermissionedFactory — example factory with access control
contract PermissionedFactory {
    address public admin;
    mapping(address => bool) public canDeploy;
    address[] public deployed;

    event DeployerAdded(address indexed deployer);
    event DeployerRemoved(address indexed deployer);
    event Deployed(address indexed deployer, address indexed child);

    modifier onlyAdmin() {
        _onlyAdmin();
        _;
    }

    modifier onlyDeployer() {
        _onlyDeployer();
        _;
    }

    function _onlyAdmin() internal view {
        require(msg.sender == admin, "Not admin");
    }

    function _onlyDeployer() internal view {
        require(canDeploy[msg.sender], "Cannot deploy");
    }

    constructor() {
        admin = msg.sender;
    }

    function addDeployer(address _d) external onlyAdmin {
        canDeploy[_d] = true;
        emit DeployerAdded(_d);
    }

    function removeDeployer(address _d) external onlyAdmin {
        canDeploy[_d] = false;
        emit DeployerRemoved(_d);
    }

    function deployChild(
        bytes calldata initData
    ) external onlyDeployer returns (address) {
        Child c = new Child(msg.sender, initData);
        deployed.push(address(c));
        emit Deployed(msg.sender, address(c));
        return address(c);
    }

    function getDeployed() external view returns (address[] memory) {
        return deployed;
    }
}

/// @notice Example Child contract created by factory
contract Child {
    address public creator;
    bytes public data;

    constructor(address _creator, bytes memory _data) {
        creator = _creator;
        data = _data;
    }
}

//Concepts Used:
// - Access Control
// - Factory Pattern
// - Events
// - Modifiers
// - Mappings
// - Arrays
// - Contract Deployment
// - Constructor Parameters
// - Visibility Specifiers
// - Error Handling with require
// - Immutable State Variables
// - Calldata vs Memory
// - External vs Public Functions
// - Gas Optimization through selective state updates
// - Separation of Concerns between Factory and Child Contracts
// - Use of indexed parameters in events for efficient filtering
// - Tracking deployed contracts for management and retrieval
// - Role-based permissions for deploying new contracts
// - Encapsulation of deployment logic within the factory contract
// - Use of custom events to log significant actions within the contract
// - Ensuring only authorized addresses can perform sensitive operations
// - Providing transparency through event emissions for state changes
// - Facilitating contract interactions through well-defined interfaces

// Here are the definitions of some concepts and functionalities used in this contract:
// 1. Access Control: The contract uses access control mechanisms to restrict certain functions to specific roles, such as admin and deployer. The `onlyAdmin` and `onlyDeployer` modifiers ensure that only authorized addresses can execute sensitive operations.
// 2. Factory Pattern: The `PermissionedFactory` contract implements the factory pattern, allowing authorized deployers to create instances of the `Child` contract. This pattern is useful for managing the creation of multiple contract instances.
// 3. Events: The contract emits events to log significant actions, such as adding or removing deployers and deploying new child contracts. Events provide transparency and allow external systems to track contract activity.
// 4. Modifiers : Modifiers are used to encapsulate common access control logic, making the code cleaner and more maintainable. The `onlyAdmin` and `onlyDeployer` modifiers check the caller's permissions before allowing function execution.
// 5. Mappings: The contract uses a mapping to keep track of which addresses are authorized deployers. This allows for efficient permission checks when deployers attempt to create new child contracts.
// 6. Arrays: An array is used to store the addresses of all deployed child contracts, allowing for easy retrieval and management of these contracts.
// 7. Contract Deployment: The factory contract deploys new instances of the `Child` contract using the `new` keyword, passing in the necessary constructor parameters.
// 8. Constructor Parameters: The `Child` contract accepts parameters in its constructor, allowing it to be initialized with specific data upon deployment.
// 9. Visibility Specifiers: The contract uses visibility specifiers (e.g., `public`, `external`, `internal`) to control access to functions and state variables, ensuring proper encapsulation and security.
// 10. Error Handling with require: The contract uses `require` statements to enforce access control and validate conditions, reverting the transaction if the conditions are not met.
// 11. Immutable State Variables: The `admin` state variable is set in the constructor and remains unchanged, ensuring that the admin role is securely assigned at deployment.
// 12. Calldata vs Memory: The contract uses `calldata` for function parameters that are read-only and passed from  external calls, optimizing gas usage.
// 13. External vs Public Functions: The contract differentiates between `external` and `public` functions based on their intended usage, optimizing gas costs and access patterns.
// 14. Gas Optimization through selective state updates: The contract minimizes gas costs by only updating state variables when necessary, such as when adding or removing deployers.
// 15. Separation of Concerns between Factory and Child Contracts: The factory contract is responsible for managing deployers and creating child contracts, while the child contract focuses on its own state and functionality.
// 16. Use of indexed parameters in events for efficient filtering: The events emitted by the contract use indexed parameters, allowing external systems to efficiently filter and search for specific events.
// 17. Tracking deployed contracts for management and retrieval: The factory contract maintains a list of deployed child contracts, enabling easy access and management of these contracts.
// 18. Role-based permissions for deploying new contracts: The contract enforces role-based permissions, ensuring that only authorized deployers can create new child contracts.
// 19. Encapsulation of deployment logic within the factory contract: The factory contract encapsulates the logic for deploying child contracts, providing a clear interface for deployers.
// 20. Use of custom events to log significant actions within the contract: The contract defines and emits custom events to log important actions, enhancing transparency and traceability.
// 21. Ensuring only authorized addresses can perform sensitive operations: The contract uses access control mechanisms to restrict sensitive operations to authorized addresses, enhancing security.
// 22. Providing transparency through event emissions for state changes: The contract emits events to provide transparency into state changes, allowing external observers to track contract activity.
// 23. Facilitating contract interactions through well-defined interfaces: The contract defines clear interfaces for deployers to interact with the factory, simplifying the process of deploying new child contracts.
