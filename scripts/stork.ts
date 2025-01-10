import { utils, Wallet } from "zksync-ethers";
import { Deployer } from "@matterlabs/hardhat-zksync-deploy";
import * as hre from "hardhat";
import * as dotenv from 'dotenv';
dotenv.config();

async function main() {
  const wallet = new Wallet(process.env.WALLET_PRIVATE_KEY as string);
  const deployer = new Deployer(hre, wallet);
  const artifact = await deployer.loadArtifact("StorkChainlinkAdapter");

  const params = utils.getPaymasterParams(
    "0x98546B226dbbA8230cf620635a1e4ab01F6A99B2", // Paymaster address
    {
      type: "General",
      innerInput: new Uint8Array(),
    }
  );

  const constructorArguments = [
    "0x6a2ab154d7c5Ba9fdea6d8A0C79818A4463a63f9",
    "0xd65a36e7a8a4f4a927fb944cbf9e44df705a5ce4a6e5d635b01022d48fd32b81"
  ];

  const contract = await deployer.deploy(
    artifact,
    constructorArguments,
    "create",
    {
      customData: {
        paymasterParams: params,
        gasPerPubdata: utils.DEFAULT_GAS_PER_PUBDATA_LIMIT,
      },
    }
  );

  console.log(`StorkChainlinkAdapter deployed to: ${contract.address}`);

  // Verify the contract
  await hre.run("verify:verify", {
    address: contract.address,
    constructorArguments: constructorArguments,
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});