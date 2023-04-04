//***************************************************************************************************************************
//Program name: "Pythagoras Triangle".  This program  will compute the length of the hypotenuse of a right triangle given the*
//lengths of the two sides. The X86 collects the two sides from user and calculate the hypotenuse length, and the C++ receives*
//the length of the hypotenuse side from X86.  Copyright (C) 2023  William Sutanto                                           *
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
//  Program name: Pythagoras Triangle
//  Programming languages: Main function in C++; pythagoras triangle function in X86
//  Date program began: 2023-Jan-31
//  Date of last update: 2023-Feb-02
//  Comments reorganized: 2023-Feb-02
//  Files in the program: driver.cpp, pythagoras.asm, r.sh
//
//Purpose
//  Build a program in assembly language that will compute the length of the hypotenuse of a right triangle given the lengths of the two sides.
//
//This file
//  File name: driver.cpp
//  Language: C++
//  Max page width: 172 columns
//  Optimal print specification: 7 point font, monospace, 172 columns, 8½x11 paper
//  Compile: g++ -c -m64 -Wall -std=c++14 -fno-pie -no-pie -o driver.o driver.cpp
//  Link: g++ -m64 -std=c++14 -fno-pie -no-pie -o final.out pythagoras.o driver.o
//
//Execution: ./final.out
//
//===== Begin code area ===================================================================================================================================================

#include <stdio.h>
#include <stdint.h>
#include <time.h>
#include <sys/time.h>
#include <stdlib.h>

extern "C" double pythagoras();           // Declare the external ASM function using the "C" directive to pass parameters in the CCC standard

int main(int argc, char* argv[])
{
  //greet the user
  printf("Welcome to Pythagoras’ Math Lab programmed by William Sutanto\n");
  printf("Please contact me at  wsutanto@csu.fullerton.edu  if you need assistance.\n\n");

  // call the asm file and store the value returned from it
  double p = pythagoras();

  //output the hypotenuse length and end message to console
  printf("\nThe main file received this number: %.12lf, and will keep it for now.\n", p);
  printf("We hoped you enjoyed your right angles. Have a good day. A zero will be sent to your\n");
  printf("operating system.\n");
  return 0;
}