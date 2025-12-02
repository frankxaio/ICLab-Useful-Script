#!/usr/bin/tcsh -f

if ( ! $?ROOT_PATH ) then
    echo "Error: ROOT_PATH is not defined."
    exit 1
endif

set dir = "$ROOT_PATH/02_SYN/Report"

if ( ! -d "$dir" ) then
    echo "Report directory not found: $dir"
    exit 1
endif

if ( $#argv == 0 ) then
    echo "Available extensions under $dir:"
    ls "$dir" | sed -E 's/.*\.//' | sort -u
else
    set ext = "$1"

    ls "$dir"/*."$ext" >& /dev/null

    if ( $status == 0 ) then
        cat "$dir"/*."$ext"
    else
        echo "No files found with extension .$ext in $dir"
    endif
endif