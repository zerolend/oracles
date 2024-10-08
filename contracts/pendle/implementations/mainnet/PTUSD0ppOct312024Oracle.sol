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

/// @title PTUSD0ppOct312024Oracle
/// @author Zerolend.
/// @notice Gives the price of PT-USD0++ in ETH in base 8
contract PTUSD0ppOct312024Oracle is BaseFeedPTPendleAave {
    string public constant description = "PT-USD0++/USD Oracle Oct 31 2024";

    constructor()
        BaseFeedPTPendleAave(
            85e18 / 100, // lower bound is -15%  - 0.85
            105e18 / 100, // upper bound is +5%  - 1.05
            4 * 60 * 60, // 4hr min TWAP
            0x00b321D89A8C36B3929f20B7955080baeD706D1B, // Pendle Market
            0x9a4BF8be3a363bd7fC50833c1C24e8076E2F762E, // ZeroLend RWA Market oracle
            true
        )
    {
        // nothing
    }
}
