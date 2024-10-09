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

contract UniV3ChainlinkOracle is IAggregatorInterface {
    address public immutable pool;
    address public immutable token0;
    address public immutable token1;
    uint32 public constant TIME_WINDOW = 30 * 60; // 30 minutes in seconds
    uint32 public immutable timeWindow;
    uint8 public immutable decimals;
    uint8 public immutable decimalsUp;
    uint8 public immutable decimalsDown;

    constructor(
        address _pool,
        address _token0,
        address _token1,
        uint32 _timeWindow,
        uint8 _decimals,
        uint8 _decimalsUp,
        uint8 _decimalsDown
    ) {
        pool = _pool;
        token0 = _token0;
        token1 = _token1;
        timeWindow = _timeWindow;
        decimals = _decimals;
        decimalsUp = _decimalsUp;
        decimalsDown = _decimalsDown;
    }

    function getPrice() public view returns (uint256 answer) {
        // Fetch 30-minute TWAP from Uniswap V3
        uint32[] memory secondsAgos = new uint32[](2);
        secondsAgos[0] = TIME_WINDOW; // 30 minutes ago
        secondsAgos[1] = 0; // Current time

        (int56[] memory tickCumulatives, ) = IUniswapV3Pool(pool).observe(
            secondsAgos
        );

        // Calculate average tick during the time window
        int56 tickCumulativesDelta = tickCumulatives[1] - tickCumulatives[0];
        int56 averageTick = tickCumulativesDelta / int56(int32(TIME_WINDOW));

        // Convert tick to price
        uint256 price = OracleLibrary.getQuoteAtTick(
            int24(averageTick),
            1e18,
            token0,
            token1
        );

        answer = price;
    }

    /// @notice Gets the latest price of the liquidity pool token.
    function latestAnswer() public view returns (int256) {
        return
            (int256(getPrice()) * int256(10 ** decimalsUp)) /
            int256(10 ** decimalsDown);
    }
}
