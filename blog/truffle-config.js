require('dotenv').config();
const HDWalletProvider = require("@truffle/hdwallet-provider");

const privateKey = process.env.PRIVATE_KEY;
const accountAddress = process.env.PUBLIC_ADDRESS;

module.exports = {
  networks: {
    local: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*", // Any network ID
    },
    alfajores: {
      provider: function () {
        return new HDWalletProvider(
          privateKey, // Use private key from environment variable
          "https://alfajores-forno.celo-testnet.org"
        );
      },
      network_id: 44787, // Alfajores testnet ID
      from: accountAddress, // Public address from environment variable
      gas: 2000000,
      deployTimeout: 300000,
      networkCheckTimeout: 300000,
    },
    mainnet: {
      provider: function () {
        return new HDWalletProvider(
          privateKey, // Use private key from environment variable
          "https://forno.celo.org"
        );
      },
      network_id: 42220, // Mainnet ID
      from: accountAddress, // Public address from environment variable
      gas: 4000000,
      deployTimeout: 300000,
      networkCheckTimeout: 300000,
    },
  },
  // Configure your compilers
  compilers: {
    solc: {
      version: "0.5.16", // Fetch exact version from solc-bin (default: truffle's version)
    },
  },
};
