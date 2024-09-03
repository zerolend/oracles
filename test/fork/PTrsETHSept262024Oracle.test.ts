import { ethers } from "hardhat";
import { expect } from "chai";
import { BaseContract, ContractTransactionResponse, Contract } from "ethers";

describe("PTrsETHSept262024Oracle Fork Test", function () {
  let oracle: BaseContract & {
    deploymentTransaction(): ContractTransactionResponse;
  } & Omit<Contract, keyof BaseContract>;
  let owner;

  beforeEach(async function () {
    // Get signers
    [owner] = await ethers.getSigners();
    // Deploy the contract
    const MorphoOracle = await ethers.getContractFactory(
      "PTrsETHSept262024Oracle"
    );
    oracle = await MorphoOracle.deploy();
    await oracle.waitForDeployment();

    console.log("deployed", oracle.target);
  });

  it.only("should return the correct rsETH/USD price with 8 decimals", async function () {
    // Call the latestAnswer function to get the inETH/USD price
    const rawPrice = await oracle.rawPrice();
    console.log("PT-rsETH/rsETH Price:", rawPrice.toString());

    const value = await oracle.latestAnswer();

    console.log("PT-rsETH/USD Price:", (Number(value) / 1e8).toString());
    // Print the results to the console for debugging

    // Assertions to ensure the returned value is within a reasonable range
    expect(parseInt(value)).to.be.greaterThan(0);
    // You can add additional checks here based on the current price range of ETH/USD
  });
});
