const DEX = artifacts.require("DEX");
const Folton = artifacts.require("Folton");

module.exports = function (deployer) {
   deployer.deploy(DEX);
   deployer.deploy(Folton);
};
