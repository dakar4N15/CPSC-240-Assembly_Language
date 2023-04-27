#!/bin/bash

#Author: William Sutanto
#Program name: Benchmark and Data Validation

rm *.o, *.lis, *.out
echo " " #Blank line

echo "Compile the C++ file driver.cpp"
g++ -c -m64 -Wall -std=c++14 -fno-pie -no-pie -o driver.o driver.cpp

echo "Compile manager.asm"
nasm -f elf64 -l manager.lis -o manager.o manager.asm

echo "Compile isfloat.asm"
nasm -f elf64 -l isfloat.lis -o isfloat.o isfloat.asm

echo "Link object files using the gcc linker standard 2017"
g++ -m64 -std=c++17 -fno-pie -no-pie -o final.out driver.o manager.o isfloat.o

echo "Run the program:"
./final.out

#Clean up after program is run
rm *.o
rm *.out
rm *.lis