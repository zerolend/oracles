// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.12;

import "../../BaseFeedPTPendle.sol";

/// @title PTUSDeDec262024Oracle
/// @author Zerolend.
/// @notice Gives the price of PT-USDe in ETH in base 8
contract PTUSDeDec262024Oracle is BaseFeedPTPendle {
    string public constant description = "PT-USDe/USD Oracle Dec 26 2024";

    /// @notice Constructor for an oracle following BaseFeedPTPendle
    /// @param _maxImpliedRate The maximum implied rate for the underlying asset,
    /// if set well it allows to have a lower bound on the PT token price
    /// @param _twapDuration The duration of the TWAP used to calculate the PT price
    constructor(
        uint256 _maxImpliedRate,
        uint32 _twapDuration,
        address _ethUsdAggregator
    )
        BaseFeedPTPendle(
            _maxImpliedRate,
            1e18,
            _twapDuration,
            _ethUsdAggregator,
            0xa0ab94DeBB3cC9A7eA77f3205ba4AB23276feD08,
            true
        )
    {
        // nothing
    }
}
