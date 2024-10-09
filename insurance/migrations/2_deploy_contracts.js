const Insurance = artifacts.require("Insurance");

module.exports = async function (deployer, network, accounts) {
  const cUSDTokenAddress = '0xB99Ae3dD496eE38Fc5c5AE6474CD25b8557366d1'; // Replace with the actual cUSD token address on the Celo network
  const premiumAmount = web3.utils.toWei('1', 'ether'); // 1 cUSD as the premium amount (adjust as needed)

  await deployer.deploy(Insurance, cUSDTokenAddress, premiumAmount);
};
