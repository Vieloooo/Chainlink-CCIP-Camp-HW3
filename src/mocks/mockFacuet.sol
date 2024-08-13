// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC20Mock} from
    "./mockERC20.sol";

contract MockFauceteer {
    function drip(address token) external {
        ERC20Mock(token).mint(msg.sender, 1000 * 10**18); // Mint 1000 tokens to the caller
    }
}