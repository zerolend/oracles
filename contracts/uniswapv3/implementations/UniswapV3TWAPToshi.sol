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

import {UniswapV3TWAP} from "../UniswapV3TWAP.sol";
import {IConsumer, EthUsdAggregator} from "../../common/EthUsdAggregator.sol";

contract UniswapV3TWAPToshi is EthUsdAggregator {
    constructor()
        EthUsdAggregator(
            0x0000000000000000000000000000000000000000, // _mainConsumer, - left as 0x0 for now
            0x0000000000000000000000000000000000000000 // _ethUsdConsumer
        )
    {
        // create a new UniswapV3TWAP consumer; for TOSHI/ETH
        UniswapV3TWAP toshiEthConsumer = new UniswapV3TWAP(
            0x0000000000000000000000000000000000000000, // _pool,
            0, // _timeWindow,
            0, // _decimals,
            0, // _decimalsUp,
            0 // _decimalsDown
        );

        mainConsumer = IConsumer(address(toshiEthConsumer));
    }
}
