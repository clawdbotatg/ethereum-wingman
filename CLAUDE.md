# Ethereum Wingman - Claude Code Instructions

This project is a comprehensive Ethereum development skill/knowledge base for AI agents.

---

## AI AGENT INSTRUCTIONS - READ THIS FIRST

### Default Stack: Scaffold-ETH 2 with Fork Mode

When a user wants to BUILD any Ethereum project, follow these steps:

**Step 1: Create Project**

```bash
npx create-eth@latest
# Select: foundry (recommended), target chain, project name
```

**Step 2: Install & Fork a Live Network**

```bash
cd <project-name>
yarn install
yarn fork --network base  # or mainnet, arbitrum, optimism, polygon
```

**Step 3: Deploy to Local Fork (FREE!)**

```bash
yarn deploy
```

**Step 4: Start Frontend**

```bash
yarn start
```

**Step 5: Test the Frontend**

After the frontend is running, open a browser and test the app:

1. **Navigate** to `http://localhost:3000`
2. **Take a snapshot** to get page elements (burner wallet address is in header)
3. **Click the faucet** to fund the burner wallet with ETH
4. **Transfer tokens** from whales if needed (use burner address from page)
5. **Click through the app** to verify functionality

Use the `cursor-browser-extension` MCP tools for browser automation.
See `tools/testing/frontend-testing.md` for detailed workflows.

### DO NOT:

- Run `yarn chain` (use `yarn fork --network <chain>` instead!)
- Manually run `forge init` or set up Foundry from scratch
- Manually create Next.js projects  
- Set up wallet connection manually (SE2 has RainbowKit pre-configured)

### Why Fork Mode?

```
yarn chain (WRONG)              yarn fork --network base (CORRECT)
└─ Empty local chain            └─ Fork of real Base mainnet
└─ No protocols                 └─ Uniswap, Aave, etc. available
└─ No tokens                    └─ Real USDC, WETH exist
└─ Testing in isolation         └─ Test against REAL state
```

### Auto Block Mining (Prevent Timestamp Drift)

When you fork a chain, block timestamps are FROZEN at the fork point. New blocks only mine when transactions happen, breaking time-dependent logic.

**Solution**: After starting the fork, enable interval mining:

```bash
# Enable auto block mining (1 block/second)
cast rpc anvil_setIntervalMining 1
```

---

## Project Overview

Ethereum Wingman teaches:
1. **SpeedRun Ethereum challenges** - Hands-on learning modules
2. **Scaffold-ETH 2 tooling** - Full-stack dApp development with fork mode
3. **DeFi protocols** - Uniswap, Aave, Compound patterns
4. **Security best practices** - Gotchas, historical hacks, checklists

---

## Directory Structure

```
ethereum-wingman/
├── data/
│   └── addresses/          # Token, protocol, whale addresses per chain
│       ├── tokens.json
│       ├── protocols.json
│       └── whales.json
├── knowledge/
│   ├── challenges/         # SpeedRun Ethereum TLDR modules
│   ├── protocols/          # DeFi protocol documentation
│   ├── standards/          # ERC standards (20, 721, 1155, 4626)
│   ├── foundations/        # Ethereum/Solidity basics
│   └── gotchas/            # Critical gotchas and historical hacks
├── tools/
│   ├── scaffold-eth/       # Scaffold-ETH 2 workflows
│   ├── deployment/         # dApp patterns
│   ├── testing/            # Frontend testing with browser automation
│   └── security/           # Pre-production checklist
├── prompts/
│   ├── tutor.md            # Teaching mode
│   ├── review.md           # Code review mode
│   ├── debug.md            # Debugging assistant
│   └── build.md            # Project building mode (fork workflow)
├── AGENTS.md               # Main AI agent instructions
├── .cursorrules            # Cursor IDE rules
└── CLAUDE.md               # This file
```

---

## Key Files to Reference

### When Building Projects
- `prompts/build.md` - Complete build workflow with fork mode
- `data/addresses/` - Token and protocol addresses per chain
- `tools/scaffold-eth/getting-started.md` - Project setup details

### When Teaching Concepts
- `knowledge/challenges/` - Comprehensive modules for each concept
- `knowledge/foundations/` - Fundamentals for beginners
- `knowledge/standards/` - ERC standard details

### When Reviewing Code
- `knowledge/gotchas/critical-gotchas.md` - Must-check vulnerabilities
- `knowledge/gotchas/historical-hacks.md` - Real exploit examples
- `tools/security/pre-production-checklist.md` - Complete security review

---

## THE MOST IMPORTANT CONCEPT

**NOTHING IS AUTOMATIC ON ETHEREUM.**

Smart contracts cannot execute themselves. For any function that "needs to happen":
1. Make it callable by **ANYONE** (not just admin)
2. Give callers a **REASON** (profit, reward, their own interest)  
3. Make the incentive **SUFFICIENT** to cover gas + profit

**Always ask: "Who calls this? Why would they pay gas?"**

See `knowledge/foundations/automation-and-incentives.md` for deep dive.

---

## Critical Gotchas (Memorize These)

1. **Token Decimals**: USDC = 6 decimals, not 18
2. **Approve Pattern**: Required for token transfers to contracts
3. **Reentrancy**: CEI pattern + ReentrancyGuard
4. **Oracles**: Never use DEX spot prices
5. **No Floats**: Use basis points (500/10000 = 5%)

---

## Address Data

Pre-compiled addresses in `data/addresses/`:

**tokens.json** - Token addresses per chain:
- Base: WETH, USDC, DAI, cbETH, wstETH, etc.
- Mainnet: WETH, USDC, USDT, DAI, stETH, etc.
- Arbitrum: WETH, USDC, ARB, GMX, etc.
- Optimism: WETH, USDC, OP, VELO, etc.

**protocols.json** - Protocol addresses per chain:
- Uniswap V3/V4
- Aave V3
- Chainlink price feeds
- Permit2, Multicall, Safe, etc.

**whales.json** - Large token holders for test funding:
- Includes cast commands to fund wallets on forks

---

## Response Guidelines

### For Building
1. **Start with fork workflow** - Always `yarn fork`, never `yarn chain`
2. Set up Scaffold-ETH 2 project
3. Clarify requirements
4. Suggest architecture
5. Provide starter code
6. Note security considerations
7. Guide through deployment
8. **Test the frontend** - Open browser, fund burner wallet, click through app

### For Teaching
1. Start with the concept explanation
2. Show a code example
3. Mention security considerations
4. Reference relevant SpeedRun challenge
5. Suggest next steps

### For Code Review
1. Check access control
2. Look for reentrancy vectors
3. Verify token handling
4. Assess oracle usage
5. Validate math precision

---

## Funding Test Wallets on Fork

```bash
# Give whale ETH for gas
cast rpc anvil_setBalance 0xBBBBBbbBBb9cC5e90e3b3Af64bdAF62C37EEFFCb 0x56BC75E2D63100000

# Impersonate Morpho Blue (USDC whale on Base)
cast rpc anvil_impersonateAccount 0xBBBBBbbBBb9cC5e90e3b3Af64bdAF62C37EEFFCb

# Transfer 10,000 USDC (6 decimals)
cast send 0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913 \
  "transfer(address,uint256)" YOUR_ADDRESS 10000000000 \
  --from 0xBBBBBbbBBb9cC5e90e3b3Af64bdAF62C37EEFFCb --unlocked
```

See `data/addresses/whales.json` for whale addresses on all chains.
