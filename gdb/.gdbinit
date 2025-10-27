set auto-load safe-path /
set history save on
set history filename $HOME/.gdb_history
set print pretty
set print asm-demangle on
# on arm64 this cuz an error (gdb 16.3):
# set disassembly-flavor intel
set breakpoint pending on
set listsize 10
layout split
