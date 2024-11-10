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

/// @title PTezETHDec262024Oracle
/// @author Zerolend.
/// @notice Gives the price of PT-ezETH in ETH in base 8
contract PTezETHDec262024Oracle is BaseFeedPTPendleAave {
    string public constant description = "PT-ezETH/USD Oracle Dec 26 2024";

    constructor()
        BaseFeedPTPendleAave(
            85e18 / 100, // lower bound is -15%  - 0.85
            105e18 / 100, // upper bound is +5%  - 1.05
            30 * 60, // 30 min TWAP
            0xD8F12bCDE578c653014F27379a6114F67F0e445f, // Pendle Market
            0x1cc993f2C8b6FbC43a9bafd2A44398E739733385, // ZeroLend ETH Market oracle
            true
        )
    {
        // nothing
    }
}
