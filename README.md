# my_os
Hand-made minimal linux OS (32bit) and linker


- Need to write startup code and linker script:
   - C/C++ programs can't run immediately after a processor restart: the
     code requires that some setup is done first before main(), an entry
     point called from _startup, is called.
     The minimal setup includes creating a stack and loading it's address
     in the stack pointer register, global data (initialized and uninitialized),
     and read-only data.
     Because our OS has no access to libc startup code, we need to handle
     this setup ourselves, and then link it into our kernel object file.

   - See https://embeddedartistry.com/blog/2019/04/08/a-general-overview-of-what-happens-before-main/ for good write-up on C _startup.
   - We'll need to write a loader.s and a kernel.cpp.
      - loader.s -> (compiled using gnu assembler, 'as' -> loader.o
      - kernal.cpp -> (compiled using gnu c++, 'g++' -> kernel.o

      Two object files compiled by 2 diff compilers. We'll need to hand-link
      these object files with 'ld' -> kernel.bin. Note, this is the entry that
      is th pointed to in the grub.cfg.




1) make loader.o
2) make kernel.o
3) make mykernel.bin
4) make mykernel.iso

