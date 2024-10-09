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
import {IAerodromeVAMM} from "../interfaces/IAerodromeVAMM.sol";

abstract contract BaseAerodromeOracle {
    IAerodromeVAMM public immutable amm;
    IAggregatorInterface public immutable priceFeed0;
    IAggregatorInterface public immutable priceFeed1;

    address public immutable token0;
    address public immutable token1;

    uint256 internal constant HALF_UNIT = 1e9;
    uint256 internal constant UNIT = 1e18;

    /// @notice Constructor sets the address of the AMM contract.
    /// @param _amm The address of the AMM pool.
    constructor(address _amm, address _priceFeed0, address _priceFeed1) {
        amm = IAerodromeVAMM(_amm);
        priceFeed0 = IAggregatorInterface(_priceFeed0);
        priceFeed1 = IAggregatorInterface(_priceFeed1);
        token0 = amm.token0();
        token1 = amm.token1();
    }

    function getPrice() public view virtual returns (uint256 price);

    /// @notice Gets the latest price of the liquidity pool token.
    function latestAnswer() external view returns (int256) {
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
