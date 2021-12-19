import * as dotenv from 'dotenv'

dotenv.config();

import "@nomiclabs/hardhat-truffle5";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-ethers";

require("@nomiclabs/hardhat-web3");
require("solidity-coverage");

/**
 * @type import('hardhat/config').HardhatUserConfig
 */

const {
  INFURA_KEY,
  ALCHEMY_KEY,
  MNEMONIC,
  ETHERSCAN_API_KEY,
  PRIVATE_KEY,
  PRIVATE_KEY_TESTNET
} = process.env;

const accountsTestnet = PRIVATE_KEY_TESTNET
  ? [PRIVATE_KEY_TESTNET]
  : { mnemonic: MNEMONIC };

const accountsMainnet = PRIVATE_KEY
  ? [PRIVATE_KEY]
  : { mnemonic: MNEMONIC };

module.exports = {
  solidity: "0.8.10",

  networks: {
    // hardhat: {
    //   forking: {
    //     url: `https://mainnet.infura.io/v3/${INFURA_KEY}`,
    //     accounts: accountsTestnet,
    //   }
    // },
    hardhat: {
      forking: {
        url: `https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_KEY}`,
        blockNumber: 9842600,
      }
    },
    mainnet: {
      url: `https://mainnet.infura.io/v3/${INFURA_KEY}`,
      // accounts: accountsMainnet,
    },
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${INFURA_KEY}`,
      accounts: accountsTestnet,
    },
    ropsten: {
      url: `https://ropsten.infura.io/v3/${INFURA_KEY}`,
      accounts: accountsTestnet,
    }
  },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY
  }
};
