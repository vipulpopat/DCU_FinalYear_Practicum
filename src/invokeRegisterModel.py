from web3 import Web3
import json
import time

def load_contract_abi(file_path):
    with open(file_path, 'r') as file:
        abi_json = json.load(file)
    return abi_json

# Connect to the Mumbai testnet
#web3 = Web3(Web3.HTTPProvider('https://rpc-mumbai.matic.today'))  # QuickNode
web3 = Web3(Web3.HTTPProvider('https://matic-mumbai.chainstacklabs.com'))  # Chainstack
#web3 = Web3(Web3.HTTPProvider('https://matic-testnet-archive-rpc.bwarelabs.com'))  # Bware Labs

# Set the address and ABI of your deployed smart contract
contract_address = '0x9C9399f27F0F56B6498aE5C584b815cAA3943bc8'
abi_file_path = r'C:\Users\vipul\OneDrive\Documents\Git-Repositories\practicum\src\contracts\artifacts\AIModelRegistry.abi'
contract_abi = load_contract_abi(abi_file_path)

# Create a contract object
contract = web3.eth.contract(address=contract_address, abi=contract_abi)

# Specify the account to use for sending transactions
private_key = 'e8e42f343012460fe6eab04b532593ac1cd23d228a89f16ecdb1a14d89cf64ad'
account = web3.eth.account.from_key(private_key)

# Set the default account to use for sending transactions
web3.eth.default_account = account.address

# Example function to invoke on the smart contract
def invoke_contract_function():
    # Specify the function to call and its arguments
    function_name = 'registerModel'
    function_args = ['arg1', 'arg2', 'arg3', 'arg4', 'arg5']

    # Create a transaction
    transaction = contract.functions[function_name](*function_args).build_transaction({
        'from': account.address,
        'nonce': web3.eth.get_transaction_count(account.address),
        'gas': 30000,  # Adjust the gas limit as per your contract's requirement
        'gasPrice': web3.to_wei('100', 'gwei'),  # Adjust the gas price as per the network congestion
    })


    try:
        # Sign the transaction
        signed_txn = web3.eth.account.sign_transaction(transaction, account._private_key)
        time.sleep(2) 
        # Send the signed transaction
        tx_hash = web3.eth.send_raw_transaction(signed_txn.rawTransaction)
        time.sleep(2) 
        # Wait for the transaction to be mined
        tx_receipt = web3.eth.wait_for_transaction_receipt(tx_hash)
        time.sleep(2) 
        # Check the status of the transaction receipt
        print(f"Tx Receipt: {str(tx_receipt)}")
        if tx_receipt['status'] == 1:
            print("Transaction successful!")
        else:
            print("Transaction failed.")
    except Exception as e:
        print(f"Error: {str(e)}")

# Call the example function
invoke_contract_function()
