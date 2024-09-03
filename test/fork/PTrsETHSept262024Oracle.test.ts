import { ethers } from "hardhat";
import { expect } from "chai";
import { BaseContract, ContractTransactionResponse, Contract } from "ethers";
import { increaseTo } from "@nomicfoundation/hardhat-network-helpers/dist/src/helpers/time";
import { mine } from "@nomicfoundation/hardhat-network-helpers";

describe.only("PTrsETHSept262024Oracle Fork Test", function () {
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
  });

  it("should return the correct rsETH/USD price with 8 decimals", async function () {
    const usdPrice = await oracle.usdPrice();
    const rawPrice = await oracle.rawPrice();
    const latestAnswer = await oracle.latestAnswer();

    console.log("PT-rsETH/rsETH Price:", Number(rawPrice) / 1e18);
    console.log("rsETH/USD Price:", Number(usdPrice) / 1e8);
    console.log("PT-rsETH/USD Price:", (Number(latestAnswer) / 1e8).toString());

    // Assertions to ensure the returned value is within a reasonable range
    expect(parseInt(latestAnswer)).to.be.greaterThan(0);
    // You can add additional checks here based on the current price range of ETH/USD
  });

  it("should return rsETH/USD price after expiry", async function () {
    await increaseTo(1727308800 + 10);
    await mine();

    const usdPrice = await oracle.usdPrice();
    const rawPrice = await oracle.rawPrice();
    const latestAnswer = await oracle.latestAnswer();

    expect(parseInt(rawPrice)).to.be.eq(1e18);
    expect(parseInt(latestAnswer)).to.be.eq(parseInt(usdPrice));
  });
});
