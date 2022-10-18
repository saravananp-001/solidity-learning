// "SPDX-License-Identifier: MIT"
pragma solidity 0.8.7;

interface ITestContrace {
    function set(uint _a) external;
    function decrement() external;
}

contract callContract{

    fallback() external payable{}

    function setC(TestContract _conAddr,uint _a) external {
        _conAddr.set(_a);
    }

    function getC(TestContract _conAddr) external view returns(uint) {
        return _conAddr.get();
    }

    function increementC(address _conAddr) external payable {
        (bool success,) = _conAddr.call{value:100}(abi.encodeWithSignature("increement()")); // send eth by the call function
        require(success,"function failed");
    }
    
    function inCreementC(address _conAddr) external payable {
        (bool success,) = _conAddr.call{value:100}(abi.encodeWithSignature("increementt()")); // send eth by the call function here the function name differ but the status is TRUE
        require(success,"function failed");
    }

    function decrementC(address _conAddr) external {
        ITestContrace(_conAddr).decrement();
    }
}

contract TestContract{
    uint value; 

    event log(string data);

    fallback() external payable {
        emit log("fallback called");
    }  // it can receives the eth

    function set(uint _a) external {
        value = _a;
    }

    function get() external view returns(uint){
        return value;
    }

    function increement() external payable {
        value++;
    }

    function decrement() external {
        value --;
    }
}