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
