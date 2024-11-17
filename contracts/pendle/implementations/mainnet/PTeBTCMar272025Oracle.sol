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

/// @title PTeBTCMar272025Oracle
/// @author Zerolend.
/// @notice Gives the price of PT-eBTC in ETH in base 8
contract PTeBTCMar272025Oracle is BaseFeedPTPendleAave {
    string public constant description = "PT-eBTC/USD Oracle Mar 27 2025";

    constructor()
        BaseFeedPTPendleAave(
            85e18 / 100, // lower bound is -15%  - 0.85
            100e18 / 100, // upper bound is +0%  - 1.00
            4 * 30 * 60, // 4hr TWAP
            0x2C71Ead7ac9AE53D05F8664e77031d4F9ebA064B, // Pendle Market
            0xad19a55354614913B373E01da768ab679ac4DA41, // ZeroLend BTC Market oracle
            false
        )
    {
        // nothing
    }
}
