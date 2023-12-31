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
};

export default {
  ...config,
  docgen: {
    outputDir: './',
    pages: () => 'README.md',
  },
};
