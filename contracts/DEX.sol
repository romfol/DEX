// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

interface StudentsInterface {
    function getStudentsList() external view returns (string[] memory);
}

interface TokenInterface {
    function balanceOf(address _account) external view returns (uint256);

    function decimals() external view returns (uint8);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function mintToken(uint256 quantity) external payable;

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

interface AggregatorInterface {
    function latestRoundData()
        external
        view
        returns (uint80 roundId, int256 answer);

    function decimals() external view returns (uint8);
}

contract DEX is VRFConsumerBase, ChainlinkClient {
    constructor() VRFConsumerBase(vrfCoordinator, linkToken) {
        setPublicChainlinkToken();
        getMoreTokens(1000000);
    }

    using Chainlink for Chainlink.Request;

    // function initialize(address _tokenAddress, address _tokenDAIAddress)
    //     external
    // {
    //     tokenAddress = _tokenAddress;
    //     tokenDAIAddress = _tokenDAIAddress;
    // }
    address private linkToken = 0x01BE23585060835E02B77ef475b0Cc51aA1e0709;
    address private vrfCoordinator = 0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B;
    bytes32 private keyHash =
        0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
    uint256 public randomResult;

    address private oracle = 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8;
    bytes32 private jobId = "6b88e0402e5d415eb946e528b8e0c7ba";
    uint256 public volume;

    uint256 private fee = 0.1 * 10**18;

    address public customer = msg.sender;
    address public tokenAddress = 0x84B60e52D2C40c00061781f8b055494cA3Ae43Ca;
    address public tokenDAIAddress = 0xc7AD46e0b8a400Bb3C915120d284AafbA8fc4735;
    address public studentsAddress = 0x0E822C71e628b20a35F8bCAbe8c11F274246e64D;
    address public aggregatorETHAddress =
        0x8A753747A1Fa494EC906cE90E9f37563A8AF630e;
    address public aggregatorDAIAddress =
        0x2bA49Aaa16E6afD2a993473cfB70Fa8559B523cF;

    function requestVolumeData() public returns (bytes32 requestId) {
        Chainlink.Request memory request = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfill.selector
        );
        request.add(
            "get",
            "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=ETH&tsyms=USD"
        );
        request.add("path", "RAW.ETH.USD.VOLUME24HOUR");
        int256 timesAmount = 10**18;
        request.addInt("times", timesAmount);

        return sendChainlinkRequestTo(oracle, request, fee);
    }

    function fulfill(bytes32 _requestId, uint256 _volume)
        public
        recordChainlinkFulfillment(_requestId)
    {
        volume = _volume;
    }

    function getRandomNumber() public returns (bytes32 requestId) {
        require(
            LINK.balanceOf(address(this)) >= fee,
            "Not enough LINK - fill contract with faucet"
        );
        return requestRandomness(keyHash, fee);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness)
        internal
        override
    {
        randomResult = randomness;
    }

    function useMuptiplier(uint256 number) public view returns (uint256) {
        uint8 offset = 5;
        uint256 numberRange = (randomResult % 30) + offset;
        if (numberRange > 30) numberRange = numberRange - offset;
        return (number * numberRange) / 10;
    }

    function getETHPrice() public view returns (uint256) {
        (, int256 _price) = AggregatorInterface(aggregatorETHAddress)
            .latestRoundData();
        return uint256(_price);
    }

    function getDAIPrice() public view returns (uint256) {
        (, int256 _price) = AggregatorInterface(aggregatorDAIAddress)
            .latestRoundData();
        return uint256(_price);
    }

    function getStudentsLength() public view returns (uint256) {
        string[] memory studentsList = StudentsInterface(studentsAddress)
            .getStudentsList();
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

    function checkAllowance() public view returns (uint256) {
        uint256 _allowance = TokenInterface(tokenDAIAddress).allowance(
            customer,
            address(this)
        );
        return _allowance;
    }

    function buyByDAI(uint256 _daiAmount) public {
        require(randomResult != 0, "Wait please for indexation and try again");
        require(_daiAmount > 0, "You need to send some DAI first");

        uint256 _daiPrice = getDAIPrice();
        uint256 _decimalsAgg = AggregatorInterface(aggregatorDAIAddress)
            .decimals();
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
            useMuptiplier(_tokensSend * 10**_decimalsDAI)
        );
    }

    function buyByETH() public payable {
        require(randomResult != 0, "Wait please for indexation and try again");

        uint256 _ethPrice = getETHPrice();
        uint256 _ethValue = msg.value;
        require(_ethValue > 0, "You need to send some Ether");

        uint256 _studentsLength = getStudentsLength();
        uint256 _decimals = AggregatorInterface(aggregatorETHAddress)
            .decimals();
        uint256 _tokensSend = (_ethPrice * _ethValue) /
            ((10**_decimals) * _studentsLength);

        require(
            _tokensSend <= getBalanceValue(),
            "Sorry, there is not enough tokens to buy"
        );

        TokenInterface(tokenAddress).transfer(
            customer,
            useMuptiplier(_tokensSend)
        );
    }
}
