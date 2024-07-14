export const ORDER_SENDER_ABI = [
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_routerAddress",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "_linkTokenAddress",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "_destinationReceiver",
				"type": "address"
			},
			{
				"internalType": "uint64",
				"name": "_destinationChainSelector",
				"type": "uint64"
			}
		],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "currentBalance",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "calculatedFees",
				"type": "uint256"
			}
		],
		"name": "NotEnoughBalance",
		"type": "error"
	},
	{
		"inputs": [],
		"name": "NothingToWithdraw",
		"type": "error"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "bytes32",
				"name": "messageId",
				"type": "bytes32"
			}
		],
		"name": "MessageSent",
		"type": "event"
	},
	{
		"inputs": [],
		"name": "destinationChainSelector",
		"outputs": [
			{
				"internalType": "uint64",
				"name": "",
				"type": "uint64"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "destinationReceiver",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "account",
				"type": "address"
			}
		],
		"name": "linkBalance",
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
		"inputs": [],
		"name": "linkToken",
		"outputs": [
			{
				"internalType": "contract LinkTokenInterface",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "owner",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "router",
		"outputs": [
			{
				"internalType": "contract IRouterClient",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "orderTypeId",
				"type": "uint256"
			},
			{
				"internalType": "string[5]",
				"name": "parameterValues",
				"type": "string[5]"
			},
			{
				"internalType": "bool",
				"name": "isBid",
				"type": "bool"
			}
		],
		"name": "sendOrder",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "beneficiary",
				"type": "address"
			}
		],
		"name": "withdrawLINK",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	}
];