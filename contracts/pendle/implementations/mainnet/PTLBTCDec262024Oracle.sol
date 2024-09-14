// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.12;

import "../../BaseFeedPTPendleAave.sol";

/// @title PTLBTCDec262024Oracle
/// @author Zerolend.
/// @notice Gives the price of PT-LBTC in ETH in base 8
contract PTLBTCDec262024Oracle is BaseFeedPTPendleAave {
    string public constant description = "PT-LBTC/USD Oracle Dec 26 2024";

    constructor()
        BaseFeedPTPendleAave(
            85e18 / 100, // lower bound is -15%  - 0.85
            105e18 / 100, // upper bound is +5%  - 1.05
            30 * 60, // 20 min TWAP
            0xCaE62858DB831272A03768f5844cbe1B40bB381f, // Pendle Market
            0xad19a55354614913B373E01da768ab679ac4DA41, // ZeroLend BTC Market oracle
            1e18,
            false
        )
    {
        // nothing
    }
}
