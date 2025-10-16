set auto-load safe-path /
set history save on
set history filename $HOME/.gdb_history
set print pretty
set print asm-demangle on
set disassembly-flavor intel
set breakpoint pending on
set listsize 10

define hook-stop
    printf "\n\033[1;32m[Stopped at]\033[0m "
    if $_isvoid($pc) == 0
        frame 0
        info locals
    end
end
