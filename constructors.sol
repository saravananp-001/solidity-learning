// "SPDX-License-Identifier: MIT"

pragma solidity 0.8.7;

contract Constructors{

    uint a =0;
    uint b= 0;

    // it wroks for both with data and without data
    // fallback() payable external {  

    // }

    // this receive works when without the data
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