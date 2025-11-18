// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.19;

//title favorite number tracker
contract FavoriteNumberTracker {
    mapping(address => uint256) private favNumber;

    event FavoriteSet(address indexed user, uint256 number);

    //set caller's favorite number & _num favorite number
    function setFavorite(uint256 _num) public {
        favNumber[msg.sender] = _num;
        emit FavoriteSet(msg.sender, _num);
    }

    //get caller's favorite number & favorite number for msg.sender;
    function getMyFavorite() public view returns (uint256) {
        return favNumber[msg.sender];
    }

    //get favorite for any address && _user address to query
    function getFavorite(address _user) public view returns (uint256) {
        return favNumber[_user];
    }
}


//these are the concepts used in this contract
//1. Mappings: Use a mapping to associate addresses with their favorite numbers.
//2. Events: Emit an event when a favorite number is set.
//3. Public and View Functions: Implement functions to set and get favorite numbers.
//4. Address Handling: Use msg.sender to identify the caller's address. 

//Here are some keywords defined used in this contract:
//1. Mappings: A data structure that associates keys with values. In this contract, 'favNumber' maps an address to a uint256 favorite number.
//2. Events: Mechanisms to log information on the blockchain. The 'FavoriteSet' event logs the user's address and their favorite number whenever a favorite number is set.
//3. Public and View Functions: Functions that can be called from outside the contract. 'setFavorite' is a public function that modifies the state, while 'getMyFavorite' and 'getFavorite' are view functions that read the state without modifying it.
//4. Address Handling: The use of 'msg.sender' to identify the address of the caller, allowing the contract to store and retrieve favorite numbers specific to each user.   
