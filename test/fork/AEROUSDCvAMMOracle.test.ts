import { ethers } from "hardhat";
import { expect } from "chai";
import { BaseContract, ContractTransactionResponse, Contract } from "ethers";

describe.only("AEROUSDCvAMMOracle Fork Test", function () {
  let oracle: BaseContract & {
    deploymentTransaction(): ContractTransactionResponse;
  } & Omit<Contract, keyof BaseContract>;
  let owner;

  beforeEach(async function () {
    // Get signers
    [owner] = await ethers.getSigners();
    // Deploy the contract
    const oracleD = await ethers.getContractFactory("AEROUSDCvAMMOracle");
    oracle = await oracleD.deploy();
    await oracle.waitForDeployment();
  });

  it("should return the correct LP price with 8 decimals", async function () {
    const price = await oracle.getPrice();
    const latestAnswer = await oracle.latestAnswer();

    console.log("LP Price:", Number(price) / 1e8);
    console.log("LP Latest Answer:", Number(latestAnswer) / 1e8);
    console.log(
      "LP Latest Answer for 0.00000005000761521:",
      ((Number(latestAnswer) * 50007615210) / 1e18 / 1e8).toString()
    );

    // Assertions to ensure the returned value is within a reasonable range
    expect(parseInt(latestAnswer)).to.be.greaterThan(0);
    // You can add additional checks here based on the current price range of ETH/USD
  });
});
