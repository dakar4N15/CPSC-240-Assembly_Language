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
//  This particular C file serves as a pointer to a function that compares two elements, returns a negative integer if first argument 
//  is less than the second and returns a positive integer if first argument is greater than the second.
//
//This file
//  File name: compare.c
//  Language: C
//  Max page width: 172 columns
//  Optimal print specification: 7 point font, monospace, 172 columns, 8½x11 paper
//  Compile: gcc -c -m64 -Wall -std=c17 -fno-pie -no-pie -o compare.o compare.c
//  Link: g++ -m64 -std=c++17 -fno-pie -no-pie -o final.out main.o executive.o fill_random_array.o show_array.o compare.o normalize.o isnan.o
//
//Execution: ./final.out
//
//===== Begin code area ===================================================================================================================================================
#include <stdio.h>
#include <stdint.h>
#include <time.h>
#include <sys/time.h>
#include <stdlib.h>

extern int compare(const void *a, const void *b);

//compare is a pointer to a function that compares two elements
int compare(const void *a, const void *b)
{
    if (*(double*)a > *(double*)b)      //if first argument is greater than the second, return a positive integer
        return 1;

    if (*(double*)a < *(double*)b)      //if second argument is less than the second, return a negative integer
        return -1;

    return 0;
}