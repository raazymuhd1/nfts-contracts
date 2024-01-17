include .env

args := $(SEPOLIA_RPC_URL)

deploy-sepolia:; forge script script/DeployNFT:DeployNFT --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast -vvv

deploy-erc721:; forge script script/DeployNFT:DeployNFT --broadcast -vvv 

deploy-erc1155:; forge script script/DeployERC1155.s.sol:DeployNFT1155 --broadcast -vvv 

deploy-erc721-sepolia:; forge script script/DeployNFT.s.sol:DeployNFT --private-key $(PRIVATE_KEY) --rpc-url $(SEPOLIA_RPC_URL) --etherscan-api-key $(ETHERSCAN_API_KEY) --verify --broadcast -vvv 

deploy-erc1155-sepolia:; forge script script/DeployERC1155.s.sol:DeployNFT1155 --private-key $(PRIVATE_KEY) --rpc-url $(SEPOLIA_RPC_URL) --broadcast -vvv 

gas-snapshot:; forge snapshot --snap gas-snapshot.txt

test-cover:; forge coverage