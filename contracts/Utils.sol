// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./RequestDataHelper.sol";

contract Utils is RequestDataHelper {
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

    function _useMuptiplier(uint256 number) internal view returns (uint256) {
        uint8 offset = 5;
        uint256 numberRange = (randomResult % 26) + offset;
        return (number * numberRange) / 10;
    }

    function _refund(
        address _to,
        uint256 _amount,
        bytes memory _msg
    ) internal {
        bool sent;
        if (msg.value > 0) {
            (sent, ) = payable(_to).call{value: _amount}(_msg);
        } else {
            (sent, ) = payable(_to).call(_msg);
        }
        require(sent, "Refunding error");
    }
}
