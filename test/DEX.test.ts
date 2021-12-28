
import { assert, web3, artifacts } from "hardhat";
const Token = artifacts.require("Folton");
const DEX = artifacts.require("DEX");
const TokenDAI = artifacts.require("DAItest");

describe("DEX contract", function () {
  let accounts: string[];
  let primaryAcc: string;
  let secondaryAcc: string;
  let token: any;
  let tokenDAI: any;
  let dex: any;
  let tokenBalance: String;
  let bn: any;
  let tokensExpectMinted: Number;


  beforeEach(async function () {
    accounts = await web3.eth.getAccounts();
    primaryAcc = accounts[0];
    secondaryAcc = accounts[1];
    token = await Token.new();
    tokenDAI = await TokenDAI.new(100);
    dex = await DEX.new();
    bn = web3.utils.toBN(1e18);
    tokensExpectMinted = 1000000;
  });
  describe("Deployment", function () {
    it("Should get 1000000 Folton tokens on initialization", async () => {
      const tokensExpectMintedToBN = bn.muln(tokensExpectMinted);

      tokenBalance = await dex.getBalanceValue();

      assert.equal(tokensExpectMintedToBN.toString(), tokenBalance.toString());
    });
  });
  describe("Buy Tokens", function () {
    it("Should buy tokens by Ethereum", async () => {
      const tokenBalanceDEXBefore = await dex.getBalanceValue();
      const ETHBalanceBuyerBefore = web3.utils.toBN(await web3.eth.getBalance(primaryAcc));
      const ETHBalanceBefore = bn.muln(1);

      await dex.buyByETH({ from: primaryAcc, value: ETHBalanceBefore });

      const tokenBalanceDEXAfter = await dex.getBalanceValue();
      const ETHBalanceBuyerAfter = web3.utils.toBN(await web3.eth.getBalance(primaryAcc));

      assert.equal(false, tokenBalanceDEXBefore.eq(tokenBalanceDEXAfter));
      assert.equal(false, ETHBalanceBuyerBefore.eq(ETHBalanceBuyerAfter));
    });

    it("Should buy tokens by DAI", async () => {
      const tokenBalanceDEXBefore = await token.balanceOf(dex.address);
      const tokenBalanceBuyerBefore = await token.balanceOf(primaryAcc);
      const amountDAI = 100;

      await tokenDAI.approve(dex.address, amountDAI, { from: primaryAcc });
      await dex.buyByDAI(amountDAI, { from: primaryAcc });

      const tokenBalanceDEXAfter = await dex.getBalanceValue();
      const tokenBalanceBuyerAfter = await token.balanceOf(primaryAcc);

      assert.equal(false, tokenBalanceDEXBefore.eq(tokenBalanceDEXAfter));
      assert.equal(false, tokenBalanceBuyerBefore.eq(tokenBalanceBuyerAfter));
    });
  });
});
