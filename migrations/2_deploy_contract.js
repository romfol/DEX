const TokenSale = artifacts.require("TokenSale");
const Token = artifacts.require("Token");

module.exports = function (deployer) {
   deployer.deploy(TokenSale);
   // deployer.deploy(Token);
};
