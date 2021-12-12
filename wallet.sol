// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol" as erc20;

contract Wallet {
    address public immutable owner;
    
    uint comissionValue = 0;
    address payable constant comissionReceiver = payable(0x1a8EbD82Bd6e481A00552F55E41c78850e95DB9E);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function getBalance() onlyOwner public view returns(uint) {
        return address(this).balance;
    }
    
    // Ether transfering methods
    // Tasks:
    // Возможность принимать/отправлять ETH +
    // Комиссия отправляется вместе с переводом +
     
    function sendEth(address payable to, uint amount) onlyOwner public {
        require(address(this).balance >= amount + comissionValue, "Insufficient amount available");

        // Main transfer
        bool ethSent = to.send(amount);
        require(ethSent, "Failed to send Ether");
        // Comission sending
        bool comissionSent = comissionReceiver.send(comissionValue);
        require(comissionSent, "Failed to send comission");
    }
    
    receive() external payable {}

    fallback() external payable {}

    // Comission methods
    // Tasks:
    // Возможность менять значение комиссии +

    function getComissionValue() onlyOwner public view returns(uint) {
        return comissionValue;
    }

    function setComissionValue(uint _comissionValue) onlyOwner public {
        comissionValue = _comissionValue;
    }

    // Token using functions
    // Tasks:
    // Возможность принимать/отправлять токены +
    // Возможность делать allowance +

    function transferToken(address token, address recipient, uint256 numTokens) onlyOwner public {
        erc20.IERC20 tokenInterface = erc20.IERC20(token);

        bool result = tokenInterface.transfer(recipient, numTokens);
        require(result, "Failed to transfer Token");   
    }

    function approveToken(address token, address delegate, uint256 numTokens) onlyOwner public {
        erc20.IERC20 tokenInterface = erc20.IERC20(token);
        bool result = tokenInterface.approve(delegate, numTokens);

        require(result, "Failed to approve Token");
    }
}
