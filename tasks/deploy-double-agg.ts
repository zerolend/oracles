import { task } from "hardhat/config";
import { isAddress } from "ethers";
import { pythContracts } from "../utils/pyth";

task(`deploy-double-agg`)
  .addParam("core")
  .addParam("base")
  .setAction(async ({ core, base }, hre) => {
    const pythContract = pythContracts[hre.network.name] as `0x${string}`;
    if (!isAddress(pythContract)) throw new Error("invalid address");

    const args: [`0x${string}`, `0x${string}`] = [core, base];

    const [deployer] = await hre.ethers.getSigners();
    console.log("i am", deployer.address);
    console.log("args", args);
    const contract = await hre.ethers.deployContract("EthUsdAggregator", args);

    await contract.waitForDeployment();
    console.log(`deployed to`, contract.target);

    // verify contract for tesnet & mainnet
    if (process.env.NODE_ENV != "test") {
      // Verify contract programmatically
      await hre.run("verify:verify", {
        address: contract.target,
        constructorArguments: args,
      });
    } else {
      console.log(`Contract not verified, deployed locally.`);
    }
  });
