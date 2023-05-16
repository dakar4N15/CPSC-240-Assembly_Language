#Author: William Sutanto
#Author: wsutanto@csu.fullerton.edu
#Course and section:  CPSC240-7
#Today’s date: May 15 2023

#!/bin/bash

#Author: William Sutanto

rm *.o, *.lis, *.out
echo " " #Blank line

echo "Compile the C++ file main.cpp"
g++ -c -m64 -Wall -std=c++14 -fno-pie -no-pie -o main.o main.cpp

echo "Compile manager.asm"
nasm -f elf64 -l manager.lis -o manager.o manager.asm

echo "Compile getfrequency.asm"
nasm -f elf64 -l getfrequency.lis -o getfrequency.o getfrequency.asm

echo "Link object files using the gcc linker standard 2017"
g++ -m64 -std=c++17 -fno-pie -no-pie -o final.out main.o manager.o getfrequency.o

echo "Run the program:"
./final.out

#Clean up after program is run
rm *.o
rm *.out
rm *.lis