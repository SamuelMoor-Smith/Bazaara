# Bazaara

Bazaara uses Chainlink's CCIP protocol to pass structured order messages to a central router contract on Arbitrum, taking advantage of it's low-cost execution environment. A Sender and Receiver contract are set up on each chain, where receivers double as applications that are directly referred to by the execution logic of the matching engine. 

The Orderhouse contract takes in a set of parameters from both sides of the order markets for it's precise types. Order types represent markets, and are declared by detailing the nature of the parameters and how they are used to form the matching logic. They also describe the call function and parameters that need to be used to be returned to the execution chain of its choice. This is what enables Orderhouse to be flexible in where and how orders filter through the system. Anyone can call the matching function, and future incentives may be implemented to facilitate swift market making. 

Most applications are marketplaces, where supply meets demand with the help of market-making agents. However, each application on each blockchain typically spins up their own infrastructure and set of resolvers, making them incompatible with each other. 

Bazaara solves this in 2 steps. First, Bazaara uses Chainlink's CCIP protocol to route orderflow through a central hub, Arbitrum. This concentrates liquidity and centers the scope of operation of any market-makers. CCIP makes it easy to continue the routing of transactions to its final destination, making it a seamless experience for users. Bazaara currently connect Ethereum, Optimism, and Avalanche's respective testnets. 

Second, Bazaara implements a open set of parameters, matching logic, and execution logic so markets can be established to best suit their needs. The goal is to enable a wise range of use cases, all being facilitated by the same order-matching contract. Currently, Bazaara hosts both a NFT minting engine and Beneficiary assignment contract through the same matching and message parsing system. This is all while keeping the resolver requirements at a bare minimum, with the right matching of transaction IDs being sufficient to execute matches to its final destinations. 

⚙️ Built using eth-scaffold (ie. NextJS, RainbowKit, Hardhat, Wagmi, Viem, and Typescript).

## Requirements

Before you begin, you need to install the following tools:

- [Node (>= v18.17)](https://nodejs.org/en/download/)
- Yarn ([v1](https://classic.yarnpkg.com/en/docs/install/) or [v2+](https://yarnpkg.com/getting-started/install))
- [Git](https://git-scm.com/downloads)

## Quickstart

To get started with Bazaara, follow the steps below:

1. Clone this repo & install dependencies

```
yarn install
```

2. Start your NextJS app:

```
yarn start
```

Visit your app on: `http://localhost:3000`. You can interact with the smart contracts using the `Debug Contracts` page. 
