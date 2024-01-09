### DAO
- [https://docs.openzeppelin.com/contracts/4.x/governance#setup](build-dao)

### ACCOUNT ABSTRACTION EIP-4337
- [https://eips.ethereum.org/EIPS/eip-4337](account-abstraction)

## ETHEREUM NAME SERVICE (ENS)
[https://eips.ethereum.org/EIPS/eip-137](ethereum-name-service)

k
## A little caveats on writing upgradable smart contract
 - ur smart contract that uses a proxy contract cannot have a constructor ( instead use a regular function to replace constructor );
 - for using regular function u need to check that only can called/run once ( like constructor )
 - avoid defined an initial value to any state variable ( bocz its like defined in constructor, and upgradable contract won't work bcoz of that )