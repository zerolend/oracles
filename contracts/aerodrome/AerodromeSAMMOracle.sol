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

import {IERC20Metadata} from "@openzeppelin/contracts/interfaces/IERC20Metadata.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";
import {IAggregatorInterface} from "../interfaces/IAggregatorInterface.sol";
import {IAerodromeVAMM} from "../interfaces/IAerodromeVAMM.sol";

/// @title AerodromeSAMMOracle
/// @notice This contract provides a price oracle for the liquidity pool tokens in a AMM.
/// @dev This contract interacts with the IAerodromeVAMM interface to fetch reserves and calculate prices.
/// @dev Reference from https://github.com/AlphaFinanceLab/alpha-homora-v2-contract/blob/master/contracts/oracle/UniswapV2Oracle.sol
contract AerodromeSAMMOracle {
    // todo
}
