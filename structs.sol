// "SPDX-License-Identifier: MIT"

pragma solidity 0.8.7;

contract Structures{

    struct Player{
        string name;
        address playerAddr;
        uint balance;
    }

    Player public player;
    Player[] public players;

    error deleteerror(string);

    function setPlayerInfoByPlayer(string calldata _name) external {
        Player memory p1 = Player(_name,msg.sender,10);
        players.push(p1);
    }

    function setPlayersByAdmin() external {
        Player memory p1 = Player({name:"virat",playerAddr:address(1),balance:12});
        // Player memory p2("rohit",address(2),12);
        players.push(Player("rohit",address(2),12));
        player = p1;
    }

    function deletePlayerList(string calldata _name) external returns(bool){
        bool playerDelete;
        for(uint i=0;i<players.length;i++)
        {
            if(keccak256(abi.encodePacked(_name)) ==keccak256(abi.encodePacked(players[i].name)))
            {
                delete players[i];
                playerDelete = true;
                break;
            }
        }

        if(!playerDelete)
        {
            revert deleteerror("no players in the Players list");
        }
        else
        return true;

    }

    function getPlayernames() external view returns (string memory){
        string[] memory names;
        
        for(uint i =0;i<players.length;i++)
        {
            // names.push(players[i].name);
            names[i] = players[i].name;
        }
    }

}