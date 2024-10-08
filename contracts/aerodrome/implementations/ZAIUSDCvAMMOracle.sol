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

import {AerodromeVAMMOracle} from "../AerodromeVAMMOracle.sol";

contract ZAIUSDCvAMMOracle is AerodromeVAMMOracle {
    constructor()
        AerodromeVAMMOracle(
            0x72d509aFF75753aAaD6A10d3EB98f2DBC58C480D, // USDz/USDC LP Pool
            0x78Ad3d53045b6582841e2a1a688C52Be2CA2A7a7, // USDz Fixed Price Feed
            0x7e860098F58bBFC8648a4311b374B1D669a2bc6B, // USDC Chainlink Feed
            1e10
        )
    {
        // nothing
    }
}
