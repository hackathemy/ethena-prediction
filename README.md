# ETHENA Predcition
Play stably in an extreme and optimistic prediction space.

#### [Platform]() | [Demo Video]() | [Pitchdeck]()

## Motivation
> **A New Approach to Prediction Markets**
  - Rather than solving existing problems or focusing on specific limitations of current prediction markets, we are driven by the opportunity to explore and expand the marketability of this space.
  - Our aim is to innovate within the prediction market domain by leveraging emerging trends and technologies.

> **Inspired by Polymarket, Enhanced by Ethena**
  - Inspired by popular and trendy services like Polymarket, we are developing a prediction market within the **`Ethena ecosystem`**.
  - By incorporating various advanced technologies, we aim to differentiate our platform and offer users a unique experience.

> **Delivering an Advanced and Enjoyable Service**
  - Through **`Ethena Prediction`**, we showcase the technical capabilities of the Ethena ecosystem.
  - While maintaining familiar elements, we integrate diverse Web3 technologies to provide a more engaging and advanced prediction market service that sets us apart from existing solutions.

## Features

### Smart Contract
#### [Ethena]() | [LayerZero]() | [Goldsky]()

## Structure
![image](https://github.com/user-attachments/assets/4bc021ee-1692-4a7c-9043-11a955ab3fde)

```mermaid
sequenceDiagram
    participant Admin
    participant User
    participant Ethena-PredictionContract
    participant NFT-Market
    participant sUSDeContract

    Admin->>Ethena-PredictionContract: 1. create Game
    User->>Ethena-PredictionContract: 2. Bet with Approve USDe Token
    Ethena-PredictionContract->>sUSDeContract: 3. Bet Money (USDe) deposit
    sUSDeContract->>Ethena-PredictionContract: 4. send sUSDe
    Ethena-PredictionContract-->>User: 2-@. Mint ERC1155 Token
    User<<-->>NFT-Market: +@. NFT (Optional)
    Admin->>Ethena-PredictionContract: 5. End Bet
    User<<-->>NFT-Market: +@. Trade NFT (Optional)
    Admin->>Ethena-PredictionContract: 5. End Game
    Ethena-PredictionContract->>NFT-Market: 6. CooldownShares
    Ethena-PredictionContract->>sUSDeContract: 6. Unstake
    User<<-->>Ethena-PredictionContract: 7. Claim
```

## Target
1. **Extreme Users**  
   - **Details:** Users who enjoy exploring new things.  
   - **Description:** A fun prediction platform designed for adventurous commercial users who fearlessly explore new Web3 ecosystem services and enjoy extreme and entertaining experiences.  

2. **Traders**  
   - **Details:** Specialists in long/short positions and investments.  
   - **Description:** A prediction trading space tailored for traders who analyze charts of various coins and invest in existing exchanges (futures, spot, fiat currencies). It also caters to users looking to trade new products in Web3 ecosystems like DeFi, PumpFun, and PolyMarket to generate profits.  

3. **Ethena Users**  
   - **Details:** Existing users of the Ethena ecosystem.  
   - **Description:** A prediction trading platform that increases liquidity by leveraging the existing Ethena ecosystem. It provides new income opportunities for users through various re-staking services powered by USDe.

## Business Model

<details>
<summary>
  Foundry
</summary>
<div markdown="1">

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/ethenaPredict.s.sol --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
</div>
</details>
