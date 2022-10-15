// "SPDX-License-Identifier: MIT"
pragma solidity 0.8.7;

contract A {
    function foo() public pure virtual returns (string memory){
        return "A" ;
    }
}

contract B is A {
    function foo() public pure virtual override returns (string memory){
        return "B" ;
    }
}

contract C is A{
    function foo() public pure virtual override returns (string memory){
        return "C" ;
    }
}

contract D is A,C,B{
    function foo() public pure override(C,B,A) returns (string memory){
        return super.foo();
    }
}
