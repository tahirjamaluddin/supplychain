// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./ItemManager.sol";

contract Item {
    
    uint public priceInWei;
    uint public pricePaid;
    uint public index;
    ItemManager parentcontract;
    
    constructor(ItemManager _parentcontract, uint _priceInWei, uint _index) {
        priceInWei = _priceInWei;
        index = _index;
        parentcontract = _parentcontract;
    }
    
    receive() external payable {
        require(pricePaid == 0, "Item is paid already");
        require(priceInWei == msg.value, "Price not paid in full");
        pricePaid += msg.value;
        (bool success, ) = address(parentcontract).call{value: msg.value}(abi.encodeWithSignature("triggerPayment(uint256)", index));
        require(success, "Transaction not successfull, cancelling...");
    }
    
    function payMoney() public payable {
        require(pricePaid == 0, "Item is paid already");
        require(priceInWei == msg.value, "Price not paid in full");
        pricePaid += msg.value;
        (bool success, ) = address(parentcontract).call{value: msg.value}(abi.encodeWithSignature("triggerPayment(uint256)", index));
        require(success, "Transaction not successfull, cancelling...");
    }
}