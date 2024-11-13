// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Lab9b{
    address public me;
    uint public value;
    
    constructor(uint initial_value){
        me = msg.sender;
        value = initial_value;
    }
}