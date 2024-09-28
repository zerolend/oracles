// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AerodromeVAMMOracle} from "../AerodromeVAMMOracle.sol";

contract AEROUSDCvAMMOracle is AerodromeVAMMOracle {
    constructor()
        AerodromeVAMMOracle(
            0x6cDcb1C4A4D1C3C6d054b27AC5B77e89eAFb971d, // USDC/AERO LP Pool
            0x7e860098F58bBFC8648a4311b374B1D669a2bc6B, // USDC Chainlink Feed
            0x4EC5970fC728C5f65ba413992CD5fF6FD70fcfF0, // AERO Chainlink Feed
            1e10
        )
    {
        // nothing
    }
}
