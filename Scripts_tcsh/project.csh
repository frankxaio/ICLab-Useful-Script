#!/usr/bin/tcsh

# =====================================================
# Project Bootstrap Script
# =====================================================

# -------------------- Colors -------------------------
setenv GREEN '\033[0;32m'
setenv BLUE '\033[0;34m'
setenv YELLOW '\033[1;33m'
setenv RED '\033[0;31m'
setenv NC '\033[0m' # No Color

# -------------------- Paths --------------------------
setenv ROOT_PATH `pwd`
setenv SCRIPT_PATH "$HOME/.asic-script/Scripts_tcsh"
setenv SYN_FILE "$ROOT_PATH/02_SYN/syn.tcl"

# Parse makefile and syn file using shell commands
if ( -f "$ROOT_PATH/00_TESTBED/makefile" ) then
    setenv DESIGN_MAKE `grep -E '^top_design=' "$ROOT_PATH/00_TESTBED/makefile" | cut -d'=' -f2 | tr -d ' '`
else
    setenv DESIGN_MAKE "UNKNOWN"
endif

if ( -f "$SYN_FILE" ) then
    setenv DESIGN_SYN `grep -E '^set DESIGN ' "$SYN_FILE" | awk '{print $3}' | tr -d '"'`
else
    setenv DESIGN_SYN "UNKNOWN"
endif

setenv SDC_FILE "$ROOT_PATH/02_SYN/$DESIGN_SYN.sdc"
setenv TESTBED_FILE "$ROOT_PATH/00_TESTBED/TESTBED.v"
setenv PATTERN_FILE "$ROOT_PATH/00_TESTBED/PATTERN.v"

# -------------------- Info Panel ---------------------
echo "${GREEN}+---------------+----------------------------------------------------------------+${NC}"
echo "${GREEN}| COMMAND       | DESCRIPTION                                                    |${NC}"
echo "${GREEN}+---------------+----------------------------------------------------------------+${NC}"
echo "${BLUE}| ROOT_PATH      | ${NC}$ROOT_PATH"
echo "${BLUE}| DESIGN         | ${NC}makefile: ${YELLOW}$DESIGN_MAKE${NC}, Syn File: ${YELLOW}$DESIGN_SYN${NC}"
echo "${BLUE}| cd.csh         | ${NC}0~9, m to switch folders; 2r -> syn report; 2n -> syn netlist"
echo "${BLUE}| rtl            | ${NC}run RTL simulation"
echo "${BLUE}| syn            | ${NC}run synthesis"
echo "${BLUE}| c              | ${NC}change synthesis cycle time, e.g. cycle_syn 10.0"
echo "${BLUE}| f              | ${NC}toggle fsdbDumpfile/fsdbDumpvars in TESTBED.v"
echo "${BLUE}| gate           | ${NC}run gate simulation"
echo "${BLUE}| post           | ${NC}run post simulation"
echo "${BLUE}| check_syn      | ${NC}summarize synthesis results"
echo "${BLUE}| rpt            | ${NC}cat all files in \$ROOT_PATH/02_SYN/Report/*.ext"
echo "${BLUE}| clean          | ${NC}clean current directory"
echo "${BLUE}| clean0123      | ${NC}clean 00_TESTBED, 01_RTL, 02_SYN, 03_GATE"
echo "${GREEN}+---------------+----------------------------------------------------------------+${NC}"

# -------------------- Script Source ------------------
# Source the cd script initially to load any environment if needed, though mostly used via aliases
source "$SCRIPT_PATH/cd.csh"

# =====================================================
# Aliases (replacing functions and loops)
# =====================================================

# -- Directory Switching (0~9)
# Manually unrolled or looped alias creation
foreach i ( 0 1 2 3 4 5 6 7 8 9 )
    alias $i "source '$SCRIPT_PATH/cd.csh' $i"
end

foreach i ( 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 )
    alias $i "source '$SCRIPT_PATH/cd.csh' $i"
end

alias m "source '$SCRIPT_PATH/cd.csh' m"

# -- Synthesis Directories
alias 2r "cd '$ROOT_PATH/02_SYN/Report/'"
alias 2n "cd '$ROOT_PATH/02_SYN/Netlist/'"

# -- Python Tools
# alias python "~/miniconda3/bin/python3"

# -- Document
alias doc_dw "evince /usr/cad/synopsys/synthesis/cur/dw/doc/manuals/dwbb_userguide.pdf >& /dev/null &"
alias doc_io "evince ~iclabTA01/umc018/Doc/umc18io3v5v.pdf >& /dev/null &"
alias doc_verdi "evince /RAID2/cad/synopsys/verdi/2022.06/doc/VerdiTut.pdf >& /dev/null &"
alias doc_soc "cd /RAID2/cad/cadence/INNOVUS/INNOVUS_20.15.000/doc"

# =====================================================
# Functional Aliases
# =====================================================

alias check_syn 'source "$SCRIPT_PATH/cd.csh" 2; source "$SCRIPT_PATH/check_syn.csh" "$DESIGN_MAKE"'

alias rtl 'source "$SCRIPT_PATH/cd.csh" 1; make vcs_rtl'

alias syn 'source "$SCRIPT_PATH/cd.csh" 2; make syn'

alias gate 'source "$SCRIPT_PATH/cd.csh" 3; make vcs_gate'

alias post 'source "$SCRIPT_PATH/cd.csh" 6; make vcs_post'

alias clean 'echo "${BLUE}[INFO] Cleaning current directory...${NC}"; make -f "$ROOT_PATH/00_TESTBED/makefile" clean >& /dev/null'

alias clean0123 ' \
    echo "${BLUE}[INFO] Cleaning 00_TESTBED...${NC}"; \
    source "$SCRIPT_PATH/cd.csh" 0; \
    make -f "$ROOT_PATH/00_TESTBED/makefile" clean >& /dev/null; \
    echo "${GREEN}  > 00_TESTBED cleaned${NC}"; \
    echo "${BLUE}[INFO] Cleaning 01_RTL...${NC}"; \
    source "$SCRIPT_PATH/cd.csh" 1; \
    make -f "$ROOT_PATH/01_RTL/makefile" clean >& /dev/null; \
    echo "${GREEN}  > 01_RTL cleaned${NC}"; \
    echo "${BLUE}[INFO] Cleaning 02_SYN...${NC}"; \
    source "$SCRIPT_PATH/cd.csh" 2; \
    make -f "$ROOT_PATH/02_SYN/makefile" clean >& /dev/null; \
    echo "${GREEN}  > 02_SYN cleaned${NC}"; \
    echo "${BLUE}[INFO] Cleaning 03_GATE...${NC}"; \
    source "$SCRIPT_PATH/cd.csh" 3; \
    make -f "$ROOT_PATH/03_GATE/makefile" clean >& /dev/null; \
    echo "${GREEN}  > 03_GATE cleaned${NC}"; \
    echo "${GREEN}[DONE] All directories cleaned successfully!${NC}"'

# Note: rpt is complex to implement as a one-line alias in tcsh.
# Implementing as a shell script block executed via eval or simple sourcing logic is cleaner.
# Here we map it to a subshell script for display.
alias rpt 'source "$SCRIPT_PATH/rpt.csh" \!*'

alias c 'setenv TESTBED_FILE "$TESTBED_FILE"; setenv PATTERN_FILE "$PATTERN_FILE"; setenv SYN_FILE "$SYN_FILE"; source "$SCRIPT_PATH/cycle.csh" \!*'

alias f 'setenv TESTBED_FILE "$TESTBED_FILE"; source "$SCRIPT_PATH/fsdb.csh" \!*'


alias check_warn 'source "$SCRIPT_PATH/check_warn.csh"'

alias quota 'source "$SCRIPT_PATH/quota.csh"'

alias update-project-env 'bash $HOME/install.sh'

alias prj_help ' \
    echo "${GREEN}+---------------+----------------------------------------------------------------+${NC}"; \
    echo "${GREEN}| COMMAND       | DESCRIPTION                                                    |${NC}"; \
    echo "${GREEN}+---------------+----------------------------------------------------------------+${NC}"; \
    echo "${BLUE}| ROOT_PATH      | ${NC}$ROOT_PATH"; \
    echo "${BLUE}| DESIGN         | ${NC}makefile: ${YELLOW}$DESIGN_MAKE${NC}, Syn File: ${YELLOW}$DESIGN_SYN${NC}"; \
    echo "${BLUE}| clean0123      | ${NC}clean all directories"; \
    echo "${GREEN}+---------------+----------------------------------------------------------------+${NC}"'
