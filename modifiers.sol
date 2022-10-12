// "SPDX-License-Identifier: MIT"
pragma solidity 0.8.7;

contract Modifiers{

    address public sender = msg.sender;
    error valueCheckError(uint, string);
    modifier valueCheck(uint _x)
    {
        require(_x > 10 , "The value of the x should be greater then 10");
        _;
        _;
     
    }

    modifier valueheigher(uint _x)
    {
        require(_x > 15 , "value must be heigher for the multiplication");
        _;
    }

    function addValue(uint _num) external pure valueCheck(_num) returns(uint){
        _num += 10;
        return _num;
    }

    function subValue(uint _num) external pure returns(uint){
        if(_num < 10)
        {
            revert valueCheckError(_num,"value must be higher then the 10");
        }
        _num = _num - 10;
        return _num;
    }

    function doubleModifierCheck(uint _num) external pure valueCheck(_num) returns (uint){
        _num = _num * 2;
        return _num;
    }
}