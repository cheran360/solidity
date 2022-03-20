// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract SimpleStorage{
    // change javascript VM to injected web3 for real time application
    // of this contract.
    uint256 favoriteNumber;
    bool favoriteBool;

    struct People {
        uint256 favoriteNumber;
        string name;
    }

    People[] public people;
    mapping(string => uint256) public  nameToFavoriteNumber;

    function store(uint256 _favouriteNumber) public {
        favoriteNumber = _favouriteNumber;
    }

    //view, pure
    function retrieve() public view returns(uint256) {
        return favoriteNumber;
    }

    //storage keyword -- keep the data in variable even after execution(forever)
    //memory keyword -- forget the data in varaible after execution

    function addPerson(string memory _name, uint256 _favouriteNumber) public {
        people.push(People(_favouriteNumber, _name));
        nameToFavoriteNumber[_name] = _favouriteNumber;
    }
}