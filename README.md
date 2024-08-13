# Chainlink CCIP Camp HW3 

This repo copy the USDC swap code from chainlink masterclass-3: https://cll-devrel.gitbook.io/ccip-masterclass-4/ccip-masterclass/exercise-2-deposit-transferred-usdc-to-compound-v3

The mission of this homework is to have a well-rounded gas test for the `ccipReceive()` function, in which "the `CrossChainReceiver.sol` smart contract will swap received USDC tokens for Compound's mock USDC tokens, deposit those mock tokens into the Compound V3 by calling the `Comet.sol` smart contract's supply function and `CrossChainReceiver.sol` smart contract should get COMP tokens in return" )

The call flow: USDC-Sender-A -> Router -> Receiver (1. first call `swap()` in exchange of cUSDC; 2. call `supply.sol`).

We test this two-phase receiver logic within Foundry. 

## How to Test 

As the Router, Swap are deployed locally, 