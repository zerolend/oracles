import { isAddress } from "ethers";
import { task } from "hardhat/config";

task(`deploy-dia-data`)
  .addParam("consumeraddress")
  .addParam("defaultKey")
  .setAction(async ({ consumeraddress, defaultKey }, hre) => {
    if (!isAddress(consumeraddress)) throw new Error("invalid address");
    if (defaultKey.length === "") throw new Error("invalid key");
    const { deployments } = hre;
    const [deployer] = await hre.ethers.getSigners();
    const contract = await deployments.deploy("DiaDataAggregator", {
      from: deployer.address,
      args: [consumeraddress, defaultKey],
      skipIfAlreadyDeployed: true,
    });
    console.log(`deployed to`, contract.address);

    if (process.env.NODE_ENV != "test") {
      await hre.run("verify:verify", {
        address: contract.address,
        constructorArguments: [consumeraddress, defaultKey],
      });
    }else console.log(`Contract not verified, deployed locally.`);
  });
