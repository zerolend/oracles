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

/// @title PTLBTCMar272025Oracle
/// @author Zerolend.
/// @notice Gives the price of PT-LBTC in ETH in base 8
contract PTLBTCMar272025Oracle is BaseFeedPTPendleAave {
    string public constant description = "PT-LBTC/USD Oracle Mar 27 2025";

    constructor()
        BaseFeedPTPendleAave(
            85e18 / 100, // lower bound is -15%  - 0.85
            100e18 / 100, // upper bound is +0%  - 1.00
            4 * 30 * 60, // 4hr TWAP
            0x70B70Ac0445C3eF04E314DFdA6caafd825428221, // Pendle Market
            0xad19a55354614913B373E01da768ab679ac4DA41, // ZeroLend BTC Market oracle
            true
        )
    {
        // nothing
    }
}
