export const CCIP_LOCAL_SIMULATOR_ABI = [
	{
		"inputs": [],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"inputs": [],
		"name": "configuration",
		"outputs": [
			{
				"internalType": "uint64",
				"name": "chainSelector_",
				"type": "uint64"
			},
			{
				"internalType": "contract IRouterClient",
				"name": "sourceRouter_",
				"type": "address"
			},
			{
				"internalType": "contract IRouterClient",
				"name": "destinationRouter_",
				"type": "address"
			},
			{
				"internalType": "contract WETH9",
				"name": "wrappedNative_",
				"type": "address"
			},
			{
				"internalType": "contract LinkToken",
				"name": "linkToken_",
				"type": "address"
			},
			{
				"internalType": "contract BurnMintERC677Helper",
				"name": "ccipBnM_",
				"type": "address"
			},
			{
				"internalType": "contract BurnMintERC677Helper",
				"name": "ccipLnM_",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint64",
				"name": "chainSelector",
				"type": "uint64"
			}
		],
		"name": "getSupportedTokens",
		"outputs": [
			{
				"internalType": "address[]",
				"name": "tokens",
				"type": "address[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint64",
				"name": "chainSelector",
				"type": "uint64"
			}
		],
		"name": "isChainSupported",
		"outputs": [
			{
				"internalType": "bool",
				"name": "supported",
				"type": "bool"
			}
		],
		"stateMutability": "pure",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			}
		],
		"name": "requestLinkFromFaucet",
		"outputs": [
			{
				"internalType": "bool",
				"name": "success",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "tokenAddress",
				"type": "address"
			}
		],
		"name": "supportNewToken",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	}
];
  