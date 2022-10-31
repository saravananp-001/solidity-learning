// "SPDX-License-Identifier: MIT"

// here the callContract setvalue() function changes the value of the testcontract static variable values so iths a delihgateCall
pragma solidity 0.8.7;

contract callContract{
    
    string public name;
    uint public balance;

    function setvalue(string memory _name,uint _bal ) external {
            name = _name;
            balance = _bal;
    }

}

contract TestContract{

    string public name;
    uint public balance;

    function setValue(address _addr, string memory _name,uint _bal) external {

    //    (bool sucess,)= _addr.delegatecall(abi.encodeWithSignature("setvalue(string,uint256)",_name,_bal));
       (bool sucess2,)= _addr.delegatecall(abi.encodeWithSelector(callContract.setvalue.selector, _name,_bal));
    //    require(sucess,"function failed");
        require(sucess2,"function failed");
        
    }

}

contract normalContract{

    string public name;
    uint public balance;

    function setValue(address _addr, string memory _name,uint _bal) external {

       (bool sucess,)= _addr.call(abi.encodeWithSignature("setvalue(string,uint256)",_name,_bal));
       require(sucess,"function failed");
        
    }

}