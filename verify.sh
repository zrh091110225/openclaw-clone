#!/bin/bash

#==========================================
# OpenClaw Clone - Verify Script
# Purpose: Verify OpenClaw installation
# Usage: ./verify.sh
#==========================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Paths
OC_DIR="$HOME/.openclaw"

# Helpers
info()  { echo -e "${BLUE}ℹ${NC}  $*"; }
ok()    { echo -e "${GREEN}✓${NC}  $*"; }
warn()  { echo -e "${YELLOW}⚠${NC}  $*"; }
err()   { echo -e "${RED}✗${NC}  $*"; }
header(){ echo -e "\n${BOLD}${CYAN}═══ $* ═══${NC}\n"; }

#==========================================
# Main
#==========================================

header "OpenClaw Installation Verification"

PASS=0
FAIL=0

check() {
    if eval "$2" &>/dev/null; then
        ok "$1"
        ((PASS++))
    else
        err "$1"
        ((FAIL++))
    fi
}

# --- Core ---
info "Core:"
check "  OpenClaw CLI installed" "command -v openclaw"
check "  Config exists" "test -f $OC_DIR/openclaw.json"
check "  Workspace exists" "test -d $OC_DIR/workspace"
check "  SOUL.md exists" "test -f $OC_DIR/workspace/SOUL.md"
check "  USER.md exists" "test -f $OC_DIR/workspace/USER.md"
check "  MEMORY.md exists" "test -f $OC_DIR/workspace/MEMORY.md"
check "  Credentials directory exists" "test -d $OC_DIR/credentials"

# Count agents
if [ -d "$OC_DIR/agents" ]; then
    agent_count=$(find "$OC_DIR/agents" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
    info "  Agents found: ${BOLD}$agent_count${NC}"
fi

# --- External Tools ---
echo ""
info "External tools:"
check "  Node.js" "command -v node"
check "  npm" "command -v npm"

# --- Gateway ---
echo ""
info "Gateway:"
if command -v openclaw &>/dev/null; then
    gw_status=$(openclaw gateway status 2>&1 || true)
    if echo "$gw_status" | grep -qi "running"; then
        ok "  Gateway running"
        ((PASS++))
    else
        warn "  Gateway not running (start with: openclaw gateway start)"
        ((FAIL++))
    fi
else
    warn "  OpenClaw CLI not found"
    ((FAIL++))
fi

# --- Cron jobs ---
if command -v openclaw &>/dev/null; then
    cron_count=$(openclaw cron list 2>/dev/null | wc -l | tr -d ' ')
    if [ "$cron_count" -gt 0 ]; then
        info "  Cron jobs: ${BOLD}$cron_count${NC}"
    else
        info "  Cron jobs: none"
    fi
fi

# --- Data Size ---
echo ""
info "Data size:"
if [ -d "$OC_DIR" ]; then
    size=$(du -sh "$OC_DIR" 2>/dev/null | cut -f1)
    info "  Total: ${BOLD}$size${NC}"
fi

# --- Summary ---
echo ""
header "Summary"
ok "Passed: $PASS"
if [ $FAIL -gt 0 ]; then
    err "Failed: $FAIL"
else
    ok "Failed: $FAIL"
fi

echo ""
if [ $FAIL -gt 0 ]; then
    echo -e "Some checks failed. To troubleshoot, run:"
    echo -e "  ${CYAN}openclaw doctor${NC}"
    echo -e "  ${CYAN}openclaw gateway start${NC}"
else
    echo -e "${GREEN}✅ OpenClaw is properly installed!${NC}"
fi
