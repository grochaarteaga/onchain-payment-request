import streamlit as st
from web3 import Web3
from dotenv import load_dotenv
import os, json

# Load environment variables
load_dotenv()
RPC_URL = os.getenv("SEPOLIA_RPC_URL")
PRIVATE_KEY = os.getenv("PRIVATE_KEY")
PUBLIC_ADDRESS = os.getenv("PUBLIC_ADDRESS")
TOKEN_ADDRESS = os.getenv("MOCK_USDC_ADDRESS")
CONTRACT_ADDRESS = os.getenv("PAYMENT_REQUEST_ADDRESS")

# Connect to Sepolia
w3 = Web3(Web3.HTTPProvider(RPC_URL))

st.title("💸 On-chain Payment Request Dashboard")
st.write(f"Connected wallet: `{PUBLIC_ADDRESS}`")

# Load contract ABIs
with open("../artifacts/contracts/MockUSDC.sol/MockUSDC.json") as f:
    token_abi = json.load(f)["abi"]

with open("../artifacts/contracts/PaymentRequest.sol/PaymentRequest.json") as f:
    payment_abi = json.load(f)["abi"]

token = w3.eth.contract(address=TOKEN_ADDRESS, abi=token_abi)
payment = w3.eth.contract(address=CONTRACT_ADDRESS, abi=payment_abi)

# --- Helpers ---
def build_tx(function):
    nonce = w3.eth.get_transaction_count(PUBLIC_ADDRESS, "pending")
    tx = function.build_transaction({
        "from": PUBLIC_ADDRESS,
        "nonce": nonce,
        "gas": 2000000,
        "gasPrice": w3.to_wei("10", "gwei")
    })
    signed = w3.eth.account.sign_transaction(tx, PRIVATE_KEY)
    tx_hash = w3.eth.send_raw_transaction(signed.raw_transaction)
    receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
    return receipt.transactionHash.hex()

# --- Tabs ---
tab1, tab2, tab3 = st.tabs(["🏦 Balances", "➕ Create Request", "✅ Manage Requests"])

with tab1:
    balance = token.functions.balanceOf(PUBLIC_ADDRESS).call() / 1e18
    st.metric("MockUSDC Balance", f"{balance:,.2f} USDC")

with tab2:
    st.subheader("Create a new payment request")
    payee = st.text_input("Payee address")
    amount = st.number_input("Amount (USDC)", min_value=0.01, step=0.01)
    description = st.text_input("Description")
    if st.button("Create Request"):
        wei_amount = int(amount * 1e18)
        tx = payment.functions.createRequest(payee, wei_amount, description)
        tx_hash = build_tx(tx)
        st.success(f"✅ Request created! [View on Etherscan](https://sepolia.etherscan.io/tx/0x{tx_hash})")
        st.stop()  # Prevent Streamlit from re-running the same code

with tab3:
    st.subheader("Approve or Cancel Request")
    req_id = st.number_input("Request ID", min_value=1, step=1)
    col1, col2 = st.columns(2)
    with col1:
        if st.button("Approve"):
            tx_hash = build_tx(payment.functions.approveRequest(req_id))
            st.success(f"🎉 Request approved! Tx: {tx_hash}")
    with col2:
        if st.button("Cancel"):
            tx_hash = build_tx(payment.functions.cancelRequest(req_id))
            st.info(f"🗑️ Request cancelled! Tx: {tx_hash}")
