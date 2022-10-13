// "SPDX-License-Identifier: MIT"

pragma solidity 0.8.7;

contract MappingPlayer{

    mapping(address =>uint) public player;
    address[] public playersList;

    function setPlayer(address _address, uint _balance) external {
        player[_address] = _balance;
        playersList.push(_address);
    }

    function getPlayer() external view returns (uint[] memory,address[] memory){
        uint[] memory playersBalance = new uint[](playersList.length);
        
        for(uint i =0;i<playersList.length;i++)
        {
            playersBalance[i]= player[playersList[i]];
        }
        
        return (playersBalance,playersList);

    }
}