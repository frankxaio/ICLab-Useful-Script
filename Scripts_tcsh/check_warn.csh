#!/usr/bin/tcsh -f

set log_paths = ($argv)
set default_logs = 0

if ( $#log_paths == 0 ) then
    set log_paths = (vcs.log syn.log)
    set default_logs = 1
endif

if ( -t 1 ) then
    set header_color = `printf '\033[1;34m'`
    set count_color  = `printf '\033[1;36m'`
    set warn_color   = `printf '\033[33m'`
    set err_color    = `printf '\033[0;31m'`
    set ok_color     = `printf '\033[32m'`
    set reset        = `printf '\033[0m'`
else
    set header_color = ''
    set count_color  = ''
    set warn_color   = ''
    set err_color    = ''
    set ok_color     = ''
    set reset        = ''
endif

# Stderr colors
if ( -t 2 ) then
    set stderr_color = `printf '\033[31m'`
    set stderr_reset = "$reset"
else
    set stderr_color = ''
    set stderr_reset = ''
endif

set missing = 0
set processed = 0

foreach log_path ( $log_paths )
    if ( ! -f "$log_path" ) then
        if ( $default_logs == 1 ) continue
        echo "${stderr_color}Error:${stderr_reset} cannot find $log_path in `pwd`" >&2
        set missing = 1
        continue
    endif

    printf "${header_color}==> ${log_path}${reset}\n"

    # 傳遞 err_color 給 awk
    awk -v log_path="$log_path" \
        -v count_color="$count_color" \
        -v warn_color="$warn_color" \
        -v err_color="$err_color" \
        -v ok_color="$ok_color" \
        -v reset="$reset" ' \
      BEGIN { \
        success_msg = ok_color "No errors or warnings found in " log_path "." reset \
      } \
      \
      /^[[:space:]]*%?[Ee]rror[-:]/ { \
        line=$0; \
        sub(/^[[:space:]]*/,"",line); \
        err_counts[line]++; \
      } \
      \
      /^[[:space:]]*%?[Ww]arning[-:]/ { \
        line=$0; \
        sub(/^[[:space:]]*/,"",line); \
        warn_counts[line]++; \
      } \
      \
      END { \
        has_err = length(err_counts); \
        has_warn = length(warn_counts); \
        \
        if (has_err == 0 && has_warn == 0) { \
          printf "%s\n", success_msg; \
          exit 0; \
        } \
        \
        PROCINFO["sorted_in"] = "@val_num_desc"; \
        \
        if (has_err > 0) { \
            for (line in err_counts) \
                printf "%s%7d%s %s%s%s\n", count_color, err_counts[line], reset, err_color, line, reset; \
        } \
        \
        if (has_warn > 0) { \
            for (line in warn_counts) \
                printf "%s%7d%s %s%s%s\n", count_color, warn_counts[line], reset, warn_color, line, reset; \
        } \
      } \
    ' "$log_path"
    printf '\n'
    @ processed++
end

if ( $default_logs == 1 && $processed == 0 ) then
    echo "${stderr_color}Error:${stderr_reset} cannot find syn.log or vcs.log in `pwd`" >&2
    exit 1
endif

exit $missing