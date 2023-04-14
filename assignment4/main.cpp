//***************************************************************************************************************************
//Program name: "Benchmark". This program is coded in a combination of c++ as the main file and assembly for the manager,    *
//and getradicand modules, including one bash file. The purpose of this program is to benchmark the                          *
//performance of your device's CPU upon running the square root instruction in SSE and also the square root program in the   *
//standard C library.
//Copyright (C) 2023  William Sutanto                                                                                        *
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
//  Program name: Benchmark
//  Programming languages: Main in C++, manager in asm, getradicand in asm, get_clock_freq in asm
//  Date program began: 2023-April-10
//  Date of last update: 2023-April-14
//  Comments reorganized: 2023-April-14
//  Files in the program: main.cpp, get_clock_freq.asm, getradicand.asm, manager.asm, r.sh
//
//Purpose
//  This program will run a benchmark test on your device's CPU performance by running the square root instruction in SSE and 
//  also the square root program in the standard C library. The main objective is to find how much time is required for a single
//  sqrt instruction to execute. This program will first identify your CPU name, type, and max clock speed. Then, this program 
//  will prompt user for a float to be used for square root benchmarking, followed by the number of times the iteration should 
//  be performed. Next, this program will get the time on the clock in tics before the iteration starts, iterate the sqrt instruction 
//  for the user's specified amount of times, and get the time on the clock in tics again after the iteration process finished. 
//  The elapsed time in tics will be displayed to the user, along with the time for one square root computation in tics and nano seconds.
//
//This file
//  File name: main.cpp
//  Language: C++
//  Max page width: 172 columns
//  Optimal print specification: 7 point font, monospace, 172 columns, 8½x11 paper
//  Compile: g++ -c -m64 -Wall -std=c++14 -fno-pie -no-pie -o main.o main.cpp
//  Link: g++ -m64 -std=c++17 -fno-pie -no-pie -o final.out main.o manager.o getradicand.o
//
//Execution: ./final.out
//
//===== Begin code area ===================================================================================================================================================

#include <stdio.h>
#include <stdint.h>
#include <time.h>
#include <sys/time.h>
#include <stdlib.h>

extern "C" double manager();           // Declare the external ASM function using the "C" directive to pass parameters in the CCC standard

int main(int argc, char* argv[])
{
  // call the asm file and store the value returned from it
  double a = manager();

  //output the time of computation in nanoseconds and end message to console
  printf("\nThe main function has received this number %.5lf and will keep it for future reference.\n", a);
  printf("The main function will return a zero to the operating system.\n");

  return 0;
}