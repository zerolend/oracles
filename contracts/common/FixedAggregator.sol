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

contract FixedAggregator {
    int256 private _latestAnswer;

    constructor(int256 initialAnswer) {
        _latestAnswer = initialAnswer;
    }

    function latestAnswer() external view returns (int256) {
        return _latestAnswer;
    }

    function getTokenType() external pure returns (uint256) {
        return 1;
    }

    function decimals() external pure returns (uint8) {
        return 8;
    }
}
