# WIP

Work in progress!

# realsnake

realsnake is a 16-bit/real-mode application built in x86 assembly which plays Snake 

# How to build this program

It is recommended to use a linux environment to build a disk image, however using WSL or Cygwin on Windows, or equivalent MacOS tools will also work. Please ensure you have installed the following packages (along with your systems development packages):

- mtools

- QEMU

- make

- dd

- mkfs FAT

⚠️ Note: if you attempt to build the program and then run it on another device, you will encounter issues. Please see [this guide](https://wiki.osdev.org/GCC_Cross-Compiler) on building a *cross compiler toolchain*, particularly binutils. Without one, you cannot build a disk image for other hardware. 

After you have installed the requisite tools, you can simply run the `make` command. The make script will output a built disk image (if the build succeeded), as well as all compiled binaries. You can then use `make run` which will run the disk image in QEMU. You may also use `make clean` to clear out the build directory.