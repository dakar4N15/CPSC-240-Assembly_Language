#!/bin/bash

#Author: William Sutanto
#Program name: Random Numbers

rm *.o, *.lis, *.out
echo " " #Blank line

echo "Compile the C++ file main.cpp"
g++ -c -m64 -Wall -std=c++14 -fno-pie -no-pie -o main.o main.cpp

echo "Compile executive.asm"
nasm -f elf64 -l executive.lis -o executive.o executive.asm

echo "Compile fill_random_array.asm"
nasm -f elf64 -l fill_random_array.lis -o fill_random_array.o fill_random_array.asm

echo "Compile isnan.asm"
nasm -f elf64 -l isnan.lis -o isnan.o isnan.asm

echo "Compile show_array.asm"
nasm -f elf64 -l show_array.lis -o show_array.o show_array.asm

echo "Compile compare.c using gcc compiler standard 2017"
gcc -c -m64 -Wall -std=c17 -fno-pie -no-pie -o compare.o compare.c

echo "Compile normalize.asm"
nasm -f elf64 -l normalize.lis -o normalize.o normalize.asm

echo "Link object files using the gcc linker standard 2017"
g++ -m64 -std=c++17 -fno-pie -no-pie -o final.out main.o executive.o fill_random_array.o show_array.o compare.o normalize.o isnan.o

echo "Run the program:"
./final.out

#Clean up after program is run
rm *.o
rm *.out
rm *.lis