// "SPDX-License-Identifier: MIT"
pragma solidity 0.8.7;

contract ERC20 {

    address owner;
    uint256 public totalSupply = 10000;
    string public name;
    string public symbol;
    uint8 public decimals = 8;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    error inSufficientBalance(string);
    error wrongOwner(string);

    constructor(string memory _name,string memory _symbol){
        name = _name;
        symbol = _symbol;
        owner = msg.sender;
        balanceOf[msg.sender] = totalSupply;
    }

    receive() payable external {
        emit Transfer(msg.sender,address(this),msg.value);
    }
    fallback() payable external {
        emit Transfer(msg.sender,address(this),msg.value);
    }


    modifier validBalaceCheck(uint256 bal, uint256 _amount){
        if(bal < _amount){
            revert inSufficientBalance("insufficient balance");
        }
        _;
    }
    modifier ownerCheck(address _sender){
        if(owner != _sender){
            revert wrongOwner("the sender is not a owner");
        }
        _;
    }

    function sendETH(address payable _receiver , uint256 _value) external ownerCheck(msg.sender) validBalaceCheck(address(this).balance, _value) returns(bool){
        _receiver.transfer(_value);
        return true;
    }

    function transfer(address _receiver, uint256 _value) public validBalaceCheck(balanceOf[msg.sender],_value) returns (bool success){
        // if(balanceOf[msg.sender] <_value){
        //     revert inSufficientBalance("insufficient balance");
        // }
        balanceOf[msg.sender] -=_value;
        balanceOf[_receiver] += _value;
        emit Transfer(msg.sender,_receiver,_value);
        return true;
    }

    function approve(address _spender, uint256 _value) public ownerCheck(msg.sender) validBalaceCheck(balanceOf[msg.sender],_value) returns (bool success){
        // if(owner == msg.sender){
        //     revert wrongOwner("the sender is not a owner");
        // }

        // if(balanceOf[msg.sender] <_value){
        //     revert inSufficientBalance("insufficient balance");
        // }
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender,_spender,_value);
        return true;
    }

    function transferFrom(address _from, address _receiver, uint256 _value) public ownerCheck(_from) validBalaceCheck(allowance[_from][msg.sender],_value) returns (bool success){
        // if(owner == _from){
        //     revert wrongOwner("the sender is not a owner");
        // }
        
        // if(allowance[_from][msg.sender] <_value){
        //     revert inSufficientBalance("insufficient balance");
        // }

        allowance[_from][msg.sender] -= _value;
        balanceOf[_from] -=_value;
        balanceOf[_receiver] +=_value;
        emit Transfer(_from , _receiver,_value);
        return true;
    }

    function mintToken(uint256 _value) external ownerCheck(msg.sender) returns(bool){
        // if(owner == msg.sender){
        //     revert wrongOwner("the sender is not a owner");
        // }

        balanceOf[msg.sender] +=_value;
        totalSupply += _value;

        emit Transfer(address(0) , msg.sender ,_value);
        return true;
    }

    function burn(uint256 _value) external ownerCheck(msg.sender) validBalaceCheck(balanceOf[msg.sender],_value) returns(bool){
        balanceOf[msg.sender] -=_value;
        totalSupply -= _value;
        emit Transfer(msg.sender , address(0), _value);
        return true;
    }
}