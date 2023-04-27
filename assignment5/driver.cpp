//***************************************************************************************************************************
//Program name: "Benchmark and data validation". This program will compute the sin value from an angle in degrees and get the*
//number of tics elapsed to get the sin value using Taylor series in a specific number of terms. This program will also      *
//compute the sin value using the sin function in the math C library, including the number of tics elapsed for comparison.   *
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
//  Program name: Benchmark and data validation
//  Programming languages: Main in C++, manager in asm, isfloat in asm
//  Date program began: 2023-April-25
//  Date of last update: 2023-April-27
//  Comments reorganized: 2023-April-27
//  Files in the program: driver.cpp, manager.asm, isfloat.asm, r.sh
//
//Purpose
//  This program will prompt user for an angle number in degrees and the number of terms in
//  a taylor series to be computed. Next, this program will compute the sin value using Taylor
//  series for the user specified amount of terms while getting the tics elapsed to run the program.
//  This program will output to user the number of tics elapsed for computing sin value using Taylor
//  series and the result from the calculation. After that, the program will use the same angle value
//  to compute the sin value using the sin function in C library while getting the number of tics
//  as well for comparison. This program will validate user's input for the float entered for use as
//  the angle for calculation. If invalid data is entered, program will keep asking user until
//  correct format is entered.
//
//This file
//  File name: driver.cpp
//  Language: C++
//  Max page width: 172 columns
//  Optimal print specification: 7 point font, monospace, 172 columns, 8½x11 paper
//  Compile: g++ -c -m64 -Wall -std=c++14 -fno-pie -no-pie -o driver.o driver.cpp
//  Link: g++ -m64 -std=c++17 -fno-pie -no-pie -o final.out driver.o manager.o isfloat.o
//
//Execution: ./final.out
//
//===== Begin code area ===================================================================================================================================================

#include <stdio.h>
#include <stdint.h>
#include <time.h>
#include <sys/time.h>
#include <stdlib.h>
#include <math.h>

extern "C" double manager();           // Declare the external ASM function using the "C" directive to pass parameters in the CCC standard

int main(int argc, char* argv[])
{
  //output welcome message
  printf("Welcome to Asterix Software Development Corporation\n");

  // call the asm file and store the value returned from it
  double a = manager();

  //output the time of computation in nanoseconds and end message to console
  printf("\nThank you for using this program.  Have a great day.\n");
  printf("\nThe driver program received this number %.12lf. A zero will be returned to the OS.  Bye.\n", a);

  return 0;
}