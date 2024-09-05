// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.12;

import "../../BaseFeedPTPendleAave.sol";

/// @title PTeBTCDec262024Oracle
/// @author Zerolend.
/// @notice Gives the price of PT-eBTC in ETH in base 8
contract PTeBTCDec262024Oracle is BaseFeedPTPendleAave {
    string public constant description = "PT-eBTC/USD Oracle";

    constructor()
        BaseFeedPTPendleAave(
            85e18 / 100, // lower bound is -15%  - 0.85
            105e18 / 100, // upper bound is +5%  - 1.05
            6 * 60 * 60, // 6hr TWAP
            0xad19a55354614913B373E01da768ab679ac4DA41 // ZeroLend BTC Market oracle
        )
    {}

    function asset() public pure override returns (address) {
        return 0x657e8C867D8B37dCC18fA4Caead9C45EB088C642;
    }

    function sy() public pure override returns (address) {
        return 0x7aCDF2012aAC69D70B86677FE91eb66e08961880;
    }

    function maturity() public pure override returns (uint256) {
        return 1735171200;
    }

    function market() public pure override returns (address) {
        return 0x36d3ca43ae7939645C306E26603ce16e39A89192;
    }
}
