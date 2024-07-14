export const ORDER_RECEIVER_ABI = [
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
			}
		],
		"name": "createAskOrder",
		"outputs": [],
		"stateMutability": "nonpayable",
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
			}
		],
		"name": "createBidOrder",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	}
];