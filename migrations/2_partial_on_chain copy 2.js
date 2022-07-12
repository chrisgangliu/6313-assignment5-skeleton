const partial_on_chain = artifacts.require("partial_on_chain");

module.exports = function (deployer) {
  deployer.deploy(partial_on_chain);
};
