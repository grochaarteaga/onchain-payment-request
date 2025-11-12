const hre = require("hardhat");
require("dotenv").config();

async function main() {
  const tokenAddress = process.env.TOKEN_ADDRESS;
  if (!tokenAddress) throw new Error("Missing TOKEN_ADDRESS in .env");

  console.log("Deploying PaymentRequest with token:", tokenAddress);

  const PaymentRequest = await hre.ethers.getContractFactory("PaymentRequest");
  const paymentRequest = await PaymentRequest.deploy(tokenAddress);

  // In Ethers v6, deploy() already waits for deployment.
  console.log("✅ PaymentRequest deployed to:", await paymentRequest.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
