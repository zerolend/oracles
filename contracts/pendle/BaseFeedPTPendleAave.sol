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

interface IAaveOracle {
    function getAssetPrice(address asset) external view returns (uint256);
}

/// @title BaseFeedPtPendle
/// @author Zerolend
/// @notice Base Contract to implement the AggregatorV2V3Interface for Pendle PT tokens
abstract contract BaseFeedPTPendleAave is
    IAggregatorInterface,
    BaseOraclePTPendle
{
    /// @notice The address of the asset to USD aggregator
    IAaveOracle public oracle;

    /// @notice Constructor for an oracle following AggregatorV2V3Interface
    /// @param _maxImpliedRate The maximum implied rate for the underlying asset,
    /// if set well it allows to have a lower bound on the PT token price
    /// @param _twapDuration The duration of the TWAP used to calculate the PT price
    constructor(
        uint256 _maxImpliedRate,
        uint256 _maxUpperBound,
        uint32 _twapDuration,
        address _market,
        address _oracle,
        bool _enableBalanceCheck
    )
        BaseOraclePTPendle(
            _maxImpliedRate,
            _maxUpperBound,
            _twapDuration,
            _market,
            _enableBalanceCheck
        )
    {
        oracle = IAaveOracle(_oracle);
    }

    /// @inheritdoc IAggregatorInterface
    function decimals() external pure override returns (uint8) {
        return 8;
    }

    function rawPrice() external view returns (uint256) {
        return _getQuoteAmount();
    }

    function usdPrice() public view returns (uint256) {
        return oracle.getAssetPrice(address(asset));
    }

    /// @inheritdoc IAggregatorInterface
    /// @dev This function gives the latest answer in 8 decimals.
    function latestAnswer() external view returns (int256) {
        int256 value = int256(_getQuoteAmount());
        int256 assetToUsd = int256(usdPrice());
        return (value * assetToUsd) / int256(1e18);
    }
}
