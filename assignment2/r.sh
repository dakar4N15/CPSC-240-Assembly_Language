#!/bin/bash

#Author: William Sutanto
#Program name: Arrays

rm *.o, *.lis, *.out
echo " " #Blank line

echo "Compile main.c using gcc compiler standard 2017"
gcc -c -m64 -Wall -std=c17 -fno-pie -no-pie -o main.o main.c

echo "Compile manager.asm"
nasm -f elf64 -l manager.lis -o manager.o manager.asm

echo "Compile input_array.asm"
nasm -f elf64 -l input_array.lis -o input_array.o input_array.asm

echo "Compile display_array.c using gcc compiler standard 2017"
gcc -c -m64 -Wall -std=c17 -fno-pie -no-pie -o display_array.o display_array.c

echo "Compile magnitude.asm"
nasm -f elf64 -l magnitude.lis -o magnitude.o magnitude.asm

echo "Compile append.asm"
nasm -f elf64 -l append.lis -o append.o append.asm

echo "Compile isfloat.asm"
nasm -f elf64 -l isfloat.lis -o isfloat.o isfloat.asm

echo "Link object files using the gcc linker standard 2017"
g++ -m64 -std=c++17 -fno-pie -no-pie -o final.out main.o manager.o input_array.o display_array.o magnitude.o append.o isfloat.o

echo "Run the program:"
./final.out

#Clean up after program is run
rm *.o
rm *.out
rm *.lis