// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/mocks/mockComet.sol";

contract MockCometTest is Test {
    MockComet public mockComet;
    address public user;

    function setUp() public {
        user = address(this);
        mockComet = new MockComet();
    
    }

    function testSupplyConsumesGas() public {
        uint256 amount = 100 * 10**18;
      

        uint256 gasBefore = gasleft();
        mockComet.supply(address(0x0), amount);
        uint256 gasAfter = gasleft();
        uint256 gasUsed = gasBefore - gasAfter;

        
    }
}