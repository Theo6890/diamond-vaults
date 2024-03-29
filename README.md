# <h1 align="center"> Diamond Vaults </h1>

The goal of this repository is to implement the diamond pattern (ERC-2535) through DeFi vaults.

# Technical Specifications

## Diamond Pattern

All vaults will use the same diamond to store their common data. A vault is a facet of a diamond, as there can be many types of vault with different logic implementation. <br>

Explanation with a dummy diagram:
![witeboard_Diamond_Vaults_schema](https://user-images.githubusercontent.com/37904797/211539762-67c785fc-604d-4cee-a8f3-2991b49bca4d.png)

### Facet's Storage

A facet can also have a specific proxy storage (eternal storage, another diamonds stockage, etc...). This will depend on the evolution of the dApp complexity throught development lifecycle.

### Split Heavy Features into Many Diamonds

For greater compasability and module oriented project, a new diamond can be create for each these features: DEXs Integration, Royalities Integration, Streaming Payment Protocol, Streaming Payment Configuration, Multisigs Integration, etc...

## Solidstate Layout

An overview of the uses of each visibility layer is as follows:

| **folder**   | **layer**           | **contents**                                                                | **description**                                                                                                                                                                                                                   | **example**                                                                            |
| ------------ | ------------------- | --------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| **-**        | `interface`         | `enum`, `struct`, `event`, custom `error`, `modifier` & function prototypes | defines anything a child contract needs (even in `IxyzInternal.sol`) to split code in independent modules                                                                                                                         | `IRandomnessWritableInternal.sol`, `IRandomnessFallback.sol`, `IRandomnessReadble.sol` |
| **fallback** | external            | any function visibility                                                     | set of functions, which are **only** used when a callback is made to the diamond (e.g. `VRFConsumerBaseV2.fulfillRandomWords`). It can modify and/or read the state, which is why it can be nor in `readable` or `writable` only. | `RandomnessFallback.sol`                                                               |
| **readable** | external            | external or public functions                                                | set of functions that defines a module's getters                                                                                                                                                                                  | `RandomnessReadable.sol`                                                               |
| **writable** | external & internal | any function visibility                                                     | set of functions that defines a module's core logic; internal function always declares as `xyzWritableInternal.sol`                                                                                                               | `RandomnessInternalWritable.sol`, `RandomnessWritable.sol`                             |
| **./**       | storage             | internal library functions, structs                                         | library for accessing and modifying storage; useful when sharing access to storage between implementation contracts that will be deployed separately (such as in the "diamond" proxy architecture)                                | `RandomnessStorage.sol`                                                                |

## Versions

Commits format & version naming: https://r-code.notion.site/Commits-and-versions-bedeee671dec446aa4f8688bc2d9db8c

### Vault Common Specifications

-   **Yields percentage and timelock** varies from vaults to vaults
    -   Generally speaking the longest you lock, the highest the rewards
-   Deposit automatically timelock the transfered amount of ETH/tokens
-   Receive proportional amount of shares depending on the ETH/tokens amount deposited
-   Yields are by default paid in RCODE (project token)
-   Claim rewards after the time setup by the vault, otherwise earn yield as soon as ETH/tokens are deposited

_Note: in diamond storage for deposited balance, save the deposited type (native ETH, tokens, NFTs) and sub-type (e.g. ERC-20, ERC-777, ERC-721, ERC-1155...)_

### v0.1.0: ETH Vaults

-   Deposit ETH & mint shares through a dedicated function
-   Withdraw ETH & burn shares through a dedicated function

### v1.0.0: Add ERC20 Vaults Suuport

-   Deposit whitelisted ERC20 & mint shares through a dedicated function
-   Withdraw whitelisted ERC20 & burn shares through a dedicated function
-   Deposit using permit function for gas optimisation:
    -   Deposit tokens
    -   _Other actions: TO LIST_

#### v1.1.0: DEXs Integration

Will surely use Uniswap, maybe 1inch.

-   Support whitelisted LP tokens to earn yields
-   Connect DEXs to manage on-chain swap:
    -   claim rewards and swap them (if possible) in the given array of token(s)
    -   direct LP tokens swap: add liquidity on DEXs & deposit LP token in the vault for yields

### v2.0.0: NFT Vaults & Royalities

-   Support whitelisted NFT collections in vaults
-   Percentage of earned rewards will be paid to NFT creator as royalties

#### _Questions_

-   _RFT integration?_

### v3.0.0: Streaming Payment Protocol

Integrate [sablier.finance](http://sablier.finance) or [superfluid](https://www.superfluid.finance).
Maybe later both of them.

-   Pay rewards in real time if the user set it up:
    -   each address/user must configure to enable (disabled by default)
    -   default config for all vaults
    -   one configuration
    -   forward rewards to another wallet
    -   timeframe payment

#### _Questions_

-   _Swap rewards & stream payment_

### v4.0.0: Multisig Vaults

-   Some vaults only useable with/by multisig

#### _Questions_

-   _Can Safe multisig interact with our contract without any extra code? If not implement it (Safe plugins?)_
-   _Can a multisig by the owner to manage upgrades of anything without any extra code? If not implement it (Safe plugins?)_

## EIPs To Use

### v0.1.0

-   2535: dimaonds
-   4626: vault

### v1.0.0

-   2612: permit (off-chain approval)

### v2.0.0

-   195 & 1820: interfaces registries
-   2981: NFT royalities

### v3.0.0

-   _EIPs for streaming payments?_

### v4.0.0

-   _EIPs for multisigs?_

# Best Practices to Follow

## Generics

-   Code formatter & linter: prettier, solhint, husky, lint-staged & husky
-   [Foundry](https://book.getfoundry.sh/tutorials/best-practices)

## Security

-   [Solidity Patterns](https://github.com/fravoll/solidity-patterns)
-   [Solcurity Codes](https://github.com/transmissions11/solcurity)
-   Secureum posts _([101](https://secureum.substack.com/p/security-pitfalls-and-best-practices-101) & [101](https://secureum.substack.com/p/security-pitfalls-and-best-practices-201): Security Pitfalls & Best Practice)_
-   [Smart Contract Security Verification Standard](https://github.com/securing/SCSVS)
    -   V1: Architecture, Design and Threat Modelling
    -   V2: Access Control
    -   V3: Blockchain Data
    -   V4: Communications
    -   V5: Arithmetic
    -   V6: Malicious Input Handling
    -   V7: Gas Usage & Limitations
    -   V8: Business Logic
    -   V9: Denial of Service
    -   V10: Token
    -   V11: Code Clarity
    -   V12: Test Coverage
    -   V13: Known Attacks
    -   V14: Decentralized Finance
-   [SWC](https://swcregistry.io)

# Be Prepared For Audits

-   Well refactored & commented code (NatSpec comment & [PlantUML](https://plantuml.com/starting))
-   Unit ([TDD](https://r-code.notion.site/TDDs-steps-cecba0a82ee6466f9f479ca553949be2)) & integration (BDD) tests (green)
-   _Paper code review (architecture & conception tests) - not required for this project_
-   Use auditing tools (internally)
    -   Secureum articles
        -   [Audit Techniques & Tools 101](https://secureum.substack.com/p/audit-techniques-and-tools-101)
        -   [Audit Findings 101](https://secureum.substack.com/p/audit-findings-101)
        -   [Audit Findings 201](https://secureum.substack.com/p/audit-findings-201)
    -   Formal verification testing: solidity smt & else
    -   Fuzz testing (echidna): (semi-)random inputs
    -   Static analysers (mythril, slither)
    -   Differential Testing
    -   MythX (report)
    -   Etc.. (rattle, etheno, surya…)
        -   invariant testing
        -   symbolic execution
        -   mutation testing
