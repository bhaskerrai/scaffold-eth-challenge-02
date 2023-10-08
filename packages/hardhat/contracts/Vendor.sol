pragma solidity >=0.8.0 <0.9.0;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import './YourToken.sol';

contract Vendor is Ownable {

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(address seller, uint256 amountOfTokens, uint256 amountOfETH);

  YourToken public yourToken;

  uint256 public constant tokensPerEth = 100;

  constructor(address tokenAddress) public {
    yourToken = YourToken(tokenAddress);
  }

  // ToDo: create a payable buyTokens() function:

  function buyTokens() payable public{

    uint256 tokens = msg.value * tokensPerEth;

    yourToken.transfer(msg.sender, tokens);

    emit BuyTokens(msg.sender, msg.value , tokens);
    
  }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH
  function withdraw() public onlyOwner {
    (bool sent, ) = payable(owner()).call{value: address(this).balance}("");
    require(sent, "Failed to send Ether");
  }

  // ToDo: create a sellTokens() function:
  function sellTokens(uint256 amount) public {

    yourToken.transferFrom(msg.sender, address(this), amount);

    uint256 money = amount / tokensPerEth;

    (bool sent, ) = payable(msg.sender).call{value: money }("");
    require(sent, "Failed to send Ether");

    emit SellTokens(msg.sender, amount, money);

  }
}
