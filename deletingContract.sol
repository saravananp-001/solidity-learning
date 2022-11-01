// "SPDX-License-Identifier: MIT"
pragma solidity 0.8.7;

contract Delete {

    event transfer(address _from,address _to ,uint256 _amount);

    constructor() payable{
        emit transfer(msg.sender,address(this),msg.value);
    }
    function kill() external {
        selfdestruct(payable(msg.sender));
    }

    function test() external pure returns(uint){
        return 123;
    }
}

contract Creater {

    function deleteContract(address _addr) external {
        Delete(_addr).kill();
    }

    function Balance() external view returns(address ,uint256){
        return (address(this),address(this).balance);
    }
}