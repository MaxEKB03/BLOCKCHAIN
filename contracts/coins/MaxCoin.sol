// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "../standarts/erc20.sol";

contract MaxCoin is ERC20 {
    constructor() ERC20(1000, "MaxCoin", 0, "MXC") {}
}