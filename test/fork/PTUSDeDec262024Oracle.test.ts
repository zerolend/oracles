import { ethers } from "hardhat";
import { expect } from "chai";
import { BaseContract, ContractTransactionResponse, Contract } from "ethers";

describe("PTUSDeDec262024Oracle Fork Test", function () {
  let morphoOracle: BaseContract & {
    deploymentTransaction(): ContractTransactionResponse;
  } & Omit<Contract, keyof BaseContract>;
  let owner;

  // Example proxies for Chainlink oracles on Ethereum mainnet
  const _maxImpliedRate = 250000000000000000n; // Replace with the correct inETH/ETH proxy address
  const _twapDuration = 1800; // ETH/USD Chainlink proxy

  beforeEach(async function () {
    // Get signers
    [owner] = await ethers.getSigners();
    const ethUsdAggregator = "0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419";
    // Deploy the contract
    const MorphoOracle = await ethers.getContractFactory(
      "MorphoFeedPTUSDeDec26"
    );
    morphoOracle = await MorphoOracle.deploy(
      _maxImpliedRate,
      _twapDuration,
      ethUsdAggregator
    );
    await morphoOracle.waitForDeployment();
  });

  it("should return the correct weETH/ETH price with 8 decimals", async function () {
    // Call the latestAnswer function to get the inETH/USD price
    const value = await morphoOracle.latestAnswer();

    // Print the results to the console for debugging
    console.log("sUSDe/USD Price:", value.toString());

    // Assertions to ensure the returned value is within a reasonable range
    expect(parseInt(value)).to.be.greaterThan(0);
    // You can add additional checks here based on the current price range of ETH/USD
  });
});
