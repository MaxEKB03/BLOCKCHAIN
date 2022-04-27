// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.0;

import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract Swapper {
    
    struct Swap{
        address owner1;
        address owner2;
        mapping (address => IERC20) token;
        mapping (address => bool) approve;
        mapping (address => bool) participate;
        mapping (address => uint) amount;
    }

    mapping (uint=>Swap) public swaps;
    mapping (address => IERC20) token;
    uint swapsCount;
    
    modifier CheckHolding(uint swapId) {
        require(swaps[swapId].participate[msg.sender], "Haven't permissions");
        _;
    }

    function InitSwap(address owner1, address owner2, address token1, address token2, uint amount1, uint amount2) public {
        swaps[swapsCount].owner1 = owner1;
        swaps[swapsCount].owner2 = owner2;
        swaps[swapsCount].token[owner1] = IERC20(token1);
        swaps[swapsCount].token[owner2] = IERC20(token2);
        swaps[swapsCount].participate[owner1] = true;
        swaps[swapsCount].participate[owner2] = true;
        swaps[swapsCount].amount[owner1] = amount1;
        swaps[swapsCount].amount[owner2] = amount2;
        swapsCount++;
    }

    function DeleteSwap(uint swapId) public CheckHolding(swapId){
        delete swaps[swapId];
    }

    function Approve(uint swapId) public CheckHolding(swapId){
        swaps[swapId].approve[msg.sender] = true;
    }

    function Deligate(uint swapId) public CheckHolding(swapId){
        address owner1 = swaps[swapId].owner1;
        address owner2 = swaps[swapId].owner2;
        IERC20 token1 = swaps[swapId].token[owner1];
        IERC20 token2 = swaps[swapId].token[owner2];
        uint amount1 = swaps[swapId].amount[owner1];
        uint amount2 = swaps[swapId].amount[owner2];

        require(swaps[swapId].approve[owner1], "Owner1 doesn't allowed swap");
        require(swaps[swapId].approve[owner2], "Owner2 doesn't allowed swap");
        require(token1.allowance(owner1, address(this)) >= amount1, "Owner1's allowance is lower than sad");
        require(token2.allowance(owner2, address(this)) >= amount2, "Owner2's allowance is lower than sad");

        token1.transferFrom(owner1, address(this), amount1);
        token2.transferFrom(owner2, address(this), amount2);

        token1.transfer(owner2, amount1);
        token2.transfer(owner1, amount2);
    }

    function GetSwapInfo(uint swapId) public view returns(
        address owner1, address owner2, 
        IERC20 token1, IERC20 token2, 
        uint amount1, uint amount2
        ){
        return (
            swaps[swapId].owner1, swaps[swapId].owner1,
            swaps[swapId].token[swaps[swapId].owner1], swaps[swapId].token[swaps[swapId].owner2],
            swaps[swapId].amount[swaps[swapId].owner1], swaps[swapId].amount[swaps[swapId].owner2]
        );
    }
}