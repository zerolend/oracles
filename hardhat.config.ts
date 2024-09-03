import "@nomicfoundation/hardhat-ethers";
import "hardhat-deploy";
import "@nomicfoundation/hardhat-verify";

import dotenv from "dotenv";
dotenv.config();

import "./tasks/deploy-api3";
import "./tasks/deploy-api3-eth";
import "./tasks/deploy-pyth";
import "./tasks/deploy-pendle";
import "./tasks/update-pyth";

const ALCHEMY_KEY = process.env.ALCHEMY_KEY || "";

export default {
  solidity: "0.8.20",
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      forking: {
        url: `https://cloudflare-eth.com`,
      },
    },
    blast: {
      url: `https://rpc.blast.io`,
      accounts: [process.env.WALLET_PRIVATE_KEY || ""],
    },
    mainnet: {
      url: `https://rpc.ankr.com/eth`,
      accounts: [process.env.WALLET_PRIVATE_KEY || ""],
    },
    linea: {
      url: `https://rpc.linea.build/`,
      accounts: [process.env.WALLET_PRIVATE_KEY || ""],
    },
    era: {
      url: `https://mainnet.era.zksync.io`,
      accounts: [process.env.WALLET_PRIVATE_KEY || ""],
    },
    manta: {
      url: `https://pacific-rpc.manta.network/http`,
      accounts: [process.env.WALLET_PRIVATE_KEY || ""],
    },
  },
  etherscan: {
    apiKey: {
      blast: process.env.BLASTSCAN_KEY || "",
      linea: process.env.LINEASCAN_KEY || "",
      xLayer: process.env.XLAYER_KEY || "",
      mainnet: process.env.ETHERSCAN_KEY || "",
      manta: "",
      era: process.env.ZKSYNC_KEY || "",
    },
    customChains: [
      {
        network: "manta",
        chainId: 169,
        urls: {
          apiURL: "https://pacific-explorer.manta.network/api",
          browserURL: "https://pacific-explorer.manta.network",
        },
      },
      {
        network: "linea",
        chainId: 59144,
        urls: {
          apiURL: "https://api.lineascan.build/api",
          browserURL: "https://lineascan.build",
        },
      },
      {
        network: "blast",
        chainId: 81457,
        urls: {
          apiURL: "https://api.blastscan.io/api",
          browserURL: "https://blastscan.io",
        },
      },
      {
        network: "xLayer",
        chainId: 196,
        urls: {
          apiURL:
            "https://www.oklink.com/api/v5/explorer/contract/verify-source-code-plugin/XLAYER",
          browserURL: "https://www.oklink.com/xlayer", //or https://www.oklink.com/xlayer for mainnet
        },
      },
    ],
  },
};
