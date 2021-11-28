//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.10;

import "hardhat/console.sol";

contract TokenSale {
    string private greeting;

    constructor(string memory _greeting) {
        console.log("Deploying a Greeter with greeting:", _greeting);
        greeting = _greeting;
    }

    function greet() public view returns (string memory) {
        return greeting;
    }

    function greetHey() public pure returns (string memory) {
        return "HEY";
    }

    function setGreeting(string memory _greeting) public {
        console.log("Changing greeting from '%s' to '%s'", greeting, _greeting);
        greeting = _greeting;
    }
}
