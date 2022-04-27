// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "../standarts/erc20.sol";

contract LizokToken is ERC20 {
    constructor() ERC20(1000, "LizokToken", 0, "LKTK") {}
}