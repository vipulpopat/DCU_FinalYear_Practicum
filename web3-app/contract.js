const contractAddress = '0x5fD89a367D4A91550A479429B412cDC9052A2774'
const abi = [
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_clientIdentifier",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_modelType",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_hash1",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_hash2",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_hash3",
				"type": "string"
			}
		],
		"name": "registerModel",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_clientIdentifier",
				"type": "string"
			}
		],
		"name": "getAIModelByClientIdentifier",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			},
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_index",
				"type": "uint256"
			}
		],
		"name": "getModelByIndex",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			},
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_modelType",
				"type": "string"
			}
		],
		"name": "getModelsByType",
		"outputs": [
			{
				"internalType": "uint256[]",
				"name": "",
				"type": "uint256[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "modelCount",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "models",
		"outputs": [
			{
				"internalType": "address",
				"name": "clientAddress",
				"type": "address"
			},
			{
				"internalType": "string",
				"name": "clientIdentifier",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "modelType",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "hash1",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "hash2",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "hash3",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]
function invokeContract() {
	let clientIdentifier = document.getElementById("input1").value;
	let modelType = document.getElementById("input2").value;
	let hash1 = document.getElementById("input3").value;
	let hash2 = document.getElementById("input4").value;
	let hash3 = document.getElementById("input5").value;
  
	if (typeof window.ethereum !== "undefined") {
		window.web3 = new Web3(window.ethereum, "sepolia");
		window.ethereum.enable();
	  } else {
		console.error("Please install MetaMask to use this DApp!");
	  }
	  
	  let contract = new web3.eth.Contract(abi, contractAddress); // creating a contract instance
	
	const displayTxDetails = document.getElementById("txDetails");
	let txDetails;

	ethereum
	.request({ method: "eth_requestAccounts" })
	.then((accounts) => {
		const senderAddress = accounts[0];
		return contract.methods
		.registerModel(clientIdentifier, modelType, hash1, hash2, hash3)
		.send({ from: senderAddress });
	})
	.then((receipt) => {
		txDetails=`<a href = https://mumbai.polygonscan.com/tx/${receipt.transactionHash}>Block explorer link</a><br>`
		displayTxDetails.innerHTML = txDetails;
		displayTxDetails.style.display = "block";

	})
	.catch((error) => {
		displayTxDetails.innerHTML = error;
		console.error("Error:", error);
	});
}
  
  


