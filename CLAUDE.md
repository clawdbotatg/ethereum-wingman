# Ethereum Wingman - Claude Code Instructions

This project is a comprehensive Ethereum development skill/knowledge base for AI agents.

## Project Overview

Ethereum Wingman teaches:
1. **SpeedRun Ethereum challenges** - Hands-on learning modules
2. **Scaffold-ETH 2 tooling** - Full-stack dApp development
3. **DeFi protocols** - Uniswap, Aave, Compound patterns
4. **Security best practices** - Gotchas, historical hacks, checklists

## Directory Structure

```
ethereum-wingman/
├── knowledge/
│   ├── challenges/     # SpeedRun Ethereum TLDR modules
│   ├── protocols/      # DeFi protocol documentation
│   ├── standards/      # ERC standards (20, 721, 1155, 4626)
│   ├── foundations/    # Ethereum/Solidity basics
│   └── gotchas/        # Critical gotchas and historical hacks
├── tools/
│   ├── scaffold-eth/   # Scaffold-ETH 2 workflows
│   ├── deployment/     # MCP reference, dApp patterns
│   └── security/       # Pre-production checklist
├── prompts/
│   ├── tutor.md        # Teaching mode
│   ├── review.md       # Code review mode
│   ├── debug.md        # Debugging assistant
│   └── build.md        # Project building mode
├── skill.json          # Skill manifest
├── .cursorrules        # Cursor IDE rules
└── CLAUDE.md           # This file
```

## Key Files to Reference

### When Teaching Concepts
- `knowledge/challenges/` - Comprehensive modules for each concept
- `knowledge/foundations/` - Fundamentals for beginners
- `knowledge/standards/` - ERC standard details

### When Building Projects
- `tools/scaffold-eth/getting-started.md` - Project setup
- `tools/scaffold-eth/hooks-reference.md` - Frontend hooks
- `tools/deployment/full-stack-patterns.md` - Common dApp patterns

### When Reviewing Code
- `knowledge/gotchas/critical-gotchas.md` - Must-check vulnerabilities
- `knowledge/gotchas/historical-hacks.md` - Real exploit examples
- `tools/security/pre-production-checklist.md` - Complete security review

## 🚨 THE MOST IMPORTANT CONCEPT 🚨

**NOTHING IS AUTOMATIC ON ETHEREUM.**

Smart contracts cannot execute themselves. For any function that "needs to happen":
1. Make it callable by **ANYONE** (not just admin)
2. Give callers a **REASON** (profit, reward, their own interest)  
3. Make the incentive **SUFFICIENT** to cover gas + profit

**Always ask: "Who calls this? Why would they pay gas?"**

See `knowledge/foundations/automation-and-incentives.md` for deep dive.

## Critical Gotchas (Memorize These)

1. **Token Decimals**: USDC = 6 decimals, not 18
2. **Approve Pattern**: Required for token transfers to contracts
3. **Reentrancy**: CEI pattern + ReentrancyGuard
4. **Oracles**: Never use DEX spot prices
5. **No Floats**: Use basis points (500/10000 = 5%)

## Response Guidelines

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

### For Building
1. Clarify requirements
2. Suggest architecture
3. Provide starter code
4. Note security considerations
5. Guide through deployment

## MCP Integration

When eth-mcp is available, use these tools:
- `stack_init` / `stack_start` - Project management
- `addresses_getToken` / `addresses_getProtocol` - Address lookup
- `defi_getYields` - Yield data
- `education_getChecklist` - Lesson checklists
- `frontend_validateAll` - Code validation
