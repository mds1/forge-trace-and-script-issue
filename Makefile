# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

local:
	anvil --fork-url $(MAINNET_RPC_URL) --fork-block-number 15143823

deploy:
	forge script script/DeployToken.s.sol --tc DeployToken -vvvv \
	--sig "run(bytes32)" ${salt} \
	--rpc-url ${rpc} \
	--private-key ${private-key} \
	--broadcast
