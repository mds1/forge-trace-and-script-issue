## Foundry Bugs

This repo demonstrates a few foundry bugs.
To get started, install dependencies with `forge install`, then run `cp .env.template .env` and fill out your `MAINNET_RPC_URL`.

Afterwards:
1. Open a terminal and run `make local` to start anvil
2. In a separate window run:

```
make salt=0x6f272f65fe67ff8eff9400d636989aa6f6056040a1b907484829fc8c930bd846 \
  rpc=http://127.0.0.1:8545 \
  private-key=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 \
  deploy
```

This will run the deploy script, which should fail.

Note that there seems to be some sensitivity to salt here.
The one provided fails (with out of gas), but others succeed.
Haven't investigated yet, maybe it results in a different number of zeros which aren't metered properly in anvil?

## Issue 1: More verbose failure messages in scripts

The script fails and says:
```
Error:
Transaction Failure: 0x7c1a…85d2
```
This is pretty cryptic and gives no info on why it failed.
A better error message should be provided.

## Issue 2: Properly show failed trace

Try debugging with the below (we use `txHash=0x7c1a7191a4ef0b6d9e328df03e5d31bbaba6480d9a75df12845301246e2f85d2`, double check that you have the same failed tx hash):

```
$ cast run $txHash --rpc-url http://127.0.0.1:8545
Executing previous transactions from the block.
Traces:
  [45343] 0xe42c…301f::mint(0x4b0b71dbc20725244d037753d6e340ca7c2797c3, 1000000000000000000)
    ├─ emit Transfer(param0: 0x0000000000000000000000000000000000000000, param1: 0x4b0b71dbc20725244d037753d6e340ca7c2797c3, param2: 1000000000000000000)
    └─ ← ()


Script ran successfully.
Gas used: 66975
```

This shows the transaction succeeded, but we know it reverted (you can verify with `cast receipt`).
This should show a revert and the revert reason.

Additionally, the transfer event is not using the parameter names in the defined event, and is instead defaulting to `param0`, `param1`, `param2`.

## Issue 3: Properly decode revert reasons in 1 and 2 above

Run `cast tx $txHash --rpc-url http://127.0.0.1:8545` and `cast receipt $txHash --rpc-url http://127.0.0.1:8545`.
You'll notice the gas sent with the transaction equals the gas used in the receipt, indicating an out of gas failure.
Adding `--gas-estimate-multiplier 200` to our script command works, indicating this is the correct failure reason.

## Issue 4: Improve gas estimation in scripts

A takeaway of the above is that somehow the default gas estimation is not working properly.
