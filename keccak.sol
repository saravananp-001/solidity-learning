// "SPDX-License-Identifier: MIT"
pragma solidity 0.8.7;

contract Hashing {
    function encode(string memory _text1,string memory _text2) external pure returns(bytes memory){
        return abi.encode(_text1,_text2);
    }

    function encodepacked(string memory _text1,string memory _text2) external pure returns(bytes memory){
        return abi.encodePacked(_text1,_text2);
    }

    // its like a addition like aaa + bbb = aaabbb
    function hasingpacked(string memory _text1, string memory _text2) external pure returns(bytes32){
        return keccak256(abi.encodePacked(_text1,_text2));  
    }
    
    function hasing(string memory _text1, string memory _text2) external pure returns(bytes32){
        return keccak256(abi.encode(_text1,_text2));
    }
}
