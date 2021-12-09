const TokenSale = artifacts.require("TokenSale");
const Folton = artifacts.require("Folton");

module.exports = function (deployer) {
   deployer.deploy(TokenSale);
   // deployer.deploy(Folton);
};
