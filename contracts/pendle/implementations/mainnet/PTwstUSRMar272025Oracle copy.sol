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

// /// @title PTwstUSRMar272025Oracle
// /// @author Zerolend.
// /// @notice Gives the price of PT-eBTC in ETH in base 8
// contract PTwstUSRMar272025Oracle is BaseFeedPTPendle {
//     string public constant description = "PT-wstUSR/USD Oracle Mar 27 2025";

//     /// @notice Constructor for an oracle following BaseFeedPTPendle
//     constructor()
//         BaseFeedPTPendle(
//             65e18 / 100, // lower bound is -35%  - 0.75
//             100e18 / 100, // upper bound is +0%  - 1.00
//             4 * 60 * 60, // uint32 _twapDuration,
//             // todo, // address _assetUsdAggregator,
//             0x353d0B2EFB5B3a7987fB06D30Ad6160522d08426, // address _market,
//             true // bool _enableBalanceCheck
//         )
//     {
//         // nothing
//     }
// }
