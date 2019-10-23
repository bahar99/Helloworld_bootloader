# Helloworld_bootloader
OS course - an x86 "Hello world" bootloader with assembly

## Overview
You might have wondered what happens when you press the "power" button on your computer. Well, without going into too much detail - after getting the hardware ready and launching the initial **BIOS** code to read the settings and check the system, the BIOS starts looking at the configured potential boot devices for something to execute.

It does that by reading the first 512 bytes from the boot devices and checks if the last two of these 512 bytes contain a magic number (0x55AA). If that's what these last two bytes are, the BIOS moves the 512 bytes to the memory address 0x7c00 and treats whatever was at the beginning of the 512 bytes as code, the so-called **bootloader**. In this article we will write such a piece of code, have it print the text "Hello World!".
Real bootloaders usually load the actual operating system code into memory, change the CPU into the so-called protected mode and run the actual operating system code.

## Requirements
For This Project You Need below Requirements :

 - GNU assembler 
 - QEMU emulator

GNU assembler, AKA **as**, is installed by default on Ubuntu.
 
You can write this binary into the first 512 byte on a USB drive, a floppy disk or whatever else your computer is happy booting from,but it may harm your computer.So it's recommended to use simple x86 emulator or a virtual machine.

Install QEMU in Ubuntu :
```
sudo apt-get install qemu-kvm qemu virt-manager virt-viewer libvirt-bin
```

## Steps To Run 
  * ### 0-Cloning
    + First of all clone the project : 

 ```
 git clone https://github.com/bahar99/Helloworld_bootloader
  ```

  * ### 1-Getting Our Code Ready : 
    + Turn our code into some binary by running the GNU assembler and use the GNU's linker :
  
 ```
 as -o boot.o bootloader.s
 ```
  ```
ld -o boot.bin --oformat binary -e init -Ttext 0x7c00 -o boot.bin boot.o
 ```

The assembler produces an ELF or EXE file that is ready to run but we need one additional step that strips the unwanted additional data in those files. We can use the linker (GNU's linker is called ld) for this step.

The linker is normally used to combine the various libraries and the binary executables from other tools such as compilers or assemblers into one final file. In our case we want to produce a "plain binary file", so we will pass --oformat binary to ld when we run it. We also want to specify where our program starts, so we tell the linker to use the starting label (I called it init) in our code as the program's entry point by using the -e init flag.

 The BIOS will load our code at address 0x7c00, so we will make that our starting address by specifying -Ttext 0x7c00 when we call the linker

  * ### 2-Use QEMU :
  
   ```
qemu-system-x86_64 boot.bin
 ```
 
## Source
  * http://50linesofco.de/post/2018-02-28-writing-an-x86-hello-world-bootloader-with-assembly
  * https://gist.github.com/AVGP/85037b51856dc7ebc0127a63d6a601fa
  
## Support
Reach out to me at boroomand.bahar@yahoo.co.uk
