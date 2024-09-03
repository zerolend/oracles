// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.12;

import "../../BaseFeedPTPendle.sol";

/// @title MorphoFeedPTUSDe
/// @author Zerolend.
/// @notice Gives the price of PT-rsETH in ETH in base 8
contract PTrsETHSept262024Oracle is BaseFeedPTPendle {
    string public constant description = "PT-rsETH/USD Oracle";

    /// @notice Constructor for an oracle following BaseFeedPTPendle
    constructor()
        BaseFeedPTPendle(
            80e18 / 100, // lower bound is 80%  - 0.8
            105e18 / 100, // upper bound is 5%  - 1.05
            30 * 60,
            0x33B13F46a25D836CC0ce91B370305902aB6CF1Be // rsETH/USD oracle
        )
    {}

    function asset() public pure override returns (address) {
        return 0xA1290d69c65A6Fe4DF752f95823fae25cB99e5A7;
    }

    function sy() public pure override returns (address) {
        return 0x730A5E2AcEbccAA5e9095723B3CB862739DA793c;
    }

    function maturity() public pure override returns (uint256) {
        return 1727308800;
    }

    function market() public pure override returns (address) {
        return 0x6b4740722e46048874d84306B2877600ABCea3Ae;
    }
}
