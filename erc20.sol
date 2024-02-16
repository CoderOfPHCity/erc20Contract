// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract Erc {
    string public name;
    string public symbol;
    uint public totalSupply;
    uint public decimal;
    address public owner;

    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;

    modifier onlyOwner {
        require(owner == msg.sender, "Only the owner can call this function");
        _;
    }

    constructor() {
        name = "DanielToken";
        symbol = "DTN";
        totalSupply = 10000;
        decimal = 1e18;
        owner = msg.sender;
        balanceOf[msg.sender] = totalSupply;
    }

    function mint(uint _value) public {
        require(msg.sender == owner, "Only the owner can mint tokens");
        totalSupply += _value;
        balanceOf[msg.sender] += _value;
    }

    function burn(uint _value) public {
        require(msg.sender == owner, "Only the owner can burn tokens");
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        totalSupply -= _value;
        balanceOf[msg.sender] -= _value;
    }

    function transfer(address _to, uint _amount) public onlyOwner {
        require(balanceOf[msg.sender] >= _amount, "Insufficient balance");
        uint interest = (_amount * 1) / 100;
        uint total = interest + _amount;
        require(totalSupply >= total, "Total supply exceeded");
        balanceOf[msg.sender] -= total;
        balanceOf[_to] += _amount;
        totalSupply -= total;
    }

    function transferFrom(address _from, address _to, uint _amount) public {
        require(allowance[_from][msg.sender] >= _amount, "Allowance exceeded");
        require(balanceOf[_from] >= _amount, "Insufficient balance");
        allowance[_from][msg.sender] -= _amount;
        uint interest = (_amount * 1) / 100;
        uint total = interest + _amount;
        require(totalSupply >= total, "Total supply exceeded");
        balanceOf[_from] -= total;
        balanceOf[_to] += _amount;
        totalSupply -= total;
    }
}
