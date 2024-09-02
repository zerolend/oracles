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

import {IAggregatorInterface} from "../interfaces/IAggregatorInterface.sol";

import {BaseOraclePTPendle} from "./BaseOraclePTPendle.sol";

/// @title BaseFeedPtPendle
/// @author Zerolend
/// @notice Base Contract to implement the AggregatorV2V3Interface for Pendle PT tokens
abstract contract BaseFeedPTPendle is IAggregatorInterface, BaseOraclePTPendle {
    /// @notice The Chainlink aggregator for ASSET/USD
    IAggregatorInterface public assetUsdAggregator;

    /// @notice Constructor for an oracle following AggregatorV2V3Interface
    /// @param _maxImpliedRate The maximum implied rate for the underlying asset,
    /// if set well it allows to have a lower bound on the PT token price
    /// @param _twapDuration The duration of the TWAP used to calculate the PT price
    constructor(
        uint256 _maxImpliedRate,
        uint32 _twapDuration,
        address _assetUsdAggregator
    ) BaseOraclePTPendle(_maxImpliedRate, _twapDuration) {
        assetUsdAggregator = IAggregatorInterface(_assetUsdAggregator);
    }

    /// @inheritdoc IAggregatorInterface
    function decimals() external pure override returns (uint8) {
        return 8;
    }

    /// @inheritdoc IAggregatorInterface
    /// @dev This function gives the latest answer in 8 decimals.
    function latestAnswer() external view returns (int256) {
        int256 value = int256(_getQuoteAmount());
        int256 assetToUsd = assetUsdAggregator.latestAnswer();
        return (value * assetToUsd) / int256(BASE_18);
    }
}
