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

import {IDiaData} from "../interfaces/IDiaData.sol";
import {IAggregatorInterface} from "../interfaces/IAggregatorInterface.sol";

/**
 * @title DiaDataAggregator
 * @notice Aggregator contract for fetching data from the DiaData oracle.
 * @dev Implements the `IAggregatorInterface` to provide standardized access to the DiaData oracle.
 */
contract DiaDataAggregator is IAggregatorInterface {
    /// @notice Address of the DiaData consumer contract.
    IDiaData public consumer;

    /// @notice Default key to fetch data from the DiaData oracle.
    string public immutable defaultKey;

    /**
     * @notice Constructor to initialize the DiaDataAggregator contract.
     * @param _consumer Address of the DiaData consumer contract.
     * @param _defaultKey Default key to fetch data from the oracle.
     */
    constructor(address _consumer, string memory _defaultKey) {
        consumer = IDiaData(_consumer);
        defaultKey = _defaultKey;
    }

    /**
     * @notice Returns the description of the aggregator.
     * @dev Provides a human-readable description of the aggregator's purpose.
     * @return string The description of the DiaDataAggregator.
     */
    function description() external pure returns (string memory) {
        return "DiaData Aggregator for fetching price from DIA Oracle";
    }

    /**
     * @notice Returns the number of decimals used by the aggregator.
     * @dev Overrides the `decimals` function of the `IAggregatorInterface`.
     * @return uint8 The number of decimals (fixed to 8).
     */
    function decimals() external pure override returns (uint8) {
        return 8;
    }

    /**
     * @notice Retrieves the latest answer from the DiaData oracle.
     * @dev Fetches the value corresponding to the `defaultKey` from the DiaData consumer.
     * @return int256 The latest answer as an integer.
     */
    function latestAnswer() external view override returns (int256) {
        (uint128 value, ) = consumer.getValue(defaultKey);
        return int256(uint256(value));
    }

    /**
     * @notice Retrieves the latest timestamp from the DiaData oracle.
     * @dev Fetches the timestamp corresponding to the `defaultKey` from the DiaData consumer.
     * @return uint256 The latest timestamp as a Unix epoch time.
     */
    function latestTimestamp() external view returns (uint256) {
        (, uint128 timestamp) = consumer.getValue(defaultKey);
        return uint256(timestamp);
    }
}
