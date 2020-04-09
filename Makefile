
# Among other paramters to g++, need to specify no glibc around
GPPARAMS = -m32 -fno-use-cxa-atexit -nostdlib -fno-builtin -fno-rtti -fno-exceptions -fno-leading-underscore
ASPARAMS = --32
LDPARAMS = -melf_i386

objects = loader.o kernel.o

# Makefile cheat sheet
# out.o: src.c src.h
#  $@   # "out.o" (target)
#  $<   # "src.c" (first prerequisite)
#  $^   # "src.c src.h" (all prerequisites)
#
#%.o: %.c
#  $*   # the 'stem' with which an implicit rule matches ("foo" in "foo.c")
#
#also:
#  $+   # prerequisites (all, with duplication)
#  $?   # prerequisites (new ones)
#  $|   # prerequisites (order-only?)
#
#  $(@D) # target directory

%.o: %.cpp
	/usr/bin/g++ $(GPPARAMS) -o $@ -c $<

%.o: %.s
	as $(ASPARAMS) -o $@ $<

mykernel.bin: linker.ld $(objects)
	ld $(LDPARAMS) -T $< -o $@ $(objects)

install: mykernel.bin
	sudo cp $< /boot/mykernel.bin

# The 'make install' requires adding the following entry
# to /boot/grub/grub.cfg
# menuentry 'My OS' {
#  multiboot /boot/mykernel.bin
#  boot
# }
#
# To install in VM, use 'make mykernel.iso'


mykernel.iso: mykernel.bin
	mkdir -p iso/boot/grub
	cp $< iso/boot/
	echo 'set timeout=0' > iso/boot/grub/grub.cfg
	echo 'set default=0' >> iso/boot/grub/grub.cfg
	echo 'menuentry "My OS" {' >> iso/boot/grub/grub.cfg
	echo '  multiboot /boot/mykernel.bin' >> iso/boot/grub/grub.cfg
	echo '  boot' >> iso/boot/grub/grub.cfg
	echo '}' >> iso/boot/grub/grub.cfg
	grub-mkrescue --output=$@ iso
	#rm -rf iso

all: $(objects) mykernel.bin mykernel.iso
clean:
	rm -rf *.o *.bin *.iso