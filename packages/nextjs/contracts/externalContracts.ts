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
    OrderSender: {
      address: "0x0Be5829B093499031Bb4Eee8451B36d008Be3b86",
      abi: ORDER_SENDER_ABI as any,
    },
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
      address: "0x5A71Fcd71594A3fDb47E8e7d8236576e3C8Caa20",
      abi: ORDER_RECEIVER_ABI as any,
    },
    OrderHouse: {
      address: "0x847618cFd45394CE38529e06cf7C54d740AF22F4",
      abi: ORDER_HOUSE_ABI as any,
    },
  },
  43113: {
    OrderSender: {
      address: "0x90E221187db1ead78C97a4Af751c2e725421e487",
      abi: ORDER_SENDER_ABI as any,
    },
  },
} as const;

export default externalContracts satisfies GenericContractsDeclaration;
