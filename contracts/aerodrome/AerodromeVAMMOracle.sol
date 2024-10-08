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

/// @title Aerodrome_vAMM_Oracle
/// @notice This contract provides a price oracle for the liquidity pool tokens in a AMM.
/// @dev This contract interacts with the IAerodromeVAMM interface to fetch reserves and calculate prices.
/// @dev Reference from https://github.com/AlphaFinanceLab/alpha-homora-v2-contract/blob/master/contracts/oracle/UniswapV2Oracle.sol
contract AerodromeVAMMOracle {
    using Math for uint256;

    IAerodromeVAMM public immutable amm;
    IAggregatorInterface public immutable priceFeed0;
    IAggregatorInterface public immutable priceFeed1;
    uint256 public immutable offset;

    address public immutable token0;
    address public immutable token1;

    // uint256 private constant TWO_56 = 2 ** 56;
    // uint256 private constant TWO_112 = 2 ** 112;
    uint256 private constant HALF_UNIT = 1e9;
    uint256 private constant UNIT = 1e18;

    /// @notice Constructor sets the address of the AMM contract.
    /// @param _amm The address of the AMM pool.
    constructor(
        address _amm,
        address _priceFeed0,
        address _priceFeed1,
        uint256 _offset
    ) {
        amm = IAerodromeVAMM(_amm);
        priceFeed0 = IAggregatorInterface(_priceFeed0);
        priceFeed1 = IAggregatorInterface(_priceFeed1);
        offset = _offset;

        token0 = amm.token0();
        token1 = amm.token1();
    }

    /// @notice Gets the price of the liquidity pool token.
    /// @dev This function fetches reserves from the AMM and uses a pre-defined price for tokens to calculate the LP token price.
    /// @return price The price of the liquidity pool token.
    function getPrice() public view returns (uint256 price) {
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

    /// @notice Gets the latest price of the liquidity pool token.
    function latestAnswer() public view returns (int256) {
        return int256(getPrice());
    }

    /// @notice Computes the square root of a given number using the Babylonian method.
    /// @dev This function uses an iterative method to compute the square root of a number.
    /// @param x The number to compute the square root of.
    /// @return y The square root of the given number.
    function sqrt(uint256 x) public pure returns (uint256 y) {
        if (x == 0) return 0; // Handle the edge case for 0
        uint256 z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }

    function fdiv(uint256 lhs, uint256 rhs) internal pure returns (uint256) {
        return (lhs * UNIT) / rhs;
    }

    function getPx(
        IAggregatorInterface oracle,
        address token
    ) public view returns (uint256) {
        uint8 decimals = IERC20Metadata(token).decimals();
        int256 answer = oracle.latestAnswer();
        return (uint256(answer) * UNIT) / (10 ** decimals);
    }
}
