const path = require("path");
const HDWalletProvider = require("@truffle/hdwallet-provider");

module.exports = {
  contracts_build_directory: path.join(__dirname, "client/src/contracts"),
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*", // Match any network id
    },
    alfajores: {
      provider: () =>
        new HDWalletProvider(
          "cycle bullet seven orphan valve train mad such neck margin arrow inform clog goat observe stairs screen point inmate clog theme maximum long expose",
          "https://alfajores-forno.celo-testnet.org"
        ),
      network_id: 44787, // Alfajores testnet network id
    },
  },
  compilers: {
    solc: {
      version: "0.8.0", // Fetch exact version from solc-bin (default: truffle's version)
    },
  },
};
