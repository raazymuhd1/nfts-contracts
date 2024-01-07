include .env

args := $(SEPOLIA_RPC_URL)

deploy-sepolia:; forge script script/DeployNFT:DeployNFT --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast -vvv
deploy-anvil:; forge script script/DeployNFT:DeployNFT --broadcast -vvv 