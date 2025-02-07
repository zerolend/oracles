import { task } from "hardhat/config";
import { isAddress } from "ethers";
import { pythContracts } from "../utils/pyth";
import { EvmPriceServiceConnection } from "@pythnetwork/pyth-evm-js";

task(`update-pyth`)
  .addParam("priceid")
  .setAction(async ({ priceid }, hre) => {
    const pythContract = pythContracts[hre.network.name] as `0x${string}`;
    if (!isAddress(pythContract)) throw new Error("invalid address");

    const contract = await hre.ethers.getContractAt(
      "PythAggregatorV3",
      "0xd04a2e318e4557bb81344ea485b63d0d55732a37"
    );

    const updateData: [`0x${string}`] = [priceid];

    const connection = new EvmPriceServiceConnection(
      "https://hermes.pyth.network"
    ); // See Hermes endpoints section below for other endpoints

    const priceUpdateData = (await connection.getPriceFeedsUpdateData(
      updateData
    )) as any;

    const tx = await contract.updateFeeds(priceUpdateData, {
      value: 1000000000n,
    });

    console.log(`tx`, tx);
  });
