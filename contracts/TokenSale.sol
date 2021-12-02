//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.10;

import "hardhat/console.sol";

interface AggregatorInterface {
    function latestRoundData() external view returns (uint80 roundId, int256 answer);
    function decimals() external view returns (uint8);
}

interface StudentsInterface {
    function getStudentsList() external view returns (string[] memory);
}

interface TokenInterface {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address _account) external view returns (uint256);
}

contract TokenSale {
    address private _aggregatorAddress = 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e;  

    function getEthPrice() public view returns (uint256) {
        (,int256 _price) = AggregatorInterface(_aggregatorAddress).latestRoundData();
        return uint(_price);
    }

    function getStudentsLength () public view returns (uint256) {
        address _studentsAddress = 0x0E822C71e628b20a35F8bCAbe8c11F274246e64D;
        string[] memory studentsList = StudentsInterface(_studentsAddress).getStudentsList();
        return studentsList.length;
    }

    function buyToken() public payable {
        address _tokenAddress = 0x23DC68258197f646A8F8d6F4ded04CE9f08B73C7;
        address _customer = msg.sender;
        uint256 _balance = TokenInterface(_tokenAddress).balanceOf(address(_tokenAddress));

        uint256 _studentsLength = getStudentsLength();

        uint256 _ethPrice = getEthPrice();
        uint256 _etherValue = msg.value;
        uint256 _decimals = AggregatorInterface(_aggregatorAddress).decimals();
        uint256 _tokenPrice = (_ethPrice * _etherValue) / (10 ** _decimals * _studentsLength);

        if (_balance < _tokenPrice) {
            (bool sent, bytes memory data) = _customer.call{value: _etherValue}("Sorry, there is not enough tokens to buy");
            return;
        }

        TokenInterface(_tokenAddress).transfer(_customer, _tokenPrice);
    }
}
