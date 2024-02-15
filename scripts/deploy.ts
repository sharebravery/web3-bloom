import { ethers } from "hardhat";

async function main() {
  const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  const unlockTime = currentTimestampInSeconds + 60;

  const lockedAmount = ethers.parseEther("0.001");

  // 获取部署账户
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contact with account:", deployer.address);

  const PlantBase = await ethers.getContractFactory("PlantBase");
  const plantBase = await PlantBase.deploy();
  await plantBase.waitForDeployment();

  const PlantFactory = await ethers.getContractFactory("PlantFactory");
  const plantFactory = await PlantFactory.deploy(await plantBase.getAddress());
  await plantFactory.waitForDeployment();

  console.log("PlantBase deployed to:", await plantBase.getAddress());
  console.log("PlantFactory deployed to:", await plantFactory.getAddress());

  console.log(
    `Lock with ${ethers.formatEther(
      lockedAmount
    )}ETH and unlock timestamp ${unlockTime} deployed to ${plantBase.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
