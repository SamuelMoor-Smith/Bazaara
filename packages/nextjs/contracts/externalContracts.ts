// import { addressResolverAbi } from "viem/_types/constants/abis";
// import { CCIP_LOCAL_SIMULATOR_ABI } from "~~/contracts/abis/CCIPLocalSimulator";
// import { CCIP_RECEIVER_UNSAFE_ABI } from "~~/contracts/abis/CCIPReceiver_Unsafe";
// import { CCIP_SENDER_UNSAFE_ABI } from "~~/contracts/abis/CCIPSender_Unsafe";
import { CROSS_CHAIN_NFT_ABI } from "~~/contracts/abis/CrossChainNFT";
import { CROSS_DESTINATION_MINTER_ABI } from "~~/contracts/abis/CrossDestinationMinter";
import { ORDER_HOUSE_ABI } from "~~/contracts/abis/OrderHouse";
// import { CROSS_SOURCE_MINTER_ABI } from "~~/contracts/abis/CrossSourceMinter";
import { ORDER_RECEIVER_ABI } from "~~/contracts/abis/OrderReceiver";
import { ORDER_SENDER_ABI } from "~~/contracts/abis/OrderSender";
import { GenericContractsDeclaration } from "~~/utils/scaffold-eth/contract";

/**
 * @example
 * const externalContracts = {
 *   1: {
 *     DAI: {
 *       address: "0x...",
 *       abi: [...],
 *     },
 *   },
 * } as const;
 */
const externalContracts = {
  11155111: {
    CrossChainNFT: {
      address: "0x99f166D1b7ac90413832FE16b6c7b2408550e830",
      abi: CROSS_CHAIN_NFT_ABI as any,
    },
    CrossDestinationMinter: {
      address: "0xC13801b675235A0B6eE18B33FDeC2E7b4C7eE379",
      abi: CROSS_DESTINATION_MINTER_ABI as any,
    },
  },
  421614: {
    OrderReceiver: {
      address: "0x5874B42b84Cd67FE605D4e951e839D5c21ABdf29",
      abi: ORDER_RECEIVER_ABI as any,
    },
    OrderHouse: {
      address: "0x9bBA902949FD752BB71Ac16745123D70aFC9a38B",
      abi: ORDER_HOUSE_ABI as any,
    },
  },
  43113: {
    OrderSender: {
      address: "0x3D60a720e0C8d45310fc8033dB5Ce7887fc271b3",
      abi: ORDER_SENDER_ABI as any,
    },
  },
} as const;

export default externalContracts satisfies GenericContractsDeclaration;
