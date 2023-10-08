import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const deployYourContract: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  // Get the deployed contract
  const yourToken = await hre.ethers.getContract("YourToken", deployer);

  await deploy("Vendor", {
    from: deployer,
    args: [yourToken.address], // Contract constructor arguments
    log: true,
    autoMine: true,
  });

  const vendor = await hre.ethers.getContract("Vendor", deployer);

  // Todo: transfer the tokens to the vendor
  console.log("\n 🏵  Sending all 1000 tokens to the vendor...\n");

  await yourToken.transfer(vendor.address, hre.ethers.utils.parseEther("1000"));

  await vendor.transferOwnership("0xeA37928217A757c83D06D9e624F637439Ba224e5");
};

export default deployYourContract;

// Tags are useful if you have multiple deploy files and only want to run one of them.
// e.g. yarn deploy --tags YourContract
deployYourContract.tags = ["Vendor"];
