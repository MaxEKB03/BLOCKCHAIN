// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "../standarts/ERC20.sol";

interface IBurnableToken is IERC20{

    function burn(address from, uint amount) external returns(bool);

    function mint(address to, uint amount) external returns(bool);

    function SetBridge(address _bridge) external;
}