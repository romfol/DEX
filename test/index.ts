import { expect } from "chai";
import { web3 } from "hardhat";
const { ethers } = require("hardhat");
const hre = require("hardhat");

describe("TokenSale", function () {
  it("Should return the new greeting once it's changed", async function () {
    const TokenSale = await ethers.getContractFactory("TokenSale");
    const tokenSale = await TokenSale.deploy("Hello, world!");
    await tokenSale.deployed();

    await hre.network.provider.request({
      method: "hardhat_impersonateAccount",
      params: ["0x364d6D0333432C3Ac016Ca832fb8594A8cE43Ca6"],
    });

    await hre.network.provider.request({
      method: "hardhat_setBalance",
      params: ["0x364d6D0333432C3Ac016Ca832fb8594A8cE43Ca6", "0x1000000000000000000000000000"],
    });

    let tx = await web3.eth.sendTransaction({from: "0x364d6D0333432C3Ac016Ca832fb8594A8cE43Ca6", to: "0x364d6D0333432C3Ac016Ca832fb8594A8cE43Ca6", value: "1"})
    console.log("Transaction!:", tx);

    expect(await tokenSale.greet()).to.equal("Hello, world!");

    const setGreetingTx = await tokenSale.setGreeting("Hola, mundo!");

    // wait until the transaction is mined
    await setGreetingTx.wait();

    expect(await tokenSale.greet()).to.equal("Hola, mundo!");
  });
});
