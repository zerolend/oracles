// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IAlgebraV2Twap{
    /**
     * @notice Estimate the output amount of a trade
     * @param tokenIn The address of the input token
     * @param amountIn The amount of the input token
     * @param secondsAgo The number of seconds ago to start the TWAP
     * @return amountOut The estimated output amount
     */
    function estimateAmountOut(
        address tokenIn,
        address tokenOut,
        uint128 amountIn,
        uint32 secondsAgo
    ) external view returns (uint amountOut);

}