#Author: William Sutanto
#Author: wsutanto@csu.fullerton.edu
#Course and section:  CPSC240-7
#Today’s date: Mar 22, 2023

rm *.o, *.lis, *.out
echo " " #Blank line

echo "Compile the main file main.c"
gcc -c -m64 -Wall -std=c17 -fno-pie -no-pie -o main.o main.c

echo "Assemble the X86 file manager.asm"
nasm -f elf64 -l pythagoras.lis -o manager.o manager.asm

echo "Assemble the X86 file input_array.asm"
nasm -f elf64 -l pythagoras.lis -o input_array.o input_array.asm

echo "Assemble the X86 file reverse.asm"
nasm -f elf64 -l pythagoras.lis -o reverse.o reverse.asm

echo "Compile the C file display_array.c"
gcc -c -m64 -Wall -std=c17 -fno-pie -no-pie -o display_array.o display_array.c

echo "Link the 'O' files"
g++ -m64 -std=c++17 -fno-pie -no-pie -o final.out main.o manager.o input_array.o reverse.o display_array.o

echo "Run the program:"
./final.out

#Clean up after program is run
rm *.o
rm *.out
rm *.lis