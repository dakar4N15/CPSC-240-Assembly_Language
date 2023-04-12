;***************************************************************************************************************************
;Program name: "Arrays".  This program will prompt user to enter floats and store it into an array and calculate the        *   
;magnitude of that array. There will be 2 sets of arrays, so the program will repeat similar steps twice and at the end     *
;both arrays will be appended into a separate array and the magnitude of that array will be calculated as well. The magnitude*
;of the combined array will be returned to main. Main and display_array is implemented in c, and the rest is implemented    *
;in X86. Copyright (C) 2023  William Sutanto                                                                                *
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
;  Program name: Arrays
;  Programming languages: C, X86 assembly
;  Date program began: 2023-Feb-12
;  Date of last update: 2023-Feb-20
;  Comments reorganized: 2023-Feb-20
;  Files in the program: main.c, manager.asm, display_array.c, magnitude.asm, append.asm, input_array.asm, isfloat.asm r.sh
;
;Purpose
;  Build a program in assembly language that will take in floats from user and store it into an array. This program will repeat the steps twice
;  so that there will be 2 arrays and the magnitude of each array will be calculated. At the end, the 2 arrays will be combined into an array
;  and the magnitude of that array will be calculated and returned to main.
;
;This file
;  File name: append.asm
;  Language: X86-64
;  Syntax: Intel
;  Max page width: 172 columns
;  Optimal print specification: Landscape, 7-point font, monospace, 172 columns, 8½x11 paper
;  Assemble: nasm -f elf64 -l append.lis -o append.o append.asm
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;
;Author information
;  Author name: William Sutanto
;  Author email: wsutanto@csu.fullerton.edu
;
;Program information
;  Program name: Arrays
;  Programming languages: X86, C
;  Date program began: 2023-Feb-12
;  Date of last update: 2023-Feb-20
;
;Purpose
;   Build a program in assembly language that will take in floats from user and store it into an array. This program will repeat the steps twice
;  so that there will be 2 arrays and the magnitude of each array will be calculated. At the end, the 2 arrays will be combined into an array
;  and the magnitude of that array will be calculated and returned to main.
;
;Project information
;  Project files: main.c, manager.asm, display_array.c, magnitude.asm, append.asm, input_array.asm, isfloat.asm, r.sh
;  Status: Available for public review.
;
;Translator information
;  Linux: nasm -f elf64 -l append.lis -o append.o append.asm
;
;References and credits
;   Professor Floyd Holliday's website for isfloat.asm module 
;   https://sites.google.com/a/fullerton.edu/activeprofessor/4-subjects/x86-programming/library-software/isfloat-x86-only
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
extern printf
extern scanf
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

push qword 0
;========== Output prompt to ask user to input float ===================================================================================================================
push qword 0
mov rax, 0
mov rdi, promptRadicand
call printf
pop rax

;========== Extract user input using scanf =============================================================================================================================
push qword 0
mov rax, 1
mov rdi, one_float_format
mov rsi, rsp
call scanf
movsd xmm0, [rsp]
pop rax

pop rax
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
;========== End of program pythagoras.asm =================================================================================================================================
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
