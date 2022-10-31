// "SPDX-License-Identifier: MIT"

pragma solidity 0.8.7;

contract Account{

    address public owner;
    address public bank;

    constructor(address _owner) payable {
        owner = _owner;
        bank = msg.sender;
    }

}

contract Bankaccount{

    Account[] public accounts;
    function createAccount(address _addr) external {
        Account account = new Account(_addr);
        accounts.push(account);
    }

}