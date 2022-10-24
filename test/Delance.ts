import { expect } from 'chai';
import { ethers } from 'hardhat';

describe('Delance', function (): void {
  it("Should log the constructor log", async function (): Promise<void> {
    const Delance = await ethers.getContractFactory('Delance');
    const delance = await Delance.deploy('Hello, world!');
    await delance.deployed();

    console.log(await delance.greeting());
    expect(await delance.greeting()).to.equal('Hello, world!');
  });

  it("Should log the constructor log", async function (): Promise<void> {
    const Delance = await ethers.getContractFactory('Delance');
    const delance = await Delance.deploy('Hello, world!');
    await delance.deployed();

    expect(await delance.getFreelancer()).to.equal('0x0000000000000000000000000000000000000000');
  });
});