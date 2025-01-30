// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.20;

interface IOracle {
    /**
     * @notice Returns the latest round data
     * @return roundId The ID of the round
     * @return answer The latest answer (value)
     * @return startedAt The timestamp when the round started
     * @return updatedAt The timestamp when the answer was last updated
     * @return answeredInRound The round ID in which the answer was computed
     */
    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );
}

/// @title SpectraChainlinkOracleV2
/// @author ZeroLend
/// @notice ZeroLend oracle using Chainlink-compliant feeds.
contract PTUSROracle  {

    IOracle public ptUSRUSRoracle;
    IOracle public usrUSDOracle;

    constructor(IOracle _ptUSRUSRoracle, IOracle _usrUSDOracle) {
        ptUSRUSRoracle = _ptUSRUSRoracle;
        usrUSDOracle = _usrUSDOracle;
    }


    function description() external pure returns (string memory) {
        return "PT wstUSR/USD oracle";
    }

    /// @dev This function gives the latest answer in 8 decimals.
    function latestAnswer() external view returns (int256) {
        (, int256 priceScaled,,,) = ptUSRUSRoracle.latestRoundData(); // 18 decimals
        (, int256 usrUSDCPrice,,,) = usrUSDOracle.latestRoundData(); // 1e8

        // Since the price is scaled by 1e18, we divide by 1e18 to scale it down to 1e8
        return (priceScaled * usrUSDCPrice) / 1e18;
    }
}