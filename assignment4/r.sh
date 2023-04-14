#!/bin/bash

#Author: William Sutanto
#Program name: Benchmark

rm *.o, *.lis, *.out
echo " " #Blank line

echo "Compile the C++ file main.cpp"
g++ -c -m64 -Wall -std=c++14 -fno-pie -no-pie -o main.o main.cpp

echo "Compile manager.asm"
nasm -f elf64 -l manager.lis -o manager.o manager.asm

echo "Compile getradicand.asm"
nasm -f elf64 -l getradicand.lis -o getradicand.o getradicand.asm

echo "Link object files using the gcc linker standard 2017"
g++ -m64 -std=c++17 -fno-pie -no-pie -o final.out main.o manager.o getradicand.o

echo "Run the program:"
./final.out

#Clean up after program is run
rm *.o
rm *.out
rm *.lis