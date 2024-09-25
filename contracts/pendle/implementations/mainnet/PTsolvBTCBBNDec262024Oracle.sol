// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.12;

import "../../BaseFeedPTPendleAave.sol";

/// @title PTeBTCDec262024Oracle
/// @author Zerolend.
/// @notice Gives the price of PT-eBTC in ETH in base 8
contract PTsolvBTCBBNDec262024Oracle is BaseFeedPTPendleAave {
    string public constant description =
        "PT-solvBTC.BBN/USD Oracle Dec 26 2024";

    constructor()
        BaseFeedPTPendleAave(
            85e18 / 100, // lower bound is -15%  - 0.85
            105e18 / 100, // upper bound is +5%  - 1.05
            4 * 60 * 60, // 4 hr TWAP
            0xEb4d3057738b9Ed930F451Be473C1CCC42988384, // Pendle Market
            0xad19a55354614913B373E01da768ab679ac4DA41, // ZeroLend BTC Market oracle
            false
        )
    {
        // nothing
    }
}
