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

contract PTcbETHMay292024Oracle is BaseFeedPTPendleAave {
    string public constant description = "PT-cbETH/USD Oracle May 29 2025";

    constructor()
        BaseFeedPTPendleAave(
            90e18 / 100, // lower bound is -10%  - 0.85
            100e18 / 100, // upper bound is +0%  - 1.00
            30 * 60, // 30 min TWAP
            0x483f2e223c58a5eF19c4B32fbC6dE57709749cb3, // Pendle Market
            0xF49Ee3EA9C56D90627881d88004aaBDFc44Fd82c, // ZeroLend BTC Market oracle
            true
        )
    {
        // nothing
    }
}
