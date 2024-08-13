# Chainlink CCIP Camp HW3 

This repo copy the USDC swap code from chainlink masterclass-3: https://cll-devrel.gitbook.io/ccip-masterclass-4/ccip-masterclass/exercise-2-deposit-transferred-usdc-to-compound-v3

The mission of this homework is to have a well-rounded gas test for the `ccipReceive()` function, in which "the `CrossChainReceiver.sol` smart contract will swap received USDC tokens for Compound's mock USDC tokens, deposit those mock tokens into the Compound V3 by calling the `Comet.sol` smart contract's supply function and `CrossChainReceiver.sol` smart contract should get COMP tokens in return" )

The call flow: USDC-Sender-A -> Router -> Receiver (1. first call `swap()` in exchange of cUSDC; 2. call `supply.sol`).

We test this two-phase receiver logic within Foundry. 

## How to Test 

There are the contracts involved during our gas test: 
- Internal Contracts: 
    - `CrosschainReceiver.sol` 
    - `SwapTokenUSDC.sol` 
- External Contracts interact with the `ccipReceive()` funciton: 
    - `ERC20(USDC)`
    - `ERC20(cUSDC)`
    - `comet.sol`

Generally, we have following methods to evaulate: 
1. Deploy our internal contracts within testnet and interact with external contracts. 
2. Deploy our internal contracts and *real* external contract within the local network. 
3. Deploy our internal contracts locally and *mock* our external contracts within the local network. 

In method one, as we donot fully own the external contracts, we can not range all interaction results, and the test times is highly constrained by the amount of testnet-tokens. Besides, the test time within real testnet like sepolia will be quite long. 
In method two, the external contracts(especially the `comet.sol` contract, which has a list of sub-contract to interact, composing the full compound V3 protocol) are defficult to evaluate. 
In method three, we can mock the execution result of external contracts with simplier simulated contracts, and we can mock the gas cost by using data from other unite tests and on-chain data. For example, [this site](https://etherscan.io/advanced-filter?fadd=0xc3d688b66703497daa19211eedff47f25384cdc3&tadd=0xc3d688b66703497daa19211eedff47f25384cdc3&mtd=0xf2b9fdb8%7eSupply&txntype=2) logs the `Comet.supply()`'s gas cost within real world. 