// "SPDX-License-Identifier: MIT"

pragma solidity 0.8.7;

contract Constructors{

    uint a =0;
    uint b= 0;

    // fallback() payable external {

    // }
    receive() payable external{

    }

    constructor(uint _a, uint _b) payable {
        a = _a;
        b = _b;
    }

    function sendETH() external payable {

    }

    function getValues() external view returns(uint ,uint){
        return (a,b);
    }

    function ethBalance() external view returns(uint){
        return address(this).balance;
    }
}

contract B is Constructors{
    constructor(uint _a, uint _b) Constructors(_a,_b)
    {
    }

}

contract C is Constructors(10,12){

}