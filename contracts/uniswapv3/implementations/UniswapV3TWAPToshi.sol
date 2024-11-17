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
            0x71041dddad3595F9CEd3DcCFBe3D1F4b0a16Bb70 // _ethUsdConsumer
        )
    {
        // create a new UniswapV3TWAP consumer; for TOSHI/ETH
        UniswapV3TWAP toshiEthConsumer = new UniswapV3TWAP(
            0x4b0Aaf3EBb163dd45F663b38b6d93f6093EBC2d3, // _pool,
            4 * 60 * 60, // _timeWindow,
            8, // _decimals,
            0, // _decimalsUp,
            0 // _decimalsDown
        );

        mainConsumer = IConsumer(address(toshiEthConsumer));
    }
}
