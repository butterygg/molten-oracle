// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.7.6;

import "forge-std/Script.sol";

import "../contracts/UniswapV3OracleConsulter.sol";

contract Storage {
    event Consulted(uint256 value);
    uint256 public value;

    constructor() {
        value = 1;
    }

    function setValue(uint256 newValue) public {
        value = newValue;
        emit Consulted(value);
    }
}

contract ConsultOracle is Script {
    uint256 internal value;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // ERC20s
        address mainnetDai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
        address mainnetWETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
        address mainnetAave = 0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9;

        // Pools
        address mainnetDaiWETHPool = 0xC2e9F25Be6257c210d7Adf0D4Cd6E3E881ba25f8;
        address mainnetAaveWETHPool = 0x5aB53EE1d50eeF2C1DD3d5402789cd27bB52c1bB;

        address[] memory tokenAddressRoute = new address[](3);
        tokenAddressRoute[0] = mainnetDai;
        tokenAddressRoute[1] = mainnetWETH;
        tokenAddressRoute[2] = mainnetAave;

        address[] memory poolRoute = new address[](2);
        poolRoute[0] = mainnetDaiWETHPool;
        poolRoute[1] = mainnetAaveWETHPool;

        value = UniswapV3OracleConsulter.consult(
            poolRoute,
            tokenAddressRoute,
            14400,
            1 ether
        );

        Storage _storage = new Storage();
        _storage.setValue(value);
    }
}
