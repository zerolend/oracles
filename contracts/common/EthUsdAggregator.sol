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

interface IConsumer {
    function latestTimestamp() external view returns (uint256);

    function latestAnswer() external view returns (int256);
}

contract EthUsdAggregator {
    IConsumer public mainConsumer;
    IConsumer public ethUsdConsumer;

    constructor(address _mainConsumer, address _ethUsdConsumer) {
        mainConsumer = IConsumer(_mainConsumer);
        ethUsdConsumer = IConsumer(_ethUsdConsumer);
    }

    function decimals() public view virtual returns (uint8) {
        return 8;
    }

    function description() public pure returns (string memory) {
        return "A aggregator that combines two chainlink oracles";
    }

    function version() public pure returns (uint256) {
        return 1;
    }

    function latestAnswer() public view virtual returns (int256) {
        return
            (mainConsumer.latestAnswer() * ethUsdConsumer.latestAnswer()) / 1e8;
    }

    function latestTimestamp() public view returns (uint256) {
        return mainConsumer.latestTimestamp();
    }

    function latestRound() public view returns (uint256) {
        // use timestamp as the round id
        return latestTimestamp();
    }

    function getAnswer(uint256) public view returns (int256) {
        return latestAnswer();
    }

    function getTimestamp(uint256) external view returns (uint256) {
        return latestTimestamp();
    }

    function getRoundData(
        uint80 _roundId
    )
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {
        // todo implement round data of both oracles properly
        return (
            _roundId,
            latestAnswer(),
            latestTimestamp(),
            latestTimestamp(),
            _roundId
        );
    }

    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {
        return (
            roundId,
            latestAnswer(),
            latestTimestamp(),
            latestTimestamp(),
            roundId
        );
    }
}
