// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IUniswapV3OracleConsulter {
    function consult(
        address,
        uint32,
        uint128,
        address,
        address
    ) external view returns (uint256);

    function consult(
        address[] calldata,
        address[] calldata,
        uint32,
        uint128
    ) external view returns (uint256);
}
