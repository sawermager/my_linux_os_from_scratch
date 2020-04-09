# my_os
Hand-made minimal linux OS (32bit) and linker


- The _startup code assumes that the program loader fills the needed registers before the startup code entry point is executed. We will have to do this manually with our own loader.o and link that into our kernel.o. Our specific issue here
is with the stack pointer register requirement for C/C++ binaries (the kernel in this case). The compiler supplies the actual
_startup code, crt0.o.

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

