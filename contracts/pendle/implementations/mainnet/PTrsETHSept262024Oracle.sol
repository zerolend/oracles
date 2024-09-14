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

import "../../BaseFeedPTPendle.sol";

/// @title PTrsETHSept262024Oracle
/// @author Zerolend.
/// @notice Gives the price of PT-rsETH in ETH in base 8
contract PTrsETHSept262024Oracle is BaseFeedPTPendle {
    string public constant description = "PT-rsETH/USD Oracle Sept 26 2024";

    /// @notice Constructor for an oracle following BaseFeedPTPendle
    constructor()
        BaseFeedPTPendle(
            85e18 / 100, // lower bound is -15%  - 0.85
            105e18 / 100, // upper bound is +5%  - 1.05
            30 * 60, // 30 min TWAP
            0x33B13F46a25D836CC0ce91B370305902aB6CF1Be, // rsETH/USD oracle
            0x6b4740722e46048874d84306B2877600ABCea3Ae, // Pendle Market
            true
        )
    {
        // nothing
    }
}
