// "SPDX-License-Identifier: MIT"

pragma solidity 0.8.7;

contract PlayerList{
    event check(string data);
    event nameVar(string _pl,string _na);
    struct Player{
        address addr;
        uint balance;
    }

    mapping (string =>Player) public players;
    string[] public playersList;

    function set() external {
        Player memory player = Player({addr:msg.sender,balance:10});
        players["virat"] = player;
    }

    function setPlayerData(string calldata _name,uint _balance) external {
        //(i<=playersList.length)||(playersList.length == 0)
        bool change;
        if(playersList.length == 0)
        {
            Player memory player = Player({addr:msg.sender,balance:_balance});
            players[_name] = player;
            playersList.push(_name);
        }
        else{
            for(uint i =0;i<playersList.length;i++){
                if(keccak256(abi.encodePacked(_name)) != keccak256(abi.encodePacked(playersList[i])))
                {   
                    emit nameVar(playersList[i],_name);
                    change = true;
                }
                else{
                    change =false;
                    break;
                }
            }
            if(change ==true)
            {
                Player memory player =Player({addr:msg.sender,balance:_balance});
                players[_name] = player;
                playersList.push(_name);
                emit check("inserted");
            }
        }

    }

    function getPlayersList() external view returns(string[] memory){
            return playersList;
    }
    function getPlayerscount() external view returns(uint) {
        return playersList.length;
    }
}