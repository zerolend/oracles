// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IAlgebraV2Twap} from "./interfaces/IAlgebraV2Twap.sol";
import {IAggregatorInterface} from "./interfaces/IAggregatorInterface.sol";

contract TwapOracleAggregator {
    /**
     * @notice Stores address of the token1.
     */
    address public immutable TOKEN1;

    /**
     * @notice Stores address of the token2.
     */
    address public immutable TOKEN2;

    /**
     * @notice Stores address of the twap oracle contract.
     */
    IAlgebraV2Twap public immutable TWAP_ORACLE;

    /**
     * @notice Stores address of the token2 chainlink feed address.
     */
    IAggregatorInterface public immutable TOKEN2_CHAINLINK_FEED;

    /**
     * @notice Error thrown when price is negative.
     */
    error InvalidOraclePrice();

    /**
     *
     * @notice Constructor for TwapOracleAggregator.
     * @param twapOracleAddress Address of the twapOracle.
     * @param token2ChainlinkFeedAddress Address of the token2 feed.
     * @param token1Address Address of the token1.
     * @param token2Address Address of the token2.
     */
    constructor(
        IAlgebraV2Twap twapOracleAddress,
        IAggregatorInterface token2ChainlinkFeedAddress,
        address token1Address,
        address token2Address
    ) {
        TWAP_ORACLE = IAlgebraV2Twap(twapOracleAddress);
        TOKEN2_CHAINLINK_FEED = IAggregatorInterface(
            token2ChainlinkFeedAddress
        );
        TOKEN1 = token1Address;
        TOKEN2 = token2Address;
    }

    /**
     * @notice This function returns the decimals of the feed
     * @return Decimals of the feed
     */
    function decimals() public view virtual returns (uint8) {
        return 8;
    }

    /**
     * @notice This function returns the price of the token1.
     * @return token1Price Price of token1.
     */
    function latestAnswer() external view returns (uint256 token1Price) {
        uint8 decimals = ERC20(TOKEN1).decimals();
        uint256 token1Amount = 1000000 * (10 ** decimals);
        uint256 token2Amount = TWAP_ORACLE.estimateAmountOut(
            TOKEN1,
            TOKEN2,
            uint128(token1Amount),
            3600
        );

        int256 token2Price = TOKEN2_CHAINLINK_FEED.latestAnswer();

        if (token2Price < 0) revert InvalidOraclePrice();

        token1Price = (uint256(token2Price) * token2Amount) / (token1Amount);
    }
}
