// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./RequestDataHelper.sol";
import "./Interfaces.sol";
import "./Utils.sol";

contract DEX is RequestDataHelper, Utils {
    constructor() {
        getMoreTokens(1000000);
    }

    // function initialize(address _tokenAddress, address _tokenDAIAddress)
    //     external
    // {
    //     tokenAddress = _tokenAddress;
    //     tokenDAIAddress = _tokenDAIAddress;
    // }

    address public customer = msg.sender;
    address public tokenAddress = 0x84B60e52D2C40c00061781f8b055494cA3Ae43Ca;
    address public tokenDAIAddress = 0xc7AD46e0b8a400Bb3C915120d284AafbA8fc4735;
    // address public aggregatorETHAddress =
    //     0x8A753747A1Fa494EC906cE90E9f37563A8AF630e;

    AggregatorV3Interface private aggregator =
        AggregatorV3Interface(0x2bA49Aaa16E6afD2a993473cfB70Fa8559B523cF);
    StudentsInterface private students =
        StudentsInterface(0x0E822C71e628b20a35F8bCAbe8c11F274246e64D);

    receive() external payable {
        buyByETH();
    }

    fallback() external payable {
        buyByETH();
    }

    // function getETHPrice() public view returns (uint256) {
    //     (, int256 _price) = AggregatorInterface(aggregatorETHAddress)
    //         .latestRoundData();
    //     return uint256(_price);
    // }

    function getDAIPrice() public view returns (uint256) {
        (, int256 _price, , , ) = aggregator.latestRoundData();
        return uint256(_price);
    }

    function getStudentsLength() public view returns (uint256) {
        string[] memory studentsList = students.getStudentsList();
        return studentsList.length;
    }

    function getBalanceValue() public view returns (uint256) {
        uint256 _balance = TokenInterface(tokenAddress).balanceOf(
            address(this)
        );
        return _balance;
    }

    function getMoreTokens(uint256 quantity) public {
        TokenInterface(tokenAddress).mintToken(quantity);
    }

    function withdrawAll() external onlyOwner {
        uint256 ethBalance = address(this).balance;
        if (ethBalance > 0) {
            payable(owner).transfer(ethBalance);
        }
    }

    function checkAllowance() public view returns (uint256) {
        uint256 _allowance = TokenInterface(tokenDAIAddress).allowance(
            customer,
            address(this)
        );
        return _allowance;
    }

    function buyByDAI(uint256 _daiAmount) public {
        require(randomResult != 0, "Wait please for getting random number");
        require(_daiAmount > 0, "You need to send some DAI first");

        uint256 _daiPrice = getDAIPrice();
        uint256 _decimalsAgg = aggregator.decimals();
        uint256 _tokensSend = (_daiPrice * _daiAmount) / (10**_decimalsAgg);

        uint256 _decimalsDAI = TokenInterface(tokenDAIAddress).decimals();

        require(
            _tokensSend <= getBalanceValue() / (10**_decimalsDAI),
            "Sorry, there is not enough tokens to buy"
        );

        uint256 _allowance = checkAllowance();
        require(
            _allowance >= _daiAmount * 10**_decimalsDAI,
            "You dont have allowance for this action, get permission first"
        );

        TokenInterface(tokenDAIAddress).transferFrom(
            customer,
            address(this),
            _daiAmount * 10**_decimalsDAI
        );
        TokenInterface(tokenAddress).transfer(
            customer,
            _useMuptiplier(_tokensSend * 10**_decimalsDAI)
        );
    }

    function buyByETH() public payable {
        if (TokenInterface(linkToken).balanceOf(address(this)) < fee * 2) {
            _refund(msg.sender, msg.value, "Not enough LINK token");
        }
        require(randomResult != 0, "Wait please for getting random number");
        require(ethPrice != 0, "Wait please for getting eth price");
        // uint256 _ethPrice = getETHPrice();

        uint256 _ethValue = msg.value;
        require(_ethValue > 0, "You need to send some Ether");

        uint256 _studentsLength = getStudentsLength();
        // uint256 _decimals = AggregatorInterface(aggregatorETHAddress)
        //     .decimals();
        uint256 _tokensSend = (ethPrice * _ethValue) / _studentsLength;

        require(
            _tokensSend <= getBalanceValue(),
            "Sorry, there is not enough tokens to buy"
        );

        TokenInterface(tokenAddress).transfer(
            customer,
            _useMuptiplier(_tokensSend)
        );
    }
}
