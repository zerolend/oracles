// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.12;

import "../../BaseFeedPTPendle.sol";

/// @title MorphoFeedPTUSDe
/// @author Zerolend.
/// @notice Gives the price of PT-USDe in ETH in base 8
contract MorphoFeedPTUSDeDec26 is BaseFeedPTPendle {
    string public constant description = "PT-USDe/USD Oracle";

    /// @notice Constructor for an oracle following BaseFeedPTPendle
    /// @param _maxImpliedRate The maximum implied rate for the underlying asset,
    /// if set well it allows to have a lower bound on the PT token price
    /// @param _twapDuration The duration of the TWAP used to calculate the PT price
    constructor(
        uint256 _maxImpliedRate,
        uint32 _twapDuration,
        address _ethUsdAggregator
    ) BaseFeedPTPendle(_maxImpliedRate, _twapDuration, _ethUsdAggregator) {}

    function asset() public pure override returns (address) {
        return 0x9D39A5DE30e57443BfF2A8307A4256c8797A3497;
    }

    function sy() public pure override returns (address) {
        return 0xD288755556c235afFfb6316702719C32bD8706e8;
    }

    function maturity() public pure override returns (uint256) {
        return 1735171200;
    }

    function market() public pure override returns (address) {
        return 0xa0ab94DeBB3cC9A7eA77f3205ba4AB23276feD08;
    }
}
