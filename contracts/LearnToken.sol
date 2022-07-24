// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LearnToken is ERC20, Ownable {
  // Initial price of one Learn Token
  uint256 public constant tokenPrice = 0.0001 ether;

  // Needs to be represented as 10 * (10 ** 18) as ERC20 tokens are represented by the smallest denomination possible for the token
  // the max total supply is 1,000,000 for Crypto Dev Tokens
  uint256 public constant maxTotalSupply = 1000000 * 10**18;

  constructor() ERC20("Learn Token", "LEARN") {}

  /**
   * @dev Mints `amount` number of Learn Tokens
   * Requirements:
   * - `msg.value` should be equal or greater than the tokenPrice * amount
   */
  function mint(uint256 amount) public payable {
    uint256 _requiredAmount = tokenPrice * amount;
    require(msg.value >= _requiredAmount, "Ether sent is incorrect");

    uint256 amountWithDecimals = amount * 10**18; // (10 ** 18) denominated
    require(
      (totalSupply() + amountWithDecimals) <= maxTotalSupply,
      "Exceeds the max total supply available."
    );

    // call the internal function from Openzeppelin's ERC20 contract
    _mint(msg.sender, amountWithDecimals);
  }

  /**
   * @dev withdraws all ETH and tokens sent to the contract
   * Requirements:
   * wallet connected must be owner's address
   */
  function withdraw() public onlyOwner {
    address _owner = owner();
    uint256 amount = address(this).balance;
    (bool sent, ) = _owner.call{value: amount}("");
    require(sent, "Failed to send Ether");
  }

  // Function to receive Ether. msg.data must be empty
  receive() external payable {}

  // Fallback function is called when msg.data is not empty
  fallback() external payable {}
}
