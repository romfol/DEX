// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers, run } from "hardhat";

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const TokenSale = await ethers.getContractFactory("TokenSale");
  const greeting = "Hello, Hardhat!";
  const tokenSale = await TokenSale.deploy(greeting);

  await tokenSale.deployed();

  await new Promise(resolve => setTimeout(resolve, 60000)); // pause 3-4 blocks for etherscan update

  // Verifying contract
  await run("verify:verify", {address: tokenSale.address, constructorArguments: [greeting]});

  console.log("TokenSale deployed and verified to:", tokenSale.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
