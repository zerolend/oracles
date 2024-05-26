import { task } from "hardhat/config";
import { isAddress } from "ethers/lib/utils";

task(`deploy-api3-eth`)
  .addParam("proxyaddress")
  .addParam("ethconsumeraddress")
  .setAction(async ({ proxyaddress, ethconsumeraddress }, hre) => {
    if (!isAddress(proxyaddress)) throw new Error("invalid address");
    if (!isAddress(ethconsumeraddress)) throw new Error("invalid address");

    const args: [`0x${string}`, `0x${string}`] = [
      proxyaddress as `0x${string}`,
      ethconsumeraddress as `0x${string}`,
    ];

    const contract = await hre.viem.deployContract("Api3AggregatorETH", args);
    console.log(`deployed to`, contract.address);

    // (await hre.viem.getPublicClient()).wa({ hash: contract.})

    // verify contract for tesnet & mainnet
    if (process.env.NODE_ENV != "test") {
      // Verify contract programmatically
      await hre.run("verify:verify", {
        address: contract.address,
        constructorArguments: args,
      });
    } else {
      console.log(`Contract not verified, deployed locally.`);
    }
  });
