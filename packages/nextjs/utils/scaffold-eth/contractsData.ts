// import scaffoldConfig from "~~/scaffold.config";
import { contracts } from "~~/utils/scaffold-eth/contract";

export function getAllContracts(chainId: number | undefined) {
  if (!chainId) return {};
  const contractsData = contracts?.[chainId];
  return contractsData ? contractsData : {};
}
