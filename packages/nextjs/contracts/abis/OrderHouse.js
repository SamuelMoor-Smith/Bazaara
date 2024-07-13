export const ORDER_HOUSE_ABI = [
	{
		"inputs": [],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "orderId",
				"type": "uint256"
			},
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "orderTypeId",
				"type": "uint256"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "creator",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "isBid",
				"type": "bool"
			}
		],
		"name": "OrderCreated",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "orderTypeId",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "name",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "functionSignature",
				"type": "string"
			}
		],
		"name": "OrderTypeCreated",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "bidOrderId",
				"type": "uint256"
			},
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "askOrderId",
				"type": "uint256"
			}
		],
		"name": "OrdersMatched",
		"type": "event"
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
		"name": "createAskOrder",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
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
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "name",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "functionSignature",
				"type": "string"
			},
			{
				"internalType": "string[5]",
				"name": "supplierParameters",
				"type": "string[5]"
			},
			{
				"internalType": "string[5]",
				"name": "bidderParameters",
				"type": "string[5]"
			},
			{
				"internalType": "uint256[5]",
				"name": "bidParameterIndices",
				"type": "uint256[5]"
			},
			{
				"internalType": "uint256[5]",
				"name": "askParameterIndices",
				"type": "uint256[5]"
			},
			{
				"internalType": "string[5]",
				"name": "relationships",
				"type": "string[5]"
			},
			{
				"internalType": "string[5]",
				"name": "valueTypes",
				"type": "string[5]"
			}
		],
		"name": "createOrderType",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "orderId",
				"type": "uint256"
			}
		],
		"name": "getOrder",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "orderTypeId",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "creator",
				"type": "address"
			},
			{
				"internalType": "string[5]",
				"name": "parameterKeys",
				"type": "string[5]"
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
			},
			{
				"internalType": "string",
				"name": "status",
				"type": "string"
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
			}
		],
		"name": "getOrderType",
		"outputs": [
			{
				"internalType": "string",
				"name": "name",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "functionSignature",
				"type": "string"
			},
			{
				"internalType": "string[5]",
				"name": "supplierParameters",
				"type": "string[5]"
			},
			{
				"internalType": "string[5]",
				"name": "bidderParameters",
				"type": "string[5]"
			},
			{
				"internalType": "uint256[5]",
				"name": "bidParameterIndices",
				"type": "uint256[5]"
			},
			{
				"internalType": "uint256[5]",
				"name": "askParameterIndices",
				"type": "uint256[5]"
			},
			{
				"internalType": "string[5]",
				"name": "relationships",
				"type": "string[5]"
			},
			{
				"internalType": "string[5]",
				"name": "valueTypes",
				"type": "string[5]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "bidOrderId",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "askOrderId",
				"type": "uint256"
			}
		],
		"name": "matchOrders",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	}
];