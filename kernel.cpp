
/** 
 * Grub implements the multiboot specification. When it loads the 
 * kernel and hands over control to it, it passes a pointer to an 
 * information structure in memory. One of the fields in that structure 
 * is the command line. 
 * The Linux kernel has its own boot protocol, but the command line is 
 * handled in a similar fashion: the boot loader leaves it in memory, and 
 * fills in various fields in a kernel data structure which allow the kernel 
 * to find it.
 * The magicnumber is passed to avoid compiler warning.
 **/

void printf(char* str) {

   /** linux dynamically loads glibc to get stdio (for printf())....
    * No glibc avail in our kernel. So, have to write bare-bones equiv to printf().
    * Instead, we will have to write directly to "video" memory in RAM location 0xb8000
    * Note, this location is specific to color monitors.
    * Anything written to this address will be displayed on the screen.
    * See https://wiki.osdev.org/Printing_To_Screen for more details.
    **/
    unsigned short *video_memory = (unsigned short *) 0xb8000;
    for (int i=0; str[i] != '\0'; ++i) 

       /** Each entry per character is 2bytes. The high is supposedly
        * for foreground/background. So, leave these alone and only
        * modify the lower byte for the actual character to be written.
        **/
       video_memory[i] = (video_memory[i] & 0xFF00) | str[i];
}

/** 'extern "C"' is needed here because the g++ compiler tries to 
 * change the name of kernelMain for whatever reason.
 **/
extern "C" void kernelmain(void* multiboot_structure, unsigned int magicnumber) {
    printf ("HelloWorld");
    while(1);
}
