// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.0;

import "../interfaces/IERC20.sol";

contract Swapper {
    
    struct Swap{
        address onwer1;
        address onwer2;
        mapping (address => IERC20) token;
        mapping (address => bool) approve;
        mapping (address => bool) participate;
    }

    mapping (uint=>Swap) public swaps;
    mapping (address => IERC20) token;
    uint swapsCount;
    
    modifier CheckHolding(uint swapId) {
        require(swaps[swapId].participate[msg.sender], "Haven't permissions");
        _;
    }

    function InitSwap(address onwer1, address onwer2, address token1, address token2) public {
        token[onwer1] = IERC20(token1);
        token[onwer2] = IERC20(token2);
        swaps[swapsCount] = Swap(onwer1, onwer2, token, IERC20(token2));
        swapsCount ++;
    }

    function DeleteSwap(uint swapId) public CheckHolding(swapId){
        delete swaps[swapId];
    }

    function Approve(uint swapId) public CheckHolding(swapId){
    }

    function Deligate(uint swapId) public CheckHolding(swapId){
        address owner1 = swaps[swapId].owner1;
        address owner2 = swaps[swapId].owner2;
        IERC20 token1 = swaps[swapId].token1;
        IERC20 token2 = swaps[swapId].token2;

    }
}