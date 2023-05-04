#!/bin/bash

#Author: William Sutanto
#Program name: Sleep time

rm *.o, *.lis, *.out
echo " " #Blank line

echo "Compile the C++ file main.cpp"
g++ -c -m64 -Wall -std=c++14 -fno-pie -no-pie -o main.o main.cpp

echo "Compile birthday.asm"
nasm -f elf64 -l birthday.lis -o birthday.o birthday.asm

echo "Link object files using the gcc linker standard 2017"
g++ -m64 -std=c++17 -fno-pie -no-pie -o final.out main.o birthday.o

echo "Run the program:"
./final.out

#Clean up after program is run
rm *.o
rm *.out
rm *.lis