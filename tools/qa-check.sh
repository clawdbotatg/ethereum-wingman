#!/bin/bash
# qa-check.sh — Scaffold-ETH 2 Frontend QA Scanner
# Run against a SE2 project directory to catch common issues
# Usage: qa-check.sh /path/to/project

set -euo pipefail

PROJECT="${1:-.}"
NEXTJS="$PROJECT/packages/nextjs"
ERRORS=0
WARNINGS=0

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'

fail() { echo -e "${RED}❌ FAIL:${NC} $1"; ((ERRORS++)); }
warn() { echo -e "${YELLOW}⚠️  WARN:${NC} $1"; ((WARNINGS++)); }
pass() { echo -e "${GREEN}✅ PASS:${NC} $1"; }

echo "========================================="
echo "  Scaffold-ETH 2 QA Check"
echo "  Project: $PROJECT"
echo "========================================="
echo ""

# Check project structure
if [ ! -d "$NEXTJS" ]; then
    fail "No packages/nextjs directory found"
    exit 1
fi

# -------------------------------------------
# 1. RPC Configuration
# -------------------------------------------
echo "--- RPC Configuration ---"

CONFIG="$NEXTJS/scaffold.config.ts"
if [ -f "$CONFIG" ]; then
    if grep -q "rpcOverrides" "$CONFIG"; then
        pass "rpcOverrides found in scaffold.config.ts"
    else
        fail "No rpcOverrides in scaffold.config.ts — will use public RPCs!"
    fi

    if grep -q "pollingInterval.*3000" "$CONFIG"; then
        pass "pollingInterval set to 3000"
    elif grep -q "pollingInterval" "$CONFIG"; then
        warn "pollingInterval found but not 3000 — check the value"
    else
        warn "No pollingInterval found — using default (may be too slow or missing)"
    fi

    if grep -rq "mainnet\.base\.org" "$NEXTJS/"; then
        fail "Found 'mainnet.base.org' in code — NEVER use public Base RPC"
    else
        pass "No public Base RPC found"
    fi
else
    fail "scaffold.config.ts not found"
fi

echo ""

# -------------------------------------------
# 2. OG / Twitter Card Meta
# -------------------------------------------
echo "--- Open Graph / Twitter Cards ---"

LAYOUT="$NEXTJS/app/layout.tsx"
if [ -f "$LAYOUT" ]; then
    if grep -q "openGraph" "$LAYOUT"; then
        pass "openGraph metadata found"
    else
        fail "No openGraph metadata in layout.tsx — links won't unfurl"
    fi

    if grep -q "twitter" "$LAYOUT"; then
        pass "Twitter card metadata found"
    else
        fail "No Twitter card metadata in layout.tsx"
    fi

    if grep -q "summary_large_image" "$LAYOUT"; then
        pass "Twitter card type is summary_large_image"
    else
        warn "Twitter card type might not be summary_large_image"
    fi

    # Check for localhost or relative URLs in OG images
    if grep -E "images.*localhost|images.*\"/[^h]" "$LAYOUT" 2>/dev/null; then
        fail "OG/Twitter image URL appears to be localhost or relative — MUST be absolute live URL"
    else
        pass "No obvious localhost/relative image URLs"
    fi

    # Check for default SE2 text
    if grep -q "Scaffold-ETH 2" "$LAYOUT"; then
        warn "Found 'Scaffold-ETH 2' in layout.tsx — update title/description from defaults"
    fi
else
    fail "app/layout.tsx not found"
fi

echo ""

# -------------------------------------------
# 3. Address Display
# -------------------------------------------
echo "--- Address Display ---"

# Look for raw hex address rendering in TSX files
RAW_ADDR=$(grep -rn "0x[a-fA-F0-9]\{40\}" "$NEXTJS/app/" "$NEXTJS/components/" 2>/dev/null \
    | grep -v "node_modules" \
    | grep -v ".next/" \
    | grep -v "Address" \
    | grep -v "address:" \
    | grep -v "contractAddress" \
    | grep -v "import" \
    | grep -v "const.*=" \
    | grep -v "//.*0x" \
    || true)

if [ -n "$RAW_ADDR" ]; then
    warn "Possible raw address rendering (should use <Address/>):"
    echo "$RAW_ADDR" | head -5
else
    pass "No obvious raw address rendering found"
fi

echo ""

# -------------------------------------------
# 4. Button Loading States
# -------------------------------------------
echo "--- Button Loading States ---"

# Check for shared isLoading with multiple buttons
SHARED_LOADING=$(grep -rn "isLoading" "$NEXTJS/app/" "$NEXTJS/components/" 2>/dev/null \
    | grep -v "node_modules" \
    | grep -v ".next/" \
    || true)

LOADING_COUNT=$(echo "$SHARED_LOADING" | grep -c "isLoading" 2>/dev/null || echo "0")
if [ "$LOADING_COUNT" -gt 4 ]; then
    warn "Found $LOADING_COUNT references to 'isLoading' — check for shared loading state across multiple buttons"
fi

# Check for buttons without disabled prop
BUTTONS_NO_DISABLE=$(grep -rn "<button" "$NEXTJS/app/" "$NEXTJS/components/" 2>/dev/null \
    | grep -v "node_modules" \
    | grep -v ".next/" \
    | grep -v "disabled" \
    || true)

if [ -n "$BUTTONS_NO_DISABLE" ]; then
    BUTTON_COUNT=$(echo "$BUTTONS_NO_DISABLE" | wc -l | tr -d ' ')
    if [ "$BUTTON_COUNT" -gt 0 ]; then
        warn "Found $BUTTON_COUNT <button> elements without 'disabled' prop — onchain buttons need loading states:"
        echo "$BUTTONS_NO_DISABLE" | head -5
    fi
else
    pass "All buttons appear to have disabled prop"
fi

echo ""

# -------------------------------------------
# 5. Footer / README Defaults
# -------------------------------------------
echo "--- Default Content ---"

FOOTER="$NEXTJS/components/Footer.tsx"
if [ -f "$FOOTER" ] && grep -q "scaffold-eth/se-2" "$FOOTER"; then
    warn "Footer still links to scaffold-eth/se-2 — update to your repo"
fi

README="$PROJECT/README.md"
if [ -f "$README" ] && grep -q "Scaffold-ETH 2" "$README" && grep -q "npx create-eth" "$README"; then
    warn "README appears to be default SE2 — update with your project description"
fi

echo ""

# -------------------------------------------
# 6. Hardcoded Values
# -------------------------------------------
echo "--- Hardcoded / Env Issues ---"

if grep -rq "localhost:3000" "$NEXTJS/app/" "$NEXTJS/components/" 2>/dev/null; then
    fail "Found hardcoded 'localhost:3000' in app code"
fi

if grep -rq "127\.0\.0\.1" "$NEXTJS/app/" "$NEXTJS/components/" 2>/dev/null; then
    warn "Found '127.0.0.1' in app code — check if this is intentional"
fi

if grep -rq "31337" "$NEXTJS/app/" "$NEXTJS/components/" 2>/dev/null; then
    warn "Found chain ID '31337' (local/foundry) in app code — remove for production"
fi

echo ""

# -------------------------------------------
# Summary
# -------------------------------------------
echo "========================================="
echo "  Results: ${RED}${ERRORS} errors${NC}, ${YELLOW}${WARNINGS} warnings${NC}"
echo "========================================="

if [ "$ERRORS" -gt 0 ]; then
    echo -e "${RED}FAILED — Fix errors before deploying${NC}"
    exit 1
elif [ "$WARNINGS" -gt 0 ]; then
    echo -e "${YELLOW}PASSED with warnings — review before deploying${NC}"
    exit 0
else
    echo -e "${GREEN}ALL CLEAR — Ready to deploy${NC}"
    exit 0
fi
