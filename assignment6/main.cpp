//***************************************************************************************************************************
//Program name: "Sleep time". This program will output a happy birthday message for chris for a user specified amount of     *
//times followed by a sleep block for user specified amount of time after outputting each message. The time on the clock in  *
//tics before and after the process is recorded to get the elapsed tics.
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
// Program information
// Program name: Sleep time
// Programming languages: C++, X86 assembly
// Date program began: 2023-May-03
// Date of last update: 2023-May-04
// Comments reorganized: 2023-May-04
// Files in the program: main.cpp, birthday.asm, r.sh
//
//Purpose
//  This program will first prompt the user for the amount of birthday cards to be outputted, the delay
//  time in milliseconds between outputting the message, and the max frequency of the cpu. Then, the 
//  time on the clock in tics is recorded, and the iterations of outputting the birthday messages for
//  user specified amount of times followed by the sleep block is executed. At the end of the process,
//  the time on the clock in tics is recorded again and from there we could obtain the elapsed tics
//  for the whole process.
//
//This file
//  File name: main.cpp
//  Language: C++
//  Max page width: 172 columns
//  Optimal print specification: 7 point font, monospace, 172 columns, 8½x11 paper
//  Compile: g++ -c -m64 -Wall -std=c++14 -fno-pie -no-pie -o main.o main.cpp
//  Link: g++ -m64 -std=c++17 -fno-pie -no-pie -o final.out main.o birthday.o
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
#include <unistd.h>

extern "C" long long unsigned int birthday();           // Declare the external ASM function using the "C" directive to pass parameters in the CCC standard

int main(int argc, char* argv[])
{
  //output welcome message
  printf("Welcome to Daylight Sleeping Time brought to you by William Sutanto\n");

  // call the asm file and store the value returned from it
  long long unsigned int a = birthday();

  //output the time of computation in tics and end message to console
  printf("\nThe main received this number %llu and will keep it.\n", a);
  printf("\nA zero will be sent to the Operating System.  Bye.\n");

  return 0;
}