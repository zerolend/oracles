// SPDX-License-Identifier: GPL-3.0

// ███████╗███████╗██████╗  ██████╗
// ╚══███╔╝██╔════╝██╔══██╗██╔═══██╗
//   ███╔╝ █████╗  ██████╔╝██║   ██║
//  ███╔╝  ██╔══╝  ██╔══██╗██║   ██║
// ███████╗███████╗██║  ██║╚██████╔╝
// ╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝

// Website: https://zerolend.xyz
// Discord: https://discord.gg/zerolend
// Twitter: https://twitter.com/zerolendxyz

pragma solidity ^0.8.12;

import {IStorkTemporalNumericValueUnsafeGetter, IStorkChainlinkAdapter} from "../interfaces/IStork.sol";

/**
 * @title A port of the ChainlinkAggregatorV3 interface that supports Stork price feeds
 */
contract StorkChainlinkAdapter is IStorkChainlinkAdapter {
    string public description;
    bytes32 public priceId;
    IStorkTemporalNumericValueUnsafeGetter public stork;
    constructor(address _stork, bytes32 _priceId, string memory _description) {
        priceId = _priceId;
        stork = IStorkTemporalNumericValueUnsafeGetter(_stork);
        description = _description;
    }

    function decimals() external pure returns (uint8) {
        return 8;
    }
    function version() public pure returns (uint256) {
        return 1;
    }

    function latestAnswer() public view virtual returns (int256) {
        return
            stork.getTemporalNumericValueUnsafeV1(priceId).quantizedValue / 1e10;
    }

    function latestTimestamp() public view returns (uint256) {
        return
            stork.getTemporalNumericValueUnsafeV1(priceId).timestampNs / 1e10;
    }

    function latestRound() public view returns (uint256) {
        // use timestamp as the round id
        return latestTimestamp();
    }

    function getAnswer(uint256) public view returns (int256) {
        return latestAnswer();
    }

    function getTimestamp(uint256) external view returns (uint256) {
        return latestTimestamp();
    }

    /*
     * @notice This is exactly the same as `latestRoundData`, just including for parity with Chainlink
     * Stork doesn't store roundId on chain so there's no way to access old data by round id
     */
    function getRoundData(
        uint80 _roundId
    )
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {
        IStorkTemporalNumericValueUnsafeGetter.TemporalNumericValue
            memory value = stork.getTemporalNumericValueUnsafeV1(priceId);
        return (
            _roundId,
            value.quantizedValue / 1e10,
            value.timestampNs / 1e10,
            value.timestampNs / 1e10,
            _roundId
        );
    }

    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {
        IStorkTemporalNumericValueUnsafeGetter.TemporalNumericValue
            memory value = stork.getTemporalNumericValueUnsafeV1(priceId);
        roundId = uint80(value.timestampNs);
        return (
            roundId,
            value.quantizedValue / 1e10,
            value.timestampNs / 1e10,
            value.timestampNs / 1e10,
            roundId
        );
    }
}
