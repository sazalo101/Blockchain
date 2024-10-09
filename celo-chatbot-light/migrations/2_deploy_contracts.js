const Chatbot = artifacts.require("Chatbot");

module.exports = function (deployer) {
  deployer.deploy(Chatbot);
};
