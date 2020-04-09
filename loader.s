
# The bootloader expects the kernel image to be booted
# to contain a 'magic number' to validate it is indeed
# a boot image. This number is 0x1badb002 and is specific
# to the Grub bootloader.
# The following puts values into variables that are
# passed to the compiler (not actually put in the resulting
# .o file).
.set MAGIC, 0x1badb002
.set FLAGS, (1<<0 | 1<<1)
.set CHECKSUM, -(MAGIC + FLAGS)

# The bootloader creates the .multiboot section in
# memory (RAM).

# Put into .o file
.section .multiboot
   .long MAGIC
   .long FLAGS
   .long CHECKSUM

# text section: contains code/instructions
.section .text
.extern kernelMain # Let the linker find this
.global loader # Entry point

# This is where we set the stack register pointer
loader:
   mov $kernel_stack, %esp

   # The bootloader creates the .multiboot section in
   # RAM and stores pointer to it in the AX register.
   # Among other things, this section knows the size of
   # RAM. It also copies the MAGIC number into the BX
   # register.
   push %eax
   push %ebx
   call kernelmain

# The kernel (currently) should be an infinite
# loop. BUT, just in case we somehow get kicked
# out of it, add an infinite loop here.
_stop:
   cli # clear interrupt flag
   hlt # enter halt state (stops instruction execution)
   jmp _stop # jmp back to _stop


# Uninitialized global and static variables
.section .bss
# Going the place the stack starting point 2Mb
# from the begining of where the kernel is loaded 
# into ram. 
.space 2*1024*1024

kernel_stack:
