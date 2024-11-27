// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 < 0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20Token is ERC20 {
    uint private remainingSupply = 1000000000000000000000;  // We fix the supply to 1000 ERC20Tokens
    mapping(address => uint) private whitelistMinters;      // whitelisted minters added by the owner
    mapping(address => bool) private alreadyMinted;         // whitelisted addresses who have already minted
    address private _owner;                                 // owner of the token

    constructor() ERC20("ERC20Token", "ERC20") {
        _owner = msg.sender;
        uint initialSupply = 100000000000000000000;
        whitelistMinters[_owner] = initialSupply;   // owner of the contract is whitelisted for initial amount of tokens
        alreadyMinted[msg.sender] = false;          // Not yet minted by the onwer
        remainingSupply -= initialSupply;           // update the remaining supply for future whitelisting
    }

    // only owner of the contract call whitelist an address for minting
    function whitelist(address addr, uint amount) external {
        require(msg.sender == _owner, "Only owner can call this function");                             // check if owner
        require(remainingSupply > 0, "All tokens have been whitelisted or minted");                     // check the remaining supply
        require(whitelistMinters[addr] == 0, "The address has already been whitelisted");               // check if already whitelisted
        require(amount <= remainingSupply, "Amount must be less than equal to the remaining supply");   // check if the amount is less than or equal to the remaining supply
        whitelistMinters[addr] = amount;                                                                // whitelist the address
        alreadyMinted[msg.sender] = false;                                                              // not yet minted by the minter
        remainingSupply -= amount;                                                                      // update the remaining supply for future whitelisting
    }

    function mint() external {
        require(whitelistMinters[msg.sender] > 0, "You are not a whitelisted minter");              // check if the sender is whitelisted
        _mint(msg.sender, whitelistMinters[msg.sender]);                                            // mint tokens for the sender
        whitelistMinters[msg.sender] = 0;                                                           // remove sender as whitelisted, so can be added for future whitelisting
        alreadyMinted[msg.sender] = true;                                                           // set the sender as already minted for the owner to know which address has already minted the tokens
    }

    // only owner of the contract can see who has already minted
    function checkMinted(address addr) external view returns (bool) {
        require(msg.sender == _owner, "Only owner can call this function");                         // check if owner
        return alreadyMinted[addr];                                                                 // return the status for the minter
    }

    // only owner of the contract can see the remaining supply left to be minted
    function checkRemainingSupply() external view returns (uint) {
        require(msg.sender == _owner, "Only owner can call this function");                         // check if owner
        return remainingSupply;                                                                     // return the status
    }

}

