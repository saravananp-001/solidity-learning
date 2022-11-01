// "SPDX-License-Identifier: MIT"
pragma solidity 0.8.7;

library Math {
    function sum (uint _x ,uint _y) internal pure returns(uint){
        return _x + _y ;
    }

    function subraction (uint _x ,uint _y) internal pure returns(uint) {
        return (_x > _y)? _x - _y : _y - _x;
    }
}

contract Student {

    using Math for uint;
    uint val = 10; 
    function sum(uint _a ,uint _b) external pure returns(uint){
        return Math.sum(_a, _b);
    }

    function difference (uint _a) external view returns(uint) {
        return val.subraction(_a);
    }

}