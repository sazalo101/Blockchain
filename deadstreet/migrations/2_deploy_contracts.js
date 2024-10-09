// migrations/2_deploy_contracts.js

const Veeko = artifacts.require("Veeko");

module.exports = function(deployer) {
  deployer.deploy(Veeko);
};
