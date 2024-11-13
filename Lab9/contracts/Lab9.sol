// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Lab9{
    address private  me;
    uint private  value;

    constructor(uint initial_value){
        me = msg.sender;
        value = initial_value;
    }

    function owner() public view returns (address) {
        return me;
    }
    function getValue() public view returns (uint) {
        return value;
    }
}