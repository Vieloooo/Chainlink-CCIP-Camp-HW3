// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/SwapTestnetUSDC.sol";
import {ERC20Mock} from
    "../src/mocks/mockERC20.sol";
import "../src/mocks/mockFacuet.sol";

contract SwapTestnetUSDCTest is Test {
    SwapTestnetUSDC public swapContract;
    ERC20Mock public usdcToken;
    ERC20Mock public compoundUsdcToken;
    MockFauceteer public fauceteer;
    address public user;

    function setUp() public {
        // erc20 owner address
        user = address(0x1);

        usdcToken = new ERC20Mock("USDC", "USDC",user, 10000 * 10**18);
        compoundUsdcToken = new ERC20Mock("Compound USDC", "cUSDC", user, 10000 * 10**18);
        fauceteer = new MockFauceteer();

        swapContract = new SwapTestnetUSDC(address(usdcToken), address(compoundUsdcToken), address(fauceteer));

        usdcToken.mint(address(swapContract), 1000 * 10**18);
        compoundUsdcToken.mint(address(swapContract), 1000 * 10**18);
    }

    function testSwapUSDCForCompoundUSDC() public {
        uint256 amount = 100 * 10**18;
        address alice = address(0x2); 
        usdcToken.mint(alice, amount);
        vm.prank(alice);
        usdcToken.approve(address(swapContract), amount);

        vm.prank(alice);
        swapContract.swap(address(usdcToken), address(compoundUsdcToken), amount);

        assertEq(usdcToken.balanceOf(alice), 0);
        assertEq(compoundUsdcToken.balanceOf(alice), amount);
    }


}