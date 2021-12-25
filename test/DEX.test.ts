
import { assert, web3, artifacts } from "hardhat";
const truffleAssert = require('truffle-assertions');
const Token = artifacts.require("Folton");
const DEX = artifacts.require("DEX");

describe("DEX contract", function () {
  let accounts: string[];
  let primaryAcc: string;
  let secondaryAcc: string;
  let token: any;
  let dex: any;
  let tokenBalance: String;
  let bn: any;
  let tokensExpectMinted: Number;


  beforeEach(async function () {
    accounts = await web3.eth.getAccounts();
    primaryAcc = accounts[0];
    secondaryAcc = accounts[1];

    token = await Token.new();
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
      // await dex.buyByETH();
      const bn = web3.utils.toBN(1e17);
      const NULL_ADDRESS = '0x0000000000000000000000000000000000000000';

      const amount_sst_before_payer = await token.balanceOf(primaryAcc);
      const amount_sst_before_contract = await token.balanceOf(dex.address);
      const amount_eth_before_payer = await web3.eth.getBalance(primaryAcc);
      const amount_eth_before_contract = await web3.eth.getBalance(dex.address);
      console.log(111, amount_eth_before_payer, amount_eth_before_contract, amount_sst_before_contract.toString(), dex.address);
      const amount_eth_before = bn.muln(1);
      const expected_amount_sst_payer = web3.utils.toBN("464706547924000000000");
      const result = await dex.buyToken(NULL_ADDRESS, web3.utils.toBN("0"), { from: primaryAcc, value: amount_eth_before });
      const transaction = await web3.eth.getTransaction(result.tx);
      const used_gas = web3.utils.toBN(result.receipt.gasUsed);
      const gas_price = web3.utils.toBN(transaction.gasPrice);
      const amount_sst_after_payer = await token.balanceOf(primaryAcc);
      const amount_sst_after_contract = await token.balanceOf(dex.address);
      const amount_eth_after_payer = web3.utils.toBN(await web3.eth.getBalance(primaryAcc));
      const amount_eth_after_contract = web3.utils.toBN(await web3.eth.getBalance(dex.address));
      assert.equal(true, amount_sst_after_payer.eq(expected_amount_sst_payer));
      assert.equal(true, amount_sst_after_contract.eq(amount_sst_before_contract.sub(expected_amount_sst_payer)));
      assert.equal(true, amount_eth_before.eq(amount_eth_after_contract));
      // assert.equal(true, amount_eth_after_payer.eq(amount_eth_before_payer.sub(used_gas.mul(gas_price)).sub(amount_eth_before)));
    });
  });
});
