// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/CrosschainReceiver.sol";
import "../src/mocks/mockComet.sol";
import "../src/mocks/mockFacuet.sol";
import "../src/SwapTestnetUSDC.sol";
import "../src/mocks/mockERC20.sol";

contract CrossChainReceiverTest is Test {
    CrossChainReceiver public crossChainReceiver;
    MockComet public mockComet;
    SwapTestnetUSDC public swapTestnetUSDC;
    ERC20Mock public usdcToken;
    ERC20Mock public compoundUsdcToken;
     MockFauceteer public fauceteer;
    address public ccipRouter;
    address public owner;
    address public sender;

    function setUp() public {
        owner = address(this);
        ccipRouter = address(0x123);
        sender = address(0x456);

        usdcToken = new ERC20Mock("USDC", "USDC", owner, 10000 * 10**18);
        compoundUsdcToken = new ERC20Mock("Compound USDC", "cUSDC", owner, 10000 * 10**18);

        mockComet = new MockComet();

        fauceteer = new MockFauceteer();

        swapTestnetUSDC = new SwapTestnetUSDC(address(usdcToken), address(compoundUsdcToken), address(fauceteer));

        crossChainReceiver = new CrossChainReceiver(ccipRouter, address(mockComet), address(swapTestnetUSDC));

        crossChainReceiver.allowlistSourceChain(1, true);
        crossChainReceiver.allowlistSender(sender, true);
    }

    function testCcipReceive() public {
        uint256 amount = 100 * 10**18; // 100 USDC to the receiver contract 
        usdcToken.mint(address(crossChainReceiver), amount);

        // construct a Client.EVMTokenAmount (USDC.addr, 50 USDC)
        Client.EVMTokenAmount memory tokenAmount = Client.EVMTokenAmount({
            token: address(usdcToken),
            amount: 50 * 10**18
        });
        // add this to a array 
        Client.EVMTokenAmount[] memory tokenAmounts = new Client.EVMTokenAmount[](1);
        tokenAmounts[0] = tokenAmount;
        // construct a extraArgs 
        /*
        struct EVMExtraArgsV1 {
        uint256 gasLimit;
        }
        */
        Client.EVMExtraArgsV1 memory extra = Client.EVMExtraArgsV1({
            gasLimit: 500000
        });
        
        // router tell the receiver that sender sends 50 usdc

       Client.Any2EVMMessage memory message = Client.Any2EVMMessage({
        messageId: bytes32(0),
        sourceChainSelector: 1,
        sender: abi.encode(sender),
        data: abi.encodePacked("supply(address,uint256)"),
        destTokenAmounts: tokenAmounts // 50 USDC
        });

        vm.prank(ccipRouter);
        crossChainReceiver.ccipReceive(message);

    }

    function testCcipReceiveRevoke() public {
        uint256 amount = 100 * 10**18; // 100 USDC to the receiver contract 
        usdcToken.mint(address(crossChainReceiver), amount);

        // construct a Client.EVMTokenAmount (USDC.addr, 50 USDC)
        Client.EVMTokenAmount memory tokenAmount = Client.EVMTokenAmount({
            token: address(usdcToken),
            amount: 50 * 10**18 + 1
        });
        // add this to a array 
        Client.EVMTokenAmount[] memory tokenAmounts = new Client.EVMTokenAmount[](1);
        tokenAmounts[0] = tokenAmount;
        // construct a extraArgs 
        /*
        struct EVMExtraArgsV1 {
        uint256 gasLimit;
        }
        */
        Client.EVMExtraArgsV1 memory extra = Client.EVMExtraArgsV1({
            gasLimit: 500000
        });
        
        // router tell the receiver that sender sends 50 usdc

       Client.Any2EVMMessage memory message = Client.Any2EVMMessage({
        messageId: bytes32(0),
        sourceChainSelector: 1,
        sender: abi.encode(sender),
        data: abi.encodePacked("supply(address,uint256)"),
        destTokenAmounts: tokenAmounts // 50 USDC
        });

        vm.prank(ccipRouter);
        crossChainReceiver.ccipReceive(message);

       
    }

    function testCcipReceiveRevokeDirect() public {

        crossChainReceiver.setSimRevert(true);
        uint256 amount = 100 * 10**18; // 100 USDC to the receiver contract 
        usdcToken.mint(address(crossChainReceiver), amount);

        // construct a Client.EVMTokenAmount (USDC.addr, 50 USDC)
        Client.EVMTokenAmount memory tokenAmount = Client.EVMTokenAmount({
            token: address(usdcToken),
            amount: 50 * 10**18 + 1
        });
        // add this to a array 
        Client.EVMTokenAmount[] memory tokenAmounts = new Client.EVMTokenAmount[](1);
        tokenAmounts[0] = tokenAmount;
        // construct a extraArgs 
        /*
        struct EVMExtraArgsV1 {
        uint256 gasLimit;
        }
        */
        Client.EVMExtraArgsV1 memory extra = Client.EVMExtraArgsV1({
            gasLimit: 500000
        });
        
        // router tell the receiver that sender sends 50 usdc

       Client.Any2EVMMessage memory message = Client.Any2EVMMessage({
        messageId: bytes32(0),
        sourceChainSelector: 1,
        sender: abi.encode(sender),
        data: abi.encodePacked("supply(address,uint256)"),
        destTokenAmounts: tokenAmounts // 50 USDC
        });

        vm.prank(ccipRouter);
        crossChainReceiver.ccipReceive(message);

    }
}

/*
struct EVM2AnyMessage {
  bytes receiver;
  bytes data;
  struct Client.EVMTokenAmount[] tokenAmounts;
  address feeToken;
  bytes extraArgs;
}
*/
