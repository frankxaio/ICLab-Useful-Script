#!/usr/bin/tcsh -f

set Design = "$1"

# Fix: Use printf with backticks to generate real escape codes
set NC     = `printf '\033[0m'`
set RED    = `printf '\033[0;31m'`
set GREEN  = `printf '\033[0;32m'`
set YELLOW = `printf '\033[1;33m'`

# Check if report files exist
if ( ! -f "Report/${Design}.timing" || ! -f "Report/${Design}.area" ) then
    echo "${RED}Report files for ${Design} not found.${NC}"
    exit 1
endif

# Extract data
set Cycle = `grep "clock clk (rise edge)" "Report/${Design}.timing" | grep -Eo '[+-]?[0-9]+([.][0-9]+)?' | sed -n '4p'`
set Area = `grep 'Total cell area:' "Report/${Design}.area" | grep -Eo '[+-]?[0-9]+([.][0-9]+)?'`
set Dynamic = `grep "Total Dynamic Power" "Report/${Design}.power"`
set Leakage = `grep "Cell Leakage Power" "Report/${Design}.power"`

# Handle Memory Area
set memory_area = `grep 'Macro/Black Box area' "Report/${Design}.area" | tr -dc '0-9'`
if ( "$memory_area" == "" ) set memory_area = "0"

# Calculate Gate Count (Ensure backticks are used)
set gate_count = `echo "$Area / 9.9792" | bc -l`

set flag = 0
echo "${YELLOW}============================${NC}"

# Check Latch
grep -i -q 'Latch' 'syn.log'
if ( $status == 0 ) then
    echo "${RED}--> X There is Latch in this design ---${NC}"
    @ flag = 1
else
    echo "${GREEN}--> V Latch Checked!${NC}"
endif

# Check Width Mismatch
grep -i -q 'mismatch' 'syn.log'
if ( $status == 0 ) then
    echo "${RED}--> X Width Mismatch Error !! ---${NC}"
    @ flag = 1
else
    echo "${GREEN}--> V Width Mismatch Checked!${NC}"
endif

# Check Error
grep -i -q 'Error' 'syn.log'
if ( $status == 0 ) then
    echo "${RED}--> X There is Error in this design !! ---${NC}"
    @ flag = 1
else
    echo "${GREEN}--> V No Error in syn.log!${NC}"
endif

# Check Timing
grep -i -q 'violated' "Report/${Design}.timing"
if ( $status == 0 ) then
    echo "${RED}--> X Timing (violated) ---${NC}"
    @ flag = 1
else
    echo "${GREEN}--> V Timing (MET) Checked!${NC}"
endif

echo "${YELLOW}============================${NC}"

if ( $flag == 1 ) then
    echo "${RED}--> X 02_SYN Fail !! Please check out syn.log file.${NC}"
else
    echo "${GREEN}--> V 02_SYN Success !!${NC}"
endif

echo "${YELLOW}============================${NC}"
echo "${YELLOW}Cycle: $Cycle ${NC}"

# Format Area (comma separated)
set int_area = `echo $Area | awk '{printf "%d", int($1)}'`
set formatted_area = `echo $int_area | awk '{len=length($0); res=""; for (i=0;i<len;i++) { if (i>0 && (len-i)%3==0) res=res","; res=res substr($0,i+1,1) } print res}'`
echo "${YELLOW}Area: $formatted_area ${NC}"

set formatted_gate = `echo $gate_count | awk '{printf "%.0f", $1}'`
echo "${YELLOW}Gate count: $formatted_gate ${NC}"

echo "${YELLOW}Dynamic: $Dynamic ${NC}"
echo "${YELLOW}Leakage: $Leakage ${NC}"