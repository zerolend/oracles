// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

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
