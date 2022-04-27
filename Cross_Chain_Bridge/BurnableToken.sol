// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "../standarts/ERC20.sol";
import "./IBurnableToken.sol";

contract BurnableToken is ERC20, IBurnableToken{
    address public bridge;
    address public owner;

    constructor() ERC20(100000000, "BurnableToken", 2, "BTK"){
        owner = msg.sender;
    }
    
    function burn(address from, uint amount) external override returns(bool){
        require(msg.sender == bridge, "Haven'r permissions");
        require(balances[from] >= amount, "Haven't money enough to transfer");
        balances[from] -= amount;
        totalSupply -= amount;
        return true;
    }

    function mint(address to, uint amount) external override returns(bool){
        require(msg.sender == bridge, "Haven'r permissions");
        require(balances[to] >= amount, "Haven't money enough to mint");
        balances[to] += amount;
        totalSupply += amount;
        return true;
    }

    function SetBridge(address _bridge) public override{
        require(msg.sender == owner, "Haven't permsissions");
        bridge = _bridge;
    }
}