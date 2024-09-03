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
import {IPMarket} from "@pendle/core-v2/contracts/interfaces/IPMarket.sol";
import {PendlePYOracleLib} from "@pendle/core-v2/contracts/oracles/PendlePYOracleLib.sol";
import {UNIT, UD60x18, ud} from "@prb/math/src/UD60x18.sol";

/// @title BaseOraclePTPendle
/// @author Zerolend
/// @notice Base oracle implementation for PT tokens on Pendle
abstract contract BaseOraclePTPendle {
    uint256 public constant BASE_18 = 1 ether;
    uint256 public constant YEAR = 365 days;

    /// @notice The maximum implied rate for the underlying asset, if set well it allows to have a lower bound on the PT token price
    uint256 public immutable maxImpliedRate;

    uint256 public immutable maxUpperBound;

    /// @notice The duration of the TWAP used to calculate the PT price
    uint32 public immutable twapDuration;

    error TwapDurationTooLow();

    constructor(
        uint256 _maxImpliedRate,
        uint256 _maxUpperBound,
        uint32 _twapDuration
    ) {
        if (_twapDuration < 15 minutes) revert TwapDurationTooLow();
        maxImpliedRate = _maxImpliedRate;
        twapDuration = _twapDuration;
        maxUpperBound = _maxUpperBound;
    }

    // invariant: the price is bound by the maxUpperBound and the economical lower bound
    function _getQuoteAmount() internal view virtual returns (uint256 quote) {
        (uint256 pendlePrice, uint256 index) = _pendlePTPrice(
            IPMarket(market()),
            twapDuration
        );

        uint256 economicalLowerBound = (_economicalPTLowerBoundPrice() *
            BASE_18) / index;

        uint256 minPrice = economicalLowerBound > pendlePrice
            ? pendlePrice
            : economicalLowerBound;

        uint256 maxMinPrice = maxUpperBound > minPrice
            ? minPrice
            : maxUpperBound;

        quote = (_detectHackRatio() * maxMinPrice) / BASE_18;
    }

    function _economicalPTLowerBoundPrice()
        internal
        view
        returns (uint256 lowerBound)
    {
        uint256 exp = block.timestamp > maturity()
            ? 0
            : maturity() - block.timestamp;

        if (exp == 0) return BASE_18;

        UD60x18 denominator = UNIT.add(ud(maxImpliedRate)).pow(
            ud(exp).div(ud(YEAR))
        );

        lowerBound = UNIT.div(denominator).unwrap();
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
            BASE_18
        );
    }

    function _detectHackRatio() internal view returns (uint256) {
        uint256 assetBalanceSY = IERC20(asset()).balanceOf(sy());
        uint256 totalSupplySY = IERC20(sy()).totalSupply();
        return
            assetBalanceSY > totalSupplySY
                ? BASE_18
                : (assetBalanceSY * BASE_18) / totalSupplySY;
    }

    function asset() public pure virtual returns (address);

    function sy() public pure virtual returns (address);

    function maturity() public pure virtual returns (uint256);

    function market() public pure virtual returns (address);
}
