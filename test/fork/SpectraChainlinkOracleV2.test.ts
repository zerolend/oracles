import { ethers } from "hardhat";
import { expect } from "chai";
import { BaseContract, ContractTransactionResponse, Contract } from "ethers";

describe("PTUSROracle Fork Test", function () {

  let ptUSROracle: BaseContract & {
    deploymentTransaction(): ContractTransactionResponse;
  } & Omit<Contract, keyof BaseContract>;

  beforeEach(async function () {
    // Get signers
    const Spectra_PTUSR_USR_ORACLE = "0x0ba73080A12f5F0b0b37C5518BdE99b99067D259";
    const USR_USD_ORACLE = "0xf9C7c25FE58AAA494EE7ff1f6Cf0b70d7C7ce88c";
    // Deploy the contract
    const PTUSROracle = await ethers.getContractFactory(
      "PTUSROracle"
    );
    ptUSROracle = await PTUSROracle.deploy(
        Spectra_PTUSR_USR_ORACLE,
        USR_USD_ORACLE
    );
    await ptUSROracle.waitForDeployment();
  });

  it("should return the correct PT-USR/USD price with 8 decimals", async function () {
    // Call the latestAnswer function to get the inETH/USD price
    const value = await ptUSROracle.latestAnswer();

    // Print the results to the console for debugging
    console.log("PT-USR/USD Price:", value);

    // Assertions to ensure the returned value is within a reasonable range
    expect(parseInt(value)).to.be.greaterThan(0);
    // You can add additional checks here based on the current price range of ETH/USD
  });
});