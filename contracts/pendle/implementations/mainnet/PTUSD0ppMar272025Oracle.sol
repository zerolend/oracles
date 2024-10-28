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

/// @title PTUSD0ppMar272025Oracle
/// @author Zerolend.
/// @notice Gives the price of PT-USD0++ in ETH in base 8
contract PTUSD0ppMar272025Oracle is BaseFeedPTPendleAave {
    string public constant description = "PT-USD0++/USD Oracle Mar 27 2025";

    constructor()
        BaseFeedPTPendleAave(
            80e18 / 100, // lower bound is -20%  - 0.80
            105e18 / 100, // upper bound is +5%  - 1.05
            4 * 60 * 60, // 4hr min TWAP
            0xaFDC922d0059147486cC1F0f32e3A2354b0d35CC, // Pendle Market
            0x9a4BF8be3a363bd7fC50833c1C24e8076E2F762E, // ZeroLend RWA Market oracle
            true
        )
    {
        // nothing
    }
}
