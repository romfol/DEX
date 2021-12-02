// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor() ERC20("Folton", "FTN") {
        _mint(address(this), 1000000 * 10 ** decimals());
    }
}