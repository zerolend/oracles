import { task } from "hardhat/config";
import { isAddress } from "ethers/lib/utils";

task(`deploy-api3`)
  .addParam("proxyaddress")
  .setAction(async ({ proxyaddress }, hre) => {
    if (!isAddress(proxyaddress)) throw new Error("invalid address");

    const args: [`0x${string}`] = [proxyaddress as `0x${string}`];

    const contract = await hre.viem.deployContract("Api3Aggregator", args);
    console.log(`deployed to`, contract.address);

    // verify contract for tesnet & mainnet
    // Verify contract programmatically
    if (process.env.NODE_ENV != "test") {
      await hre.run("verify:verify", {
        address: contract.address,
        constructorArguments: args,
      });
    } else console.log(`Contract not verified, deployed locally.`);
  });
