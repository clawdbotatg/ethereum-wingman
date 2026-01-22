# Ethereum Wingman

A comprehensive Ethereum development skill for AI coding agents. Provides security warnings, DeFi protocol guidance, and the critical gotchas that prevent costly mistakes.

## Installation

```bash
npx skills add austintgriffith/ethereum-wingman
```

### ⚠️ REQUIRED: Extra Step for Cursor Users

**Cursor doesn't support the Agent Skills spec yet!** It ignores `.cursor/skills/` and only reads `.cursorrules`.

After installing the skill, run this command in your project:

```bash
ln -sf .agents/skills/ethereum-wingman/AGENTS.md .cursorrules
```

This creates a symlink so your `.cursorrules` stays updated when the skill updates.

> **Why is this needed?** The `skills.sh` installer puts skills in `.cursor/skills/` but Cursor doesn't scan that directory. This is a known gap in the ecosystem - Cursor hasn't implemented the [Agent Skills spec](https://agentskills.io/integrate-skills) yet.

## What It Does

This skill enhances AI agents with deep knowledge of:

- **SpeedRun Ethereum Challenges** - Hands-on learning curriculum
- **Scaffold-ETH 2 Tooling** - Full-stack dApp development
- **DeFi Protocol Integration** - Uniswap, Aave, Chainlink patterns
- **Security Best Practices** - Critical gotchas and historical hacks

## The Most Important Concept

**🚨 NOTHING IS AUTOMATIC ON ETHEREUM 🚨**

Smart contracts cannot execute themselves. For any function that "needs to happen":

1. Make it callable by **ANYONE**
2. Give callers a **REASON** (profit, reward)
3. Make the incentive **SUFFICIENT**

**Always ask: "Who calls this function? Why would they pay gas?"**

## Critical Gotchas

1. **Token Decimals** - USDC has 6 decimals, not 18!
2. **Approve Pattern** - Required for ERC-20 token transfers
3. **Reentrancy** - Use CEI pattern + ReentrancyGuard
4. **Oracle Security** - Never use DEX spot prices
5. **No Floats** - Use basis points (500 = 5%)
6. **Vault Inflation** - Protect first depositors

## Trigger Phrases

The skill activates when you mention:
- "build a dApp"
- "create smart contract"
- "help with Solidity"
- "SpeedRun Ethereum"
- Any Ethereum/DeFi development task

## Scripts

### Initialize Project
```bash
bash scripts/init-project.sh my-dapp base
```

### Check for Gotchas
```bash
bash scripts/check-gotchas.sh ./contracts
```

## MCP Integration

For the full experience with eth-mcp tools:
- Project scaffolding: `stack_init`, `stack_start`
- Address lookup: `addresses_getToken`, `addresses_getProtocol`
- DeFi data: `defi_getYields`, `defi_compareYields`
- Education: `education_getChecklist`, `education_getCriticalLessons`

## Resources

- [SpeedRun Ethereum](https://speedrunethereum.com/)
- [Scaffold-ETH 2](https://scaffoldeth.io/)
- [BuidlGuidl](https://buidlguidl.com/)

## License

MIT License - Use freely for learning and building.
