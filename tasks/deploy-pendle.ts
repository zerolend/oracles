import { task } from "hardhat/config";

task(`deploy-pendle`)
  .addParam("id")
  .setAction(async ({ id }, hre) => {
    const [deployer] = await hre.ethers.getSigners();

    console.log("deploying", id, deployer.address);
    const contract = await hre.deployments.deploy(id, {
      from: deployer.address,
      args: [],
      skipIfAlreadyDeployed: true,
    });
    console.log(`deployed to`, contract.address);

    if (hre.network.name !== "hardhat") {
      // Verify contract programmatically
      await hre.run("verify:verify", {
        address: contract.address,
        constructorArguments: [],
      });
    }
  });