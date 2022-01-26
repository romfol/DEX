// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Ownable {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender == owner) _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        if (newOwner != address(0)) owner = newOwner;
    }
}

contract Proxy is Ownable {
    address public tokenAddress = 0x84B60e52D2C40c00061781f8b055494cA3Ae43Ca;
    address public tokenDAIAddress = 0xc7AD46e0b8a400Bb3C915120d284AafbA8fc4735;

    address payable public implementation =
        payable(0x28EF96C39B4BE8474f4FCE679c60EF18862bf343);
    uint256 private version = 1;

    fallback() external payable {
        (bool sucess, bytes memory _result) = implementation.delegatecall(
            msg.data
        );
    }

    function changeImplementation(
        address payable _newImplementation,
        uint256 _newVersion
    ) public onlyOwner {
        require(
            _newVersion > version,
            "New version must be greater then previous"
        );
        implementation = _newImplementation;
    }

    uint256[10] private _gap;
}
