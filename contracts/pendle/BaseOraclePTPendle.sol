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

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IStandardizedYield, IPMarket} from "@pendle/core-v2/contracts/interfaces/IPMarket.sol";
import {PendlePYOracleLib} from "@pendle/core-v2/contracts/oracles/PendlePYOracleLib.sol";

/// @title BaseOraclePTPendle
/// @author Zerolend
/// @notice Base oracle implementation for PT tokens on Pendle
abstract contract BaseOraclePTPendle {
    uint256 public constant BASE_18 = 1 ether;
    uint256 public constant YEAR = 365 days;

    uint256 public immutable maxLowerBound;
    uint256 public immutable maxUpperBound;

    /// @notice The duration of the TWAP used to calculate the PT price
    uint32 public immutable twapDuration;

    uint256 public immutable UNIT;

    IERC20 public immutable asset;
    IStandardizedYield public immutable sy;
    IPMarket public immutable market;
    uint256 public immutable maturity;

    bool public enableBalanceCheck;

    error TwapDurationTooLow();

    constructor(
        uint256 _maxLowerBound,
        uint256 _maxUpperBound,
        uint32 _twapDuration,
        uint256 _unit,
        address _market,
        bool _enableBalanceCheck
    ) {
        if (_twapDuration < 15 minutes) revert TwapDurationTooLow();
        maxLowerBound = _maxLowerBound;
        twapDuration = _twapDuration;
        maxUpperBound = _maxUpperBound;
        UNIT = _unit;

        enableBalanceCheck = _enableBalanceCheck;

        // read the market
        market = IPMarket(_market);
        (sy, , ) = market.readTokens();
        asset = IERC20(sy.yieldToken());
        maturity = market.expiry();
    }

    // invariant: the price is bound by the maxUpperBound and the economical lower bound
    function _getQuoteAmount() internal view virtual returns (uint256 quote) {
        (uint256 pendlePrice, ) = _pendlePTPrice(market, twapDuration);

        // set min-max limits
        pendlePrice = maxLowerBound < pendlePrice ? pendlePrice : maxLowerBound;
        pendlePrice = maxUpperBound > pendlePrice ? pendlePrice : maxUpperBound;

        quote = (_detectHackRatio() * pendlePrice) / UNIT;
    }

    /// @dev Depending on the market you should use
    ///       - getPtToSy() should be used if the underlying token is tradable,
    ///       - getPtToAsset() if not
    /// @dev https://docs.pendle.finance/Developers/Contracts/StandardizedYield#asset-of-sy--assetinfo-function
    function _pendlePTPrice(
        IPMarket _market,
        uint32 _twapDuration
    ) internal view virtual returns (uint256, uint256) {
        return (
            PendlePYOracleLib.getPtToAssetRate(_market, _twapDuration),
            UNIT
        );
    }

    function _detectHackRatio() internal view returns (uint256) {
        if (!enableBalanceCheck) return UNIT;
        uint256 assetBalanceSY = asset.balanceOf(address(sy));
        uint256 totalSupplySY = sy.totalSupply();
        return
            assetBalanceSY > totalSupplySY
                ? UNIT
                : (assetBalanceSY * UNIT) / totalSupplySY;
    }
}
