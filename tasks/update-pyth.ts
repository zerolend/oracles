import { task } from "hardhat/config";
import { isAddress } from "ethers/lib/utils";
import { pythContracts } from "../utils/pyth";
import { EvmPriceServiceConnection } from "@pythnetwork/pyth-evm-js";

task(`update-pyth`)
  .addParam("priceid")
  .setAction(async ({ priceid }, hre) => {
    const pythContract = pythContracts[hre.network.name] as `0x${string}`;
    if (!isAddress(pythContract)) throw new Error("invalid address");

    const contract = await hre.viem.getContractAt(
      "PythAggregatorV3",
      "0xfc8734ebf4a56a7a6a47ad6d44f1330fd26307a8"
    );

    const updateData: [`0x${string}`] = [priceid];

    const connection = new EvmPriceServiceConnection(
      "https://hermes.pyth.network"
    ); // See Hermes endpoints section below for other endpoints

    const priceUpdateData = (await connection.getPriceFeedsUpdateData(
      updateData
    )) as any;

    const tx = await contract.write.updateFeeds([priceUpdateData], {
      value: 1000000000n,
    });

    console.log(`tx`, tx);
  });
