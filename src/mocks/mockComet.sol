// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {CometMainInterface} from "../CrosschainReceiver.sol";

contract MockComet is CometMainInterface {
    function supply(address asset, uint256 amount) external override {
        // Mock implementation that consumes 100,000 gas
        for (uint256 i = 0; i < 600; i++) {
            // Do nothing, just consume gas
        }
        
        // 50%, 50% revoke 
        if (amount % 2 == 1) {
            // fail this function, 
            revert("MockComet: supply failed");
        }
    }
}