// "SPDX-License-Identifier: MIT"
pragma solidity 0.8.7;

contract A {
    error balanceUnAvailable(uint,string,uint);
    receive() payable external {

    }

    function foo() internal virtual pure returns(string memory) {
        return "foo A";
    }
    function boo() internal virtual pure returns(string memory) {
        return "boo A";
    }

    function sendETH(address payable _addr,uint _amount) payable external {
        // require(_amount < address(this).balance,"the amount should be less then the contract eth balance");
        if(_amount > address(this).balance)
        {
            revert balanceUnAvailable(_amount,"the given amount must less the the actual ETH",address(this).balance);
        }
        _addr.transfer(_amount);
    }

}

contract B is A {

    function foo() internal pure override returns(string memory) {
        return A.foo();   
    }

    function boo() internal pure override returns(string memory) {
        return "boo B";
    }

    function checkFoo() external pure returns(string memory) {
        return foo();
    }

    function checkBoo() external pure returns(string memory) {
        return boo();
    }
}