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
