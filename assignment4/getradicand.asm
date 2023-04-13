;***************************************************************************************************************************
;Program name: "Benchmark". This program is coded in a combination of c++ as the main file and assembly for the manager,    *
;getradicand and get_clock_freq modules, including one bash file. The purpose of this program is to benchmark the           *
;performance of your device's CPU upon running the square root instruction in SSE and also the square root program in the   *
;standard C library.
;Copyright (C) 2023  William Sutanto                                                                                        *
;This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
;version 3 as published by the Free Software Foundation.                                                                    *
;This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied         *
;warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
;A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.                           *
;****************************************************************************************************************************



;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**

;Author information
;  Author name: William Sutanto
;  Author email: wsutanto@csu.fullerton.edu
;
;Program information
;  Program name: Benchmark
;  Programming languages: C++, X86 assembly
;  Date program began: 2023-April-10
;  Date of last update: 2023-April-12
;  Comments reorganized: 2023-April-12
;  Files in the program: main.cpp, manager.asm, get_clock_freq.asm, getradicand.asm, r.sh
;
;Purpose
;  This asm module prompts user to enter a floating radicand number and extracts it. The float will be returned in xmm0
;
;This file
;  File name: getradicand.asm
;  Language: X86-64
;  Syntax: Intel
;  Max page width: 172 columns
;  Optimal print specification: Landscape, 7-point font, monospace, 172 columns, 8½x11 paper
;  Assemble: nasm -f elf64 -l getradicand.lis -o getradicand.o getradicand.asm
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;
;Author information
;  Author name: William Sutanto
;  Author email: wsutanto@csu.fullerton.edu
;
;Program information
;  Program name: Benchmark
;  Programming languages: C++, X86 assembly
;  Date program began: 2023-April-10
;  Date of last update: 2023-April-12
;
;Purpose
;  This program will run a benchmark test on your device's CPU performance by running the square root instruction in SSE and 
;  also the square root program in the standard C library. The main objective is to find how much time is required for a single
;  sqrt instruction to execute. This program will first identify your CPU name, type, and max clock speed. Then, this program 
;  will prompt user for a float to be used for square root benchmarking, followed by the number of times the iteration should 
;  be performed. Next, this program will get the time on the clock in tics before the iteration starts, iterate the sqrt instruction 
;  for the user's specified amount of times, and get the time on the clock in tics again after the iteration process finished. 
;  The elapsed time in tics will be displayed to the user, along with the time for one square root computation in tics and nano seconds.
;
;Project information
;  Project files: main.cpp, manager.asm, get_clock_freq.asm, getradicand.asm, r.sh
;  Status: Available for public review.
;
;Translator information
;  Compile this file: nasm -f elf64 -l getradicand.lis -o getradicand.o getradicand.asm
;  Link the project files: g++ -m64 -std=c++17 -fno-pie -no-pie -o final.out main.o manager.o get_clock_freq.o getradicand.o
;
;References and credits
;
;
;Format information
;  Page width: 172 columns
;  Begin comments: 61
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;
;
;
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;
;===== Begin code area ====================================================================================================================================================
extern printf           ;external C++ function to print to console
extern scanf            ;external C++ function to read input from console

global getradicand      

segment .data       ;Place initialized data here
;========== message to be printed to user =================================================================================================================================
promptRadicand db 10,"Please enter a floating radicand for square root bench marking: ",0      ;prompt user for float to be used for square root benchmarking

one_float_format db "%lf",0

segment .bss

segment .text

getradicand:                 ;start execution of program

;Prolog ===== Insurance for any caller of this assembly module ============================================================================================================
;Any future program calling this module that the data in the caller's GPRs will not be modified.
push rbp                                                    ;Push memory address of base of previous stack frame onto stack top
mov  rbp,rsp                                                ;Copy value of stack pointer into base pointer, rbp = rsp = both point to stack top
; Rbp now holds the address of the new stack frame, i.e "top" of stack
push rdi                                                    ;Backup rdi
push rsi                                                    ;Backup rsi
push rdx                                                    ;Backup rdx
push rcx                                                    ;Backup rcx
push r8                                                     ;Backup r8
push r9                                                     ;Backup r9
push r10                                                    ;Backup r10
push r11                                                    ;Backup r11
push r12                                                    ;Backup r12
push r13                                                    ;Backup r13
push r14                                                    ;Backup r14
push r15                                                    ;Backup r15
push rbx                                                    ;Backup rbx
pushf                                                       ;Backup rflags

push qword 0                    ;push to remain on the boundary

;========== Output prompt to ask user to input float ===================================================================================================================
push qword 0                    ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                      ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, promptRadicand         ;"Please enter a floating radicand for square root bench marking: "
call printf                     ;call external C++ print function
pop rax                         ;remove earlier push

;========== Extract user input using scanf =============================================================================================================================
push qword 0                    ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 1                      ;1 xmm register will be printed in this section
mov rdi, one_float_format       ;"%lf"
mov rsi, rsp                    ;point scanf to the reserved storage
call scanf                      ;call external C++ function to extract user input
movsd xmm0, [rsp]               ;move the float entered by user to xmm0
pop rax                         ;remove earlier push

pop rax                         ;counter push at the beginning of program
;===== Restore original values to integer registers ====================================================================================================================
popf                                                        ;Restore rflags
pop rbx                                                     ;Restore rbx
pop r15                                                     ;Restore r15
pop r14                                                     ;Restore r14
pop r13                                                     ;Restore r13
pop r12                                                     ;Restore r12
pop r11                                                     ;Restore r11
pop r10                                                     ;Restore r10
pop r9                                                      ;Restore r9
pop r8                                                      ;Restore r8
pop rcx                                                     ;Restore rcx
pop rdx                                                     ;Restore rdx
pop rsi                                                     ;Restore rsi
pop rdi                                                     ;Restore rdi
pop rbp                                                     ;Restore rbp

ret
;========== End of program getradicand.asm =================================================================================================================================
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
