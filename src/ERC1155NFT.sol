// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import { ERC1155 } from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract NFT1155 is ERC1155 {
     error NFT1155_ZeroAddress();
     error NFT1155_NftBalanceIsZero();

     uint256 private s_nft = 0;
     uint256 private s_token = 1;
     string private s_baseUri = 'https://ipfs.io/ipfs/';
     
     mapping(uint256 id => string uri) private s_tokenUri;

     constructor() ERC1155(string.concat(s_baseUri, "QmSxqYRqvG5eSTZsKytVDx2JCQs1P3Tb2hBjPNDLkGv8rB/metadata1.json")) {
        _mint(msg.sender, s_nft, 1, "");
        _mint(msg.sender, s_token, 1000e18, "");

        s_tokenUri[s_nft] = "QmSxqYRqvG5eSTZsKytVDx2JCQs1P3Tb2hBjPNDLkGv8rB/metadata1.json";
     }

     function uri(uint256 id_) public view override returns(string memory) {
        string memory baseUri = s_baseUri;
        return string.concat(baseUri, s_tokenUri[id_]);
     }

     function mintNft(address to_) external returns(bool) {
         s_nft += 2;
         if(msg.sender == address(0)) {
            revert NFT1155_ZeroAddress();
         }

         _mint(to_, s_nft, 1, "");
         s_tokenUri[s_nft] = "QmSxqYRqvG5eSTZsKytVDx2JCQs1P3Tb2hBjPNDLkGv8rB/metadata1.json";
     }

     function tfInBatch(address to_, uint256 amount_, uint256 id_) external returns(bool) {
        bytes memory data = "tf success";

        if(msg.sender == address(0)) {
            revert NFT1155_ZeroAddress();
        }

        if(balanceOf(msg.sender, id_) <= 0) {
            revert NFT1155_NftBalanceIsZero();
        }

        setApprovalForAll(msg.sender, true);
        safeTransferFrom(msg.sender, to_, id_, amount_, data);
        return true;
     }

     function getBalance(address owner, uint256 id_) external view returns(uint balance) {
        balance = balanceOf(owner, id_);
     }

     function getNftCount() external view returns(uint256 totalNft) {
        totalNft = s_nft;
     }
}