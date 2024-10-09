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

import {TickMath} from "./TickMath.sol";

library OracleLibrary {
    function getQuoteAtTick(
        int24 tick,
        uint128 baseAmount,
        address baseToken,
        address quoteToken
    ) internal pure returns (uint256 quoteAmount) {
        uint160 sqrtRatioX96 = TickMath.getSqrtRatioAtTick(tick);
        if (baseToken < quoteToken) {
            quoteAmount =
                (uint256(baseAmount) *
                    uint256(sqrtRatioX96) *
                    uint256(sqrtRatioX96)) >>
                (96 * 2);
        } else {
            quoteAmount =
                uint256(baseAmount) <<
                ((96 * 2) / uint256(sqrtRatioX96) / uint256(sqrtRatioX96));
        }
    }
}
