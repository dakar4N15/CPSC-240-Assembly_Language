//***************************************************************************************************************************
//Program name: "Random Numbers". This program will generate qword (random numbers) with a specified amount given by the     *
//user and store those values into an array. The values of these random numbers will be printed in both IEEE754 and          *
//scientific decimal format. Furthermore, the numbers in this array will also be sorted in the order from smallest to largest*
//and then normalized so that it lies within the interval 1.0<=num<2.0.The unsorted, sorted, and normalized version of the   *
//array will all be printed in both IEEE754 and scientific decimal format. 
//Copyright (C) 2023  William Sutanto                                                                                        *
//This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
//version 3 as published by the Free Software Foundation.                                                                    *
//This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied         *
//warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
//A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.         
//****************************************************************************************************************************

//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//Author information
//  Author name: William Sutanto
//  Author email: wsutanto@csu.fullerton.edu
//
//Program information
//  Program name: Random Numbers
//  Programming languages: C, C++, X86 assembly
//  Date program began: 2023-March-5
//  Date of last update: 2023-March-8
//  Comments reorganized: 2023-March-8
//  Files in the program: main.cpp, executive.asm, fill_random_array.asm, show_array.asm, compare.c, normalize.asm, isnan.asm, r.sh
//
//Purpose
//  This is the main driver file for the program random numbers, written in C++. 
//
//This file
//  File name: main.cpp
//  Language: C++
//  Max page width: 172 columns
//  Optimal print specification: 7 point font, monospace, 172 columns, 8½x11 paper
//  Compile: g++ -c -m64 -Wall -std=c++14 -fno-pie -no-pie -o main.o main.cpp
//  Link: g++ -m64 -std=c++17 -fno-pie -no-pie -o final.out main.o executive.o fill_random_array.o show_array.o compare.o normalize.o isnan.o
//
//Execution: ./final.out
//
//===== Begin code area ===================================================================================================================================================
#include <iostream>
#include <stdio.h>
#include <stdint.h>
#include <time.h>
#include <sys/time.h>
#include <stdlib.h>

extern "C" char* executive();


int main(int argc, char *argv[])
{
    //greet the user
    std::cout << "Welcome to Random Products, LLC.\n";
    std::cout << "This software is maintained by William Sutanto\n\n";

    //call the executive asm module and store the value returned from it
    char* name = executive();

    //output goodbye message to user
    std::cout << "\nOh, " <<  name << ". We hope you enjoyed your arrays. Do come again.\n";
    std::cout << "A zero will be returned to the operating system.\n";
}