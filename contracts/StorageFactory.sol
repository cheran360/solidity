// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./SimpleStorage.sol";

// Deployment of a contract(SimpleStorage.sol) to a blockchain from another contract(StorageFactory.sol).. 
// inheritance of SimpleStorage to StorageFactory using keyword "is".
contract StorageFactory is SimpleStorage{

    SimpleStorage[] public simpleStorageArray;

    function createSimpleStorageContract() public {
        // we are creating an object of type SimpleStorage contract
        // from SimpleStorage.sol(we are importing this so....)
        // simpleStorage is like an Object in python
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }

    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public {
        // Anytime u interact with a contract u need two things(to use the other contract methods)
        // 1. Address   2.ABI(Application binary interface)
        // we access components of objects associated with the class through addresses
        // simpleStorageArray[_simpleStorageIndex] is treated as object
        SimpleStorage simpleStorage = SimpleStorage(address(simpleStorageArray[_simpleStorageIndex]));
        simpleStorage.store(_simpleStorageNumber);
    }   

    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
        SimpleStorage simpleStorage = SimpleStorage(address(simpleStorageArray[_simpleStorageIndex]));
        return simpleStorage.retrieve();
    }
}