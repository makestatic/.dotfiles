set auto-load safe-path /
set history save on
set history filename ~/.gdb_history
set print pretty on
set print elements 0
set print asm-demangle on
set disassembly-flavor intel
set breakpoint pending on
set listsize 10

# file:line
define hook-stop
  printf "\n\033[1;32m[Stopped at]\033[0m "
  frame
  info locals
end
