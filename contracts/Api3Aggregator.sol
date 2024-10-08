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

import "./interfaces/IApi3ProxyConsumer.sol";

contract Api3Aggregator {
    IApi3ProxyConsumer marketApiProxy;
    error InvalidOraclePrice();

    constructor(IApi3ProxyConsumer _marketApiProxy) {
        marketApiProxy = _marketApiProxy;
    }

    function latestAnswer() external view returns (int256 uniEthToUsdPrice) {
        (uniEthToUsdPrice, ) = marketApiProxy.read();
    }
}
