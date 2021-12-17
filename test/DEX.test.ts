import { expect } from "chai";
const { ethers } = require("hardhat");

describe("DEX contract", function () {
  let Token;
  let hardhatToken: any;
  let owner: any;
  let addr1;
  let addr2;
  let addrs;
  beforeEach(async function () {
    Token = await ethers.getContractFactory("DEX");
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
    hardhatToken = await Token.deploy();
  });
  describe("Deployment", function () {
    it("Should set the right owner", async function () {
      expect(await hardhatToken.owner()).to.equal(owner.address);
    });

    it("Should assign the total supply of tokens to the owner", async function () {
      const ownerBalance = await hardhatToken.balanceOf(owner.address);
      expect(await hardhatToken.totalSupply()).to.equal(ownerBalance);
    });
  });
});

// describe("DEX contract", function () {
//   it("Should return the new greeting once it's changed", async function () {
//     const TokenSale = await ethers.getContractFactory("DEX");
//     const tokenSale = await TokenSale.deploy();
//     await tokenSale.deployed();

//     await hre.network.provider.request({
//       method: "hardhat_impersonateAccount",
//       params: ["0x364d6D0333432C3Ac016Ca832fb8594A8cE43Ca6"],
//     });
//     tokenSale.buyToken()
    // await hre.network.provider.request({
    //   method: "buyToken",
    //   params: ["0x364d6D0333432C3Ac016Ca832fb8594A8cE43Ca6", "0x1000000000000000000000000000"],
    // });

    // let tx = await web3.eth.sendTransaction({from: "0x364d6D0333432C3Ac016Ca832fb8594A8cE43Ca6", to: "0x364d6D0333432C3Ac016Ca832fb8594A8cE43Ca6", value: "1"})
    // console.log("Transaction!:", tx);

    // expect(await tokenSale.greet()).to.equal("Hello, world!");

    // const setGreetingTx = await tokenSale.setGreeting("Hola, mundo!");

    // // wait until the transaction is mined
    // await setGreetingTx.wait();

    // expect(await tokenSale.greet()).to.equal("Hola, mundo!");
//   });
// });
