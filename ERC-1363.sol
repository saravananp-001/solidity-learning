// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IERC1363 is IERC20 {
    function transferAndCall(address to, uint256 value) external returns (bool);
    function transferAndCall(address to, uint256 value, bytes calldata data) external returns (bool);
    function transferFromAndCall(address from, address to, uint256 value) external returns (bool);
    function transferFromAndCall(address from, address to, uint256 value, bytes calldata data) external returns (bool);
    function approveAndCall(address spender, uint256 value) external returns (bool);
    function approveAndCall(address spender, uint256 value, bytes calldata data) external returns (bool);
}

interface IERC1363Receiver {
    function onTransferReceived(address operator, address from, uint256 value, bytes calldata data) external returns (bytes4);
}

interface IERC1363Spender {
    function onApprovalReceived(address owner, uint256 value, bytes calldata data) external returns (bytes4);
}

contract ARC20Token is IERC1363, IERC1363Receiver, IERC1363Spender, IERC165 {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 private _totalSupply;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 public receivedTokens;
    uint256 public aprovedTokens;

    event TokensReceived(address operator, address from, uint256 value, bytes data);
    event TokensApproved(address owner, uint256 value, bytes data);
    
    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
    bytes4 private constant _INTERFACE_ID_ERC20 = 0x36372b07;
    bytes4 private constant _INTERFACE_ID_ERC1363 = 0x4bbee2df;
    bytes4 private constant _INTERFACE_ID_ERC1363_RECEIVER = 0x88a7ca5c;
    bytes4 private constant _INTERFACE_ID_ERC1363_SPENDER = 0x7b04a2d0;
    
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 initialSupply
    ) {
        name = _name;
        symbol = _symbol;
        decimals = 18;
        _mint(msg.sender, initialSupply);
    }

    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) external view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
        return true;
    }

    function transferAndCall(address to, uint256 value) public override returns (bool) {
        return transferAndCall(to, value, "");
    }

    function transferAndCall(address to, uint256 value, bytes calldata data) public override returns (bool) {
        _transfer(msg.sender, to, value);
        require(_checkAndCallTransfer(msg.sender, to, value, data), "ARC20Token: _checkAndCallTransfer failed");
        return true;
    }

    function transferFromAndCall(address from, address to, uint256 value) public override returns (bool) {
        return transferFromAndCall(from, to, value, "");
    }

    function transferFromAndCall(address from, address to, uint256 value, bytes calldata data) public override returns (bool) {
        _transfer(from, to, value);
        _approve(from, msg.sender, _allowances[from][msg.sender] - value);
        require(_checkAndCallTransfer(from, to, value, data), "ARC20Token: _checkAndCallTransfer failed");
        return true;
    }

    function approveAndCall(address spender, uint256 value) public override returns (bool) {
        return approveAndCall(spender, value, "");
    }

    function approveAndCall(address spender, uint256 value, bytes calldata data) public override returns (bool) {
        _approve(msg.sender, spender, value);
        require(_checkAndCallApprove(spender, value, data), "ARC20Token: _checkAndCallApprove failed");
        return true;
    }

    function supportsInterface(bytes4 interfaceId) external view override returns (bool) {
        return 
            interfaceId == _INTERFACE_ID_ERC165 ||
            interfaceId == _INTERFACE_ID_ERC20 ||
            interfaceId == _INTERFACE_ID_ERC1363 ||
            interfaceId == _INTERFACE_ID_ERC1363_RECEIVER ||
            interfaceId == _INTERFACE_ID_ERC1363_SPENDER;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ARC20Token: transfer from the zero address");
        require(recipient != address(0), "ARC20Token: transfer to the zero address");

        _balances[sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ARC20Token: approve from the zero address");
        require(spender != address(0), "ARC20Token: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ARC20Token: mint to the zero address");

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    function _checkAndCallTransfer(address sender, address recipient, uint256 amount, bytes memory data) internal returns (bool) {
        if (!isContract(recipient)) {
            return false;
        }
        bytes4 retval = IERC1363Receiver(recipient).onTransferReceived(msg.sender, sender, amount, data);
        return (retval == IERC1363Receiver(recipient).onTransferReceived.selector);
    }

    function _checkAndCallApprove(address spender, uint256 value, bytes memory data) internal returns (bool) {
        if (!isContract(spender)) {
            return false;
        }
        bytes4 retval = IERC1363Spender(spender).onApprovalReceived(msg.sender, value, data);
        return (retval == IERC1363Spender(spender).onApprovalReceived.selector);
    }

    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    // Implement IERC1363Receiver
    function onTransferReceived(address operator, address from, uint256 value, bytes calldata data) external override returns (bytes4) {
        // Update the state variable when tokens are received
        receivedTokens += value;

        // Emit an event
        emit TokensReceived(operator, from, value, data);

        // Return the selector to confirm the token transfer
        return this.onTransferReceived.selector;
    }

    function onApprovalReceived(address owner, uint256 value, bytes calldata data) external override returns (bytes4){
        aprovedTokens += value;

        // Emit an event
        emit TokensApproved(owner, value, data);

        // Return the selector to confirm the token approval
        return this.onApprovalReceived.selector;

    }
}
