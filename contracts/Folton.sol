// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Folton is ERC20 {
    constructor() ERC20("Folton", "FTN") {
        _mint(address(this), 1000000 * 10**decimals());
    }

    function mintToken(uint256 quantity) public payable {
        _mint(msg.sender, quantity * 10**decimals());
    }

    receive() external payable {}
}
