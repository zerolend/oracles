// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

pragma solidity ^0.8.12;

interface IAerodromeVAMM {
    function getReserves()
        external
        view
        returns (
            uint256 _reserve0,
            uint256 _reserve1,
            uint256 _blockTimestampLast
        );

    function totalSupply() external view returns (uint256);

    function token0() external view returns (address);

    function token1() external view returns (address);
}
