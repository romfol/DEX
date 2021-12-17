import { expect } from "chai";
const { ethers } = require("hardhat");

describe("Token contract", function () {
  let Token;
  let hardhatToken: any;
  let tokenBalance: any;
  let tokenSupply: any;
  let owner: any;
  let addresses: any;

  beforeEach(async function () {
    Token = await ethers.getContractFactory("Folton");
    [owner, ...addresses] = await ethers.getSigners();
    hardhatToken = await Token.deploy();
    tokenBalance = await hardhatToken.balanceOf(hardhatToken.address).value;
    tokenSupply = hardhatToken.totalSupply().value;
  });

  describe("Deployment", function () {
    it("Should set the right owner", async function () {
      expect(await hardhatToken.deployTransaction.from).to.equal(owner.address);
    });

    it("Deployment should assign the total supply of tokens to the token", async function () {
      expect(await tokenSupply).to.equal(tokenBalance);
    });
  });
});
