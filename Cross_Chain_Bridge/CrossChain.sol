// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "./IBurnableToken.sol";

contract CrossChain {
    address owner;
    IBurnableToken public tokenBurn;
    IBurnableToken public tokenMint;

    constructor(address _tokenBurn, address _tokenMint){
        owner = msg.sender;
        tokenBurn = IBurnableToken(_tokenBurn);
        tokenMint = IBurnableToken(_tokenMint);
    }   

    struct Transaction {
        uint TransactionID;
        address sender;
        uint amount;
        bool burned;
    } 

    mapping (address=>Transaction[]) public trans_map;

    modifier CheckExist(address userAddr, uint id) {
        require(trans_map[userAddr][id].sender != address(0), "This transactions doesn't exist");
        _;
    }

    function GetInfo(address userAddr, uint id) public view CheckExist(userAddr, id) returns(Transaction memory transaction){
        return trans_map[userAddr][id];
    }
    
    function CreateTransaction(uint amount) public returns(uint){
        trans_map[msg.sender].push(Transaction(trans_map[msg.sender].length, msg.sender, amount, false));
        return trans_map[msg.sender].length;
    }

    function BurnToken(uint id) public CheckExist(msg.sender, id) returns(bool result){
        require(!trans_map[msg.sender][id].burned, "This transaction is already ended");
        result = tokenBurn.burn(msg.sender, trans_map[msg.sender][id].amount);
        trans_map[msg.sender][id].burned = result;
    }
}