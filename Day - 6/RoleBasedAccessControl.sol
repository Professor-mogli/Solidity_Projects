// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title RoleBasedAccessControl — lightweight RBAC
contract RoleBasedAccessControl {
    // role => account => hasRole
    mapping(bytes32 => mapping(address => bool)) private _roles;
    // role => adminRole
    mapping(bytes32 => bytes32) public roleAdmin;

    event RoleGranted(
        bytes32 indexed role,
        address indexed account,
        address indexed sender
    );
    event RoleRevoked(
        bytes32 indexed role,
        address indexed account,
        address indexed sender
    );

    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;

    modifier onlyRole(bytes32 role) {
        _checkRole(role);
        _;
    }

    function _checkRole(bytes32 role) internal view {
        require(_roles[role][msg.sender], "Missing role");
    }

    constructor() {
        // deployer gets DEFAULT_ADMIN_ROLE
        _roles[DEFAULT_ADMIN_ROLE][msg.sender] = true;
    }

    function _getRoleAdmin(bytes32 role) internal view returns (bytes32) {
        bytes32 admin = roleAdmin[role];
        // if admin not set, default to DEFAULT_ADMIN_ROLE
        return admin == bytes32(0) ? DEFAULT_ADMIN_ROLE : admin;
    }

    function grantRole(
        bytes32 role,
        address account
    ) external onlyRole(_getRoleAdmin(role)) {
        _grantRole(role, account);
    }

    function revokeRole(
        bytes32 role,
        address account
    ) external onlyRole(_getRoleAdmin(role)) {
        _revokeRole(role, account);
    }

    function _grantRole(bytes32 role, address account) internal {
        if (!_roles[role][account]) {
            _roles[role][account] = true;
            emit RoleGranted(role, account, msg.sender);
        }
    }

    function _revokeRole(bytes32 role, address account) internal {
        if (_roles[role][account]) {
            _roles[role][account] = false;
            emit RoleRevoked(role, account, msg.sender);
        }
    }

    // helper
    function hasRole(
        bytes32 role,
        address account
    ) external view returns (bool) {
        return _roles[role][account];
    }
}

//Concept used  in this contract.
//1. Role-Based Access Control (RBAC) pattern for managing permissions. This allows for flexible assignment and revocation of roles to different accounts, enabling fine-grained access control within the contract.
//2. Default Admin Role: The contract assigns the deployer the DEFAULT_ADMIN_ROLE, which has the authority to manage other roles. This establishes a clear hierarchy of permissions from the outset.
//3. Dynamic Role Administration: Each role can have its own admin role, allowing for decentralized management of permissions. This means that different roles can be governed by different accounts, enhancing security and flexibility.
//4. Events for Transparency: The contract emits events (RoleGranted and RoleRevoked) to log changes in role assignments. This transparency is crucial for auditing and tracking permission changes over time.
//5. Modifiers for Access Control: The onlyRole modifier is used to restrict function access based on roles. This ensures that only authorized accounts can execute sensitive functions, enforcing the RBAC model.

//Here are the definitions of some concepts and functionalities used in this contract:
//1. Role-Based Access Control (RBAC): A method of regulating access to resources based on the roles assigned to users within an organization. In this contract, roles are represented as bytes32 identifiers, and each role can be granted or revoked to specific accounts.
//2. Mappings: The contract uses nested mappings to track which accounts have which roles. The outer mapping associates a role with another mapping that links accounts to boolean values indicating whether they possess the role.
//3. Events: Events are emitted to log significant actions, such as granting or revoking roles. This provides transparency and allows external systems to monitor changes in role assignments.
//4. Modifiers: The onlyRole modifier is used to restrict access to certain functions based on the caller's role. It checks if the caller has the required  role before allowing the function to execute.
//5. Constructor: The constructor initializes the contract by assigning the deployer the DEFAULT_ADMIN_ROLE, establishing the initial access control hierarchy.
//6. Internal Functions: The _grantRole and _revokeRole functions encapsulate the logic for modifying role assignments, ensuring that role changes are handled consistently and emitting the appropriate events.
//7. Helper Function: The hasRole function provides a way to check if a specific account has a particular role, facilitating external queries about role assignments.
