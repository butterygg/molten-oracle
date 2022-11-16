# 🔎 Molten Oracle

Oracle Consulter Libraries for retrieving a Time Weighted Average Price [`exchange`](https://github.com/butterymoney/molten#exchange) rate required for the Molten funding process.

## Oracle Consulter

The Oracle Consulter queries Uniswap V3's pool data, then the it processes this data to get the Time Weighted Average Price of the `token0` in a pool in terms of `token1`. In the case of Molten, it provides a TWAP price of a DAO's token in terms of a given quote token.

In other words, Uniswap V3 pools also acts as Oracles that provide price data to the Molten Oracle Consulter.

Check out [Uniswap V3's docs](https://docs.uniswap.org/protocol/concepts/V3-overview/oracle) to learn more about this process.

### Oracle Consulter Contract

The consulter is able to query the price of a given token (`token0`) in terms of a quote token (`token1`) even if liquidity for this pair is not deployed on Uniswap v3.

For example, as long as there is liquidity for [WETH](https://etherscan.io/token/0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2) pair for each token, it is possible to get a TWAP price for `token0` in terms of `token1` by following a path where WETH is the intermediary.

The consulter queries Uniswap's oracles when `consult` is called with (a) given pool address(s) and tokens addresses.

There are two functions that can be called to get a TWAP price for a pair via the Oracle Consulter:

#### Pairs w/ liquidity on Uni V3

```solidity
function consult(
        address pool,  // token0/token1 pool address
        uint32 period,  // TWAP period
        uint128 baseAmount,  // token0 token input
        address baseToken,  // token0
        address quoteToken  // token1
    )
```

#### Pairs w/o liquidity on Uni V3

```solidity
function consult(
        address[] calldata pools,
        address[] calldata tokens,
        uint32 period,
        uint128 baseAmount
    )
```

Where `tokens` defines the path for the conversion of tokens. For example, we can define this argument for DAI/AAVE like this:

```solidity
address daiAddress = 0xDaiAddress;
address wethAddress = 0xWethAddress;
address aaveAddress = 0xAaveAddress;

address[] memory tokenAddressRoute = new address[](3);
tokenAddressRoute[0] = daiAddress;
tokenAddressRoute[1] = wethAddress;
tokenAddressRoute[2] = aaveAddress;
```

`pools` therefore defines the pools for these tokens as pairs against WETH, defined as pairs:

```solidity
address daiWETHPool = 0xdaiWethPoolAddress;
address aaveWETHPool = 0xaaveWethPoolAddress;

address[] memory poolRoute = new address[](2);
poolRoute[0] = daiWETHPool;
poolRoute[1] = aaveWETHPool;
```

**Note**: WETH does not have to be the intermediary token. DAI itself, for example, could be the intermediary in your case.

### Deploying the Oracle Consulter

Ensure that you have set your `PRIVATE_KEY` in your local `.env` file to the private key of the network you'd like to deploy on.

Set the `MAINNET_RPC_URL` variable with the rpc url for Ethereum mainnet within your `.env` as well.

Then, you deploy the Oracle Consulter library:

```bash
source .env
forge create --rpc-url $MAINNET_RPC_URL --private-key $PRIVATE_KEY contracts/UniswapV3OracleConsulter.sol:UniswapV3OracleConsulter
```

If you'd like to utlise the deployed consulter into your contract, you'd need to link the deployed library when you deploy your contract.

To do this with Foundry, you can use the `--libraries <path to lib>:<library name>:<address>` [flag](https://book.getfoundry.sh/reference/forge/forge-script#linker-options) for `forge create`, but I recommend you to add it to your `foundry.toml` instead:

```toml
[profile.default]
# ...

libraries = ['<path to lib>:<library name>:<address>']
```
