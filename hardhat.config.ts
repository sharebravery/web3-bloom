import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import 'solidity-docgen';

const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: `0.8.20`,
        settings: {
          optimizer: {
            enabled: true,
            runs: 1000
          },
          viaIR: true,
          evmVersion: `shanghai`, // downgrade to `paris` if you encounter 'invalid opcode' error
        }
      },
    ],
  },
  networks: {
    // mumbai: {
    //   url: `https://matic-mumbai.chainstacklabs.com`, // Mumbai 测试网络的 RPC URL
    // },
    sepolia: {
      url: "https://polygon-mumbai.g.alchemy.com/v2/k_wjgD_vDNows-mCiUJ_ikKh-0Gd2c0C",
      accounts: ['a9990f25bf4b7e310b40e83af5e2c367983df2bf0d188a5bc58e77e2fc0c3423']
    }
  },
};

export default {
  ...config,
  docgen: {
    outputDir: './',
    pages: () => 'README.md',
  },
};
