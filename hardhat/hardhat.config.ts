import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

import * as dotenv from "dotenv";
require('dotenv').config();
import "@nomicfoundation/hardhat-ethers";
import "@typechain/hardhat"
import "@nomicfoundation/hardhat-verify";


// If not set, it uses the hardhat account 0 private key.
const deployerPrivateKey = process.env.PRIVATE_KEY || "";
const scrollScanApiKey = process.env.SCROLLSCAN_API_KEY;
const alchemyApiKey = process.env.ALCHEMY_API_KEY;

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  defaultNetwork: "scrollSepolia",
  networks: {
    scrollSepolia: {
      url: `https://scroll-sepolia.g.alchemy.com/v2/${alchemyApiKey}`,
      accounts: [deployerPrivateKey],
    },
  },
  etherscan: {

    apiKey: {
        scrollSepolia: `${scrollScanApiKey}`,
    },
    customChains: [
        {
            network: "scrollSepolia",
            chainId: 534351,
            urls: {
            apiURL: "https://api-sepolia.scrollscan.com/api",
            browserURL: "https://sepolia.scrollscan.io"

            }
        }
    ]
  },
};

export default config;
