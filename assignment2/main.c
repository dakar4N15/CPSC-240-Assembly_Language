//***************************************************************************************************************************
//Program name: "Arrays".  This program will prompt user to enter floats and store it into an array and calculate the        *   
//magnitude of that array. There will be 2 sets of arrays, so the program will repeat similar steps twice and at the end     *
//both arrays will be appended into a separate array and the magnitude of that array will be calculated as well. The magnitude*
//of the combined array will be returned to main. Main and display_array is implemented in c, and the rest is implemented    *
//in X86. Copyright (C) 2023  William Sutanto                                                                                *
//This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
//version 3 as published by the Free Software Foundation.                                                                    *
//This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied         *
//warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
//A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.                           *
//****************************************************************************************************************************

//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//Author information
//  Author name: William Sutanto
//  Author email: wsutanto@csu.fullerton.edu
//
//Program information
//  Program name: Arrays
//  Programming languages: C, X86 assembly
//  Date program began: 2023-Feb-12
//  Date of last update: 2023-Feb-20
//  Comments reorganized: 2023-Feb-20
//  Files in the program: main.c, manager.asm, display_array.c, magnitude.asm, append.asm, input_array.asm, isfloat.asm, r.sh
//
//Purpose
//  Build a program in assembly language that will take in floats from user and store it into an array. This program will repeat the steps twice
//  so that there will be 2 arrays and the magnitude of each array will be calculated. At the end, the 2 arrays will be combined into an array
//  and the magnitude of that array will be calculated and returned to main.
//
//This file
//  File name: main.c
//  Language: C
//  Max page width: 172 columns
//  Optimal print specification: 7 point font, monospace, 172 columns, 8½x11 paper
//  Compile: gcc -c -m64 -Wall -std=c17 -fno-pie -no-pie -o main.o main.c
//  Link: g++ -m64 -std=c++17 -fno-pie -no-pie -o final.out main.o manager.o input_array.o display_array.o magnitude.o append.o isfloat.o
//
//Execution: ./final.out
//
//===== Begin code area ===================================================================================================================================================
#include <stdio.h>
#include <stdint.h>
#include <time.h>
#include <sys/time.h>
#include <stdlib.h>

extern double manager();

int main(int argc, char *argv[])
{
    //greet the user
    printf("Welcome to Arrays of Integers\n");
    printf("Brought to you by William Sutanto\n\n");

    //call the manager asm module and store the value returned from it
    double a = manager();

    //output the magnitude of the combined array and end message to console
    printf("\nMain received %.10lf., and will keep it for future use.\n", a);
    printf("Main will return 0 to the operating system. Bye.\n");
}