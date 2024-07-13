import { CCIP_LOCAL_SIMULATOR_ABI } from "~~/abis/CCIPLocalSimulator";
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
  },
} as const;

export default externalContracts satisfies GenericContractsDeclaration;
