// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

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
