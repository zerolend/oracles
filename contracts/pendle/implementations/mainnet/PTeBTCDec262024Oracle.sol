// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.12;

import "../../BaseFeedPTPendleAave.sol";

/// @title PTeBTCDec262024Oracle
/// @author Zerolend.
/// @notice Gives the price of PT-eBTC in ETH in base 8
contract PTeBTCDec262024Oracle is BaseFeedPTPendleAave {
    string public constant description = "PT-eBTC/USD Oracle Dec 26 2024";

    constructor()
        BaseFeedPTPendleAave(
            85e18 / 100, // lower bound is -15%  - 0.85
            105e18 / 100, // upper bound is +5%  - 1.05
            30 * 60, // 30 min TWAP
            0x36d3ca43ae7939645C306E26603ce16e39A89192, // Pendle Market
            0xad19a55354614913B373E01da768ab679ac4DA41, // ZeroLend BTC Market oracle
            true
        )
    {
        // nothing
    }
}
