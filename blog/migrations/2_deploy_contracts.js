// migrations/2_deploy_contracts.js

const Blog = artifacts.require("Blog");

module.exports = function(deployer) {
  deployer.deploy(Blog);
};
