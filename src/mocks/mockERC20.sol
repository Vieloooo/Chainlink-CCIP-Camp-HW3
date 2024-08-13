// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC20} from "@chainlink/contracts-ccip/src/v0.8/vendor/openzeppelin-solidity/v4.8.3/contracts/token/ERC20/ERC20.sol";

// mock class using ERC20
contract ERC20Mock is ERC20 {
    constructor(
        string memory name,
        string memory symbol,
        address initialAccount,
        uint256 initialBalance
    ) payable ERC20(name, symbol) {
        _mint(initialAccount, initialBalance);
    }

    function mint(address account, uint256 amount) public {
        _mint(account, amount);
    }

}