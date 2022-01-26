// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract RequestDataHelper is VRFConsumerBase, ChainlinkClient {
    constructor() VRFConsumerBase(vrfCoordinator, linkToken) {
        setPublicChainlinkToken();
    }

    using Chainlink for Chainlink.Request;

    address internal linkToken = 0x01BE23585060835E02B77ef475b0Cc51aA1e0709;
    address private vrfCoordinator = 0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B;
    bytes32 private keyHash =
        0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
    address private oracle = 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8;
    bytes32 private jobId = "6b88e0402e5d415eb946e528b8e0c7ba";
    uint256 internal fee = 0.1 * 10**18;

    uint256 public randomResult;
    uint256 public ethPrice;

    function requestPriceData() public returns (bytes32 requestId) {
        Chainlink.Request memory request = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfill.selector
        );
        request.add(
            "get",
            "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=ETH&tsyms=USD"
        );
        request.add("path", "RAW.ETH.USD.PRICE");
        return sendChainlinkRequestTo(oracle, request, fee);
    }

    function fulfill(bytes32 _requestId, uint256 _price)
        public
        recordChainlinkFulfillment(_requestId)
    {
        ethPrice = _price;
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
}
