import { CCIP_LOCAL_SIMULATOR_ABI } from "~~/abis/CCIPLocalSimulator";
import { CCIP_RECEIVER_UNSAFE_ABI } from "~~/abis/CCIPReceiver_Unsafe";
import { CCIP_SENDER_UNSAFE_ABI } from "~~/abis/CCIPSender_Unsafe";
import { CROSS_CHAIN_NFT_ABI } from "~~/abis/CrossChainNFT";
import { CROSS_DESTINATION_MINTER_ABI } from "~~/abis/CrossDestinationMinter";
import { CROSS_SOURCE_MINTER_ABI } from "~~/abis/CrossSourceMinter";
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
    CCIPLocalSimulator: {
      address: "0x5B3716F771292fCe9369344C39e37f003c42DbBd",
      abi: CCIP_LOCAL_SIMULATOR_ABI as any,
    },
    CrossChainNFT: {
      address: "0x99f166D1b7ac90413832FE16b6c7b2408550e830",
      abi: CROSS_CHAIN_NFT_ABI as any,
    },
    CrossDestinationMinter: {
      address: "0xC13801b675235A0B6eE18B33FDeC2E7b4C7eE379",
      abi: CROSS_DESTINATION_MINTER_ABI as any,
    },
    CrossSourceMinter: {
      address: "0x36b9D492ED6679FDC48408Ed11a65dC5677E0eF4",
      abi: CROSS_SOURCE_MINTER_ABI as any,
    },
    CCIPSender_Unsafe: {
      address: "0xdEF7b5Ef6369848bc9Cc89B793C4B2197D4c4855",
      abi: CCIP_SENDER_UNSAFE_ABI as any,
    },
    CCIPReceiver_Unsafe: {
      address: "0xd84e040FAE5E20Ddb3ee17Fd05e0CFCa76C78852",
      abi: CCIP_RECEIVER_UNSAFE_ABI as any,
    },
  },
} as const;

export default externalContracts satisfies GenericContractsDeclaration;
