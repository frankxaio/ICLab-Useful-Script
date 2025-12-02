#!/usr/bin/tcsh -f

# ANSI colors
if ( ! $?GREEN ) setenv GREEN '\033[0;32m'
if ( ! $?BLUE ) setenv BLUE '\033[0;34m'
if ( ! $?YELLOW ) setenv YELLOW '\033[1;33m'
if ( ! $?RED ) setenv RED '\033[0;31m'
if ( ! $?NC ) setenv NC '\033[0m'

# File variables (若未設定則使用預設值)
if ( ! $?TESTBED_FILE ) setenv TESTBED_FILE "00_TESTBED/TESTBED.v"
if ( ! $?PATTERN_FILE ) setenv PATTERN_FILE "00_TESTBED/PATTERN.v"
if ( ! $?SYN_FILE ) setenv SYN_FILE "02_SYN/syn.tcl"

# 定義顯示用的 Regex Pattern
# 1. Verilog: 只抓取 `define CYCLE_TIME (忽略前面可能的空白)
set V_SHOW_PATTERN = '`define[[:space:]]+CYCLE_TIME'
# 2. TCL: 抓取 set CYCLE
set T_SHOW_PATTERN = 'set[[:space:]]+CYCLE'

# =========================================================
# Mode 1: View Mode (No arguments)
# =========================================================
if ( $#argv == 0 ) then
    # 1. TESTBED
    if ( -f "$TESTBED_FILE" ) then
        echo "${BLUE}File: $TESTBED_FILE${NC}"
        grep -E "$V_SHOW_PATTERN" "$TESTBED_FILE"
    else
        echo "${RED}File not found: $TESTBED_FILE${NC}"
    endif

    # 2. PATTERN
    if ( -f "$PATTERN_FILE" ) then
        echo "${BLUE}File: $PATTERN_FILE${NC}"
        grep -E "$V_SHOW_PATTERN" "$PATTERN_FILE"
    else
        echo "${RED}File not found: $PATTERN_FILE${NC}"
    endif

    # 3. SYN
    if ( -f "$SYN_FILE" ) then
        echo "${BLUE}File: $SYN_FILE${NC}"
        grep -E "$T_SHOW_PATTERN" "$SYN_FILE"
    else
        echo "${RED}File not found: $SYN_FILE${NC}"
    endif

    exit 0
endif

# =========================================================
# Mode 2: Update Mode (With argument)
# =========================================================
set new_cycle = "$1"

# 1. Update TESTBED
if ( -f "$TESTBED_FILE" ) then
    # 使用單引號保護 sed 指令，避免 tcsh 解析錯誤
    # [^[:space:]]+ 匹配 "非空白字元"，可以同時匹配數字或 "echo"
    sed -i -E 's/(`define[[:space:]]+CYCLE_TIME[[:space:]]+)[^[:space:]]+/\1'"$new_cycle"'/' "$TESTBED_FILE"
else
    echo "${RED}File not found: $TESTBED_FILE${NC}"
endif

# 2. Update PATTERN
if ( -f "$PATTERN_FILE" ) then
    sed -i -E 's/(`define[[:space:]]+CYCLE_TIME[[:space:]]+)[^[:space:]]+/\1'"$new_cycle"'/' "$PATTERN_FILE"
else
    echo "${RED}File not found: $PATTERN_FILE${NC}"
endif

# 3. Update SYN
if ( -f "$SYN_FILE" ) then
    # TCL 語法: set CYCLE 10.0
    sed -i -E 's/(set[[:space:]]+CYCLE[[:space:]]+)[^[:space:]]+/\1'"$new_cycle"'/' "$SYN_FILE"
else
    echo "${RED}File not found: $SYN_FILE${NC}"
endif

echo "${GREEN}Change cycle time to $new_cycle done.${NC}"

# =========================================================
# Final Show State
# =========================================================

# 1. TESTBED
if ( -f "$TESTBED_FILE" ) then
    echo "${BLUE}File: $TESTBED_FILE${NC}"
    grep -E "$V_SHOW_PATTERN" "$TESTBED_FILE"
endif

# 2. PATTERN
if ( -f "$PATTERN_FILE" ) then
    echo "${BLUE}File: $PATTERN_FILE${NC}"
    grep -E "$V_SHOW_PATTERN" "$PATTERN_FILE"
endif

# 3. SYN
if ( -f "$SYN_FILE" ) then
    echo "${BLUE}File: $SYN_FILE${NC}"
    grep -E "$T_SHOW_PATTERN" "$SYN_FILE"
endif