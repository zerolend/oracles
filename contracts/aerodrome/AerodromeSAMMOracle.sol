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
import {IAggregatorInterface} from "../interfaces/IAggregatorInterface.sol";
import {BaseAerodromeOracle} from "./BaseAerodromeOracle.sol";

/// @title AerodromeSAMMOracle
/// @notice This contract provides a price oracle for the liquidity pool tokens in a AMM.
/// @dev This contract interacts with the IAerodromeVAMM interface to fetch reserves and calculate prices.
/// @dev Reference from https://github.com/AlphaFinanceLab/alpha-homora-v2-contract/blob/master/contracts/oracle/UniswapV2Oracle.sol
contract AerodromeSAMMOracle is BaseAerodromeOracle {
    constructor(
        address _amm,
        address _priceFeed0,
        address _priceFeed1
    ) BaseAerodromeOracle(_amm, _priceFeed0, _priceFeed1) {
        require(amm.stable(), "AerodromeSAMMOracle: AMM is not stable");
    }

    /// @notice Gets the price of the liquidity pool token.
    /// @dev This function fetches reserves from the AMM and uses a pre-defined price for tokens to calculate the LP token price.
    /// @return price The price of the liquidity pool token.
    function getPrice() public view override returns (uint256 price) {
        (uint256 r0, uint256 r1, ) = amm.getReserves();
        uint256 totalSupply = amm.totalSupply();

        uint256 px0 = getPx(priceFeed0, token0); // in 1e18
        uint256 px1 = getPx(priceFeed1, token1); // in 1e8

        require(px0 > 0 && px1 > 0, "Invalid Price");

        // fair token0 amt: sqrtK * sqrt(px1/px0)
        // fair token1 amt: sqrtK * sqrt(px0/px1)
        // fair lp price = 2 * sqrt(px0 * px1)
        // split into 2 sqrts multiplication to prevent uint overflow (note the 1e18)
        uint256 sqrtK_2 = fdiv(sqrt(r0 * r1), totalSupply) * 2; // in 1e18
        // uint256 numerator = ((sqrt(px0) / TWO_56) * sqrt(px1)) / TWO_56;

        return (((sqrtK_2 * sqrt(px0)) / HALF_UNIT) * sqrt(px1)) / HALF_UNIT;
    }
}
