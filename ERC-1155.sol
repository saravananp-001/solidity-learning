// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract myERC is ERC1155URIStorage, Ownable{
    
    uint256 private constant GOLD = 0;
    uint256 private constant SILVER = 1;
    uint256 private constant THORS_HAMMER = 2;
    uint256 private constant SWORD = 3;
    uint256 private constant SHIELD = 4;

    event ERC1155Received(address operator, address from, uint256 id, uint256 value, bytes data);
    event ERC1155BatchReceived(address operator, address from, uint256[] ids, uint256[] values, bytes data);

    constructor() ERC1155("https://game.example/api/item/{id}.json") Ownable(msg.sender){
        minTokens();
    }

    function minTokens() private {
        _mint(msg.sender, GOLD, 10**18, "");
        _mint(msg.sender, SILVER, 10**27, "");
        _mint(msg.sender, THORS_HAMMER, 1, "");
        _mint(msg.sender, SWORD, 10**9, "");
        _mint(msg.sender, SHIELD, 10**9, "");
    }

    function setUri(uint256 tokenId, string memory tokenURI) external {
        _setURI(tokenId,tokenURI);
    }

    function setBaseURI(string memory baseURI) external {
        _setBaseURI(baseURI);
    }
    
    function onERC1155Received(address operator, address from,uint256 id, uint256 value, bytes memory data) external returns (bytes4){
        emit ERC1155Received(operator, from, id, value, data);
        return this.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external returns (bytes4){
        emit ERC1155BatchReceived(operator, from, ids, values, data);
        return this.onERC1155BatchReceived.selector;
    }
}
