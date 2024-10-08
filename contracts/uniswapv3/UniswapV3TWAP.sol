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

import {IUniswapV3Pool} from "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import {IAggregatorInterface} from "../interfaces/IAggregatorInterface.sol";
import {OracleLibrary} from "./libraries/OracleLibrary.sol";

/// @notice UniswapV3TWAP is a contract that calculates the TWAP of an asset priced by a Uniswap V3 pool.
contract UniswapV3TWAP is IAggregatorInterface {
    IUniswapV3Pool public immutable pool;
    address public immutable token0;
    address public immutable token1;
    uint32 public immutable timeWindow;
    uint8 public immutable decimals;
    uint8 public immutable decimalsUp;
    uint8 public immutable decimalsDown;

    /// @param _pool The address of the Uniswap V3 pool.
    /// @param _timeWindow The time window in seconds (the TWAP counter).
    /// @param _decimals The number of decimals in the price.
    /// @param _decimalsUp The number of decimals to move the price up.
    /// @param _decimalsDown The number of decimals to move the price down.
    constructor(
        address _pool,
        uint32 _timeWindow, // Time window in seconds (the TWAP counter)
        uint8 _decimals,
        uint8 _decimalsUp,
        uint8 _decimalsDown
    ) {
        pool = IUniswapV3Pool(_pool);
        token0 = pool.token0();
        token1 = pool.token1();
        timeWindow = _timeWindow;
        decimals = _decimals;
        decimalsUp = _decimalsUp;
        decimalsDown = _decimalsDown;
    }

    function getPrice() public view returns (uint256 answer) {
        // Fetch 30-minute TWAP from Uniswap V3
        uint32[] memory secondsAgos = new uint32[](2);
        secondsAgos[0] = timeWindow;
        secondsAgos[1] = 0; // Current time

        (int56[] memory tickCumulatives, ) = pool.observe(secondsAgos);

        // Calculate average tick during the time window
        int56 tickCumulativesDelta = tickCumulatives[1] - tickCumulatives[0];
        int56 averageTick = tickCumulativesDelta / int56(int32(timeWindow));

        // Convert tick to price
        uint256 price = OracleLibrary.getQuoteAtTick(
            int24(averageTick),
            1e18, // baseAmount
            token0,
            token1
        );

        answer = price;
    }

    /// @notice Gets the latest price of the liquidity pool token.
    function latestAnswer() public view returns (int256) {
        return
            int256(((getPrice() * (10 ** decimalsUp)) / (10 ** decimalsDown)));
    }
}
