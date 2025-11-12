# On-chain Payment Request (USDC)

---

## Phase 1.2 – Payment Request Smart Contract

**Goal:**  
Design and compile a secure Solidity smart contract to handle on-chain payment requests using ERC-20 tokens (like USDC).

**Achievements:**  
✅ Installed OpenZeppelin Contracts  
✅ Created `PaymentRequest.sol` smart contract  
✅ Successfully compiled all dependencies (8 Solidity files, evm target: paris)  
✅ Verified project environment (Node 22 LTS, Hardhat 2.27, Solidity 0.8.24)

**Smart Contract Features:**  
- `createRequest(address to, uint256 amount, string description)` – Creates a pending payment request.  
- `approveRequest(uint256 id)` – Transfers tokens after payer approval.  
- `cancelRequest(uint256 id)` – Cancels pending requests.  
- Emits `RequestCreated`, `RequestApproved`, `RequestCancelled` events.  

**Next Steps:**  
Phase 1.3 – Deploy the contract to the Sepolia testnet using Hardhat, Alchemy, and environment variables.

---

## Phase 1.3 – Smart Contract Deployment (Sepolia)

**Goal:**  
Deploy the `PaymentRequest` smart contract to the Ethereum Sepolia testnet using Hardhat and Alchemy.

**Deployment Info:**  
- **Network:** Sepolia Testnet  
- **Token (Mock USDC):** 0xB7C4Eb5F98Fad995E940476711fe0785b66D5851  
- **Deployed Contract:** [0xcC276DEf88c9454405Cf4DE7eaD177CFbD903f8C](https://sepolia.etherscan.io/address/0xcC276DEf88c9454405Cf4DE7eaD177CFbD903f8C)  
- **EVM target:** Paris  
- **Compiler version:** 0.8.24  

**Achievements:**  
✅ Connected Hardhat to Alchemy Sepolia RPC  
✅ Deployed `PaymentRequest.sol` successfully  
✅ Verified contract address on Etherscan  

**Next Phase (1.4):**  
Integrate Web3.py + Streamlit to interact with the deployed contract (create requests, approve, cancel, and view status).
