#!/bin/bash

#Author: William Sutanto
#Program name: Pythagoras Triangle

rm *.o, *.lis, *.out
echo " " #Blank line

echo "Assemble the X86 file pythagoras.asm"
nasm -f elf64 -l pythagoras.lis -o pythagoras.o pythagoras.asm

echo "Compile the C++ file driver.cpp"
g++ -c -m64 -Wall -std=c++14 -fno-pie -no-pie -o driver.o driver.cpp

echo "Link the 'O' files pythagoras.o and driver.o"
g++ -m64 -std=c++14 -fno-pie -no-pie -o final.out pythagoras.o driver.o

echo "Run the program:"
./final.out

#Clean up after program is run
rm *.o
rm *.out
rm *.lis