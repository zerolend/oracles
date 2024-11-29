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

import "../../BaseFeedPTPendleAave.sol";

/// @title PTUSDeMar272025Oracle
/// @author Zerolend.
/// @notice Gives the price of PT-USDe in ETH in base 8
contract PTUSDeMar272025Oracle is BaseFeedPTPendleAave {
    string public constant description = "PT-USDe/USD Oracle Mar 27 2025";

    constructor()
        BaseFeedPTPendleAave(
            75e18 / 100, // lower bound is -25%  - 0.75
            100e18 / 100, // upper bound is +0%  - 1.00
            4 * 30 * 60, // 4hr TWAP
            0xB451A36c8B6b2EAc77AD0737BA732818143A0E25, // Pendle Market
            0x9a4BF8be3a363bd7fC50833c1C24e8076E2F762E, // ZeroLend USD Market oracle
            true
        )
    {
        // nothing
    }
}
