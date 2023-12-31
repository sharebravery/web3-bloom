import { ethers } from "hardhat";

async function main() {
  const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  const unlockTime = currentTimestampInSeconds + 60;

  const lockedAmount = ethers.parseEther("0.001");

  // 获取部署账户
  const [deployer] = await ethers.getSigners();

  console.log("Deploying ElectronicPlantBase with account:", deployer.address);

  const ElectronicPlantBase = await ethers.getContractFactory("ElectronicPlantBase");
  const electronicPlantBase = await ElectronicPlantBase.deploy();
  await electronicPlantBase.waitForDeployment();

  const PlantFactory = await ethers.getContractFactory("PlantFactory");
  const plantFactory = await PlantFactory.deploy(await electronicPlantBase.getAddress());
  await plantFactory.waitForDeployment();

  console.log("ElectronicPlantBase deployed to:", await electronicPlantBase.getAddress());
  console.log("PlantFactory deployed to:", await plantFactory.getAddress());

  console.log(
    `Lock with ${ethers.formatEther(
      lockedAmount
    )}ETH and unlock timestamp ${unlockTime} deployed to ${electronicPlantBase.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
