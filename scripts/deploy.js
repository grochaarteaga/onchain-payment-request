const hre = require("hardhat");
require("dotenv").config();

async function main() {
  const tokenAddress = process.env.TOKEN_ADDRESS;
  if (!tokenAddress) throw new Error("Missing TOKEN_ADDRESS in .env");

  console.log("Deploying PaymentRequest with token:", tokenAddress);

  const PaymentRequest = await hre.ethers.getContractFactory("PaymentRequest");
  const paymentRequest = await PaymentRequest.deploy(tokenAddress);

  await paymentRequest.deployed();

  console.log("✅ PaymentRequest deployed to:", paymentRequest.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
