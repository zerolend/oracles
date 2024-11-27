import { task } from "hardhat/config";
import { isAddress } from "ethers";

task(`deploy-api3`)
  .addParam("proxyaddress")
  .setAction(async ({ proxyaddress }, hre) => {
    if (!isAddress(proxyaddress)) throw new Error("invalid address");
    const [deployer] = await hre.ethers.getSigners();

    const args: [`0x${string}`] = [proxyaddress as `0x${string}`];

    const contract = await hre.deployments.deploy("Api3Aggregator", {
      from: deployer.address,
      args: args,
      skipIfAlreadyDeployed: true,
    });
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
