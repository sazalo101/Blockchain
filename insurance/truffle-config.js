const ContractKit = require("@celo/contractkit");
const Web3 = require("web3");

const web3 = new Web3("https://alfajores-forno.celo-testnet.org");
const kit = ContractKit.newKitFromWeb3(web3);

// Add your private key and account address
const privateKey = "3aeb13793ee262a246172bf824c0b445dccd05979a736ffa539cee5d0895f5f6";
const accountAddress = "0x6846Ce730c6Db995E4A10e52Df16E57524016570";

kit.addAccount(privateKey);

module.exports = {
  networks: {
    development: { host: "127.0.0.1", port: 7545, network_id: "*" },
    alfajores: {
      provider: kit.connection.web3.currentProvider,
      network_id: 44787,
      from: accountAddress,
      gas: 6721975,
      gasPrice: 20000000000,
    },
  },
  compilers: {
    solc: {
      version: "0.8.0",
    },
  },
};