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
import {IERC4626} from "@openzeppelin/contracts/interfaces/IERC4626.sol";

/**
 * @title DiaDataAggregator
 * @notice Aggregates data from the DiaData oracle and provides price and timestamp information.
 * @dev Implements the `IAggregatorInterface` for standardized access to DiaData oracle values.
 */
contract DiaDataAggregator is IAggregatorInterface {
    /// @notice Address of the DiaData consumer contract.
    IDiaData public consumer;

    /// @notice ERC4626 vault contract for asset management.
    IERC4626 public vault;

    /// @notice Default key used to query data from the DiaData oracle.
    string public defaultKey;

    /**
     * @notice Constructor to initialize the aggregator contract.
     * @param _consumer Address of the DiaData consumer contract.
     * @param _vault Address of the ERC4626-compliant vault contract.
     * @param _defaultKey Key used for fetching data from the DiaData oracle.
     */
    constructor(address _consumer, address _vault, string memory _defaultKey) {
        consumer = IDiaData(_consumer);
        vault = IERC4626(_vault);
        defaultKey = _defaultKey;
    }

    /**
     * @notice Provides a description of the aggregator.
     * @dev Returns a human-readable description of the contract's purpose.
     * @return string Description of the DiaDataAggregator.
     */
    function description() external pure returns (string memory) {
        return "DiaData Aggregator for fetching price from DIA Oracle";
    }

    /**
     * @notice Gets the number of decimals used by the oracle.
     * @dev Overrides the `decimals` function from the `IAggregatorInterface`.
     * @return uint8 Number of decimals (fixed at 8).
     */
    function decimals() external pure override returns (uint8) {
        return 8;
    }

    /**
     * @notice Fetches the latest price from the DiaData oracle.
     * @dev Retrieves the value associated with `defaultKey` from the consumer contract.
     * @return int256 Latest price value.
     */
    function latestAnswer() external view override returns (int256) {
        (uint128 value, ) = consumer.getValue(defaultKey);
        return int256(uint256(value));
    }

    /**
     * @notice Fetches the latest timestamp from the DiaData oracle.
     * @dev Retrieves the timestamp associated with `defaultKey` from the consumer contract.
     * @return uint256 Timestamp in Unix epoch format.
     */
    function latestTimestamp() external view returns (uint256) {
        (, uint128 timestamp) = consumer.getValue(defaultKey);
        return uint256(timestamp);
    }

    /**
     * @notice Calculates the price of the vault based on its exchange rate and oracle price.
     * @dev Combines the vault's total assets and total supply with the latest oracle price.
     * @return int256 Vault price in USD (8 decimals).
     */
    function getVaultPrice() external view returns (int256) {
        uint256 exchangeRate = (vault.totalAssets() * 1e18 / vault.totalSupply());
        int256 price = this.latestAnswer();
        return (price * int256(exchangeRate)) / 1e8;
    }
}
