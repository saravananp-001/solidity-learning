// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AssemblyC {

    // Comparison Functions:
    //     lt(a, b): Less than.
    //     gt(a, b): Greater than.
    //     eq(a, b): Equal to.
    //     iszero(a): Is zero.

    // Arithmetic Functions:
    //     add(a, b): Addition.
    //     sub(a, b): Subtraction.
    //     mul(a, b): Multiplication.
    //     div(a, b): Division.
    //      

    // Memory Functions
    //     mstore(0x80,80): store 80 into 0x80 memory location.
    //     mload(0x80):load the 0x80 memory

    // storage Functions
    //     sstore(0x80,80): store 80 into 0x80 contract storage location. (fees)
    //     sload(0x80):load the 0x80 from the contract storage

    function getminX(uint256 _x, uint _y) external pure returns(uint256 _z){

        assembly{
            if lt(_x,_y){
                _z := _x
            }
        }
    }

    function getmin(uint256 _x, uint _y) external pure returns(uint256 _z){

        assembly{
            switch lt(_x,_y)
                case 1 {
                    _z:=_x
                }
                default {
                    _z:=_y
                }
        }
    }

}
