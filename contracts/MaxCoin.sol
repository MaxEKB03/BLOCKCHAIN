// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "./erc20.sol";

contract MaxCoin is ERC20 {
    constructor() ERC20(10**20, "MaxCoin", 10, "MAX") {}
}