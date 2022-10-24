import { ethers } from "hardhat";

async function main() {

  const Delance = await ethers.getContractFactory("Delance");
  const delance = await Delance.deploy('Delance Depoloyed');

  await delance.deployed();
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
