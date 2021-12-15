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
    function mintToken(uint256 quantity) external payable;
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

    function getBalance() public view returns (uint256) {
        address _tokenAddress = 0x84B60e52D2C40c00061781f8b055494cA3Ae43Ca;
        uint256 _balance = TokenInterface(_tokenAddress).balanceOf(address(_tokenAddress));
        return _balance;
    }

    function getToken(uint256 quantity) public payable {
        address _tokenAddress = 0x84B60e52D2C40c00061781f8b055494cA3Ae43Ca;
        TokenInterface(_tokenAddress).mintToken(quantity);
    }

    function buyByDAO() public payable {
        
    }

    function buyByETH() public payable {
        address _tokenAddress = 0x84B60e52D2C40c00061781f8b055494cA3Ae43Ca;
        address _customer = msg.sender;

        uint256 _studentsLength = getStudentsLength();

        uint256 _ethPrice = getEthPrice();
        uint256 _etherValue = msg.value;
        require(_etherValue  > 0, "You need to send some Ether");

        uint256 _decimals = AggregatorInterface(_aggregatorAddress).decimals();
        uint256 _tokensSend = (_ethPrice * _etherValue) / ((10 ** _decimals) * _studentsLength);

        require(_tokensSend <= getBalance(), "Sorry, there is not enough tokens to buy");

        TokenInterface(_tokenAddress).transfer(_customer, _tokensSend);
    }
}
