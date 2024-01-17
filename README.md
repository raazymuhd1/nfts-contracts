

## A little caveats on writing upgradable smart contract
 - ur smart contract that uses a proxy contract cannot have a constructor ( instead use a regular function to replace constructor );
 - for using regular function u need to check that only can called/run once ( like constructor )
 - avoid defined an initial value to any state variable ( bocz its like defined in constructor, and upgradable contract won't work bcoz of that )

 ## Upgradable contract 
 - uups pattern
   1. we create our first implementation
   2. then attach it to a proxy contract
    - we use this proxy contract address, whenever user make a function call this proxy the proxy contract will point all that call to our implementation


  
## Deployed NFT ( ERC721 & ERC1155 )

- ERC1155 - 0x81EB29Ff79bd516B99Dad95AC876F1102Dbf0B14
- ERC721 - 