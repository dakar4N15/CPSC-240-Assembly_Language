;***************************************************************************************************************************
;Program name: "Random Numbers". This program will generate qword (random numbers) with a specified amount given by the     *
;user and store those values into an array. The values of these random numbers will be printed in both IEEE754 and          *
;scientific decimal format. Furthermore, the numbers in this array will also be sorted in the order from smallest to largest*
;and then normalized so that it lies within the interval 1.0<=num<2.0.The unsorted, sorted, and normalized version of the   *
;array will all be printed in both IEEE754 and scientific decimal format. 
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
;  Program name: Random Numbers
;  Programming languages: C++, C, X86 assembly
;  Date program began: 2023-March-5
;  Date of last update: 2023-March-8
;  Comments reorganized: 2023-March-8
;  Files in the program: main.cpp, executive.asm, fill_random_array.asm, show_array.asm, compare.c, normalize.asm, isnan.asm, r.sh
;
;Purpose
;  Build a program in assembly language that will generate up to 100 random numbers using the non-deterministic random number generator
;  found inside of x86 microprocessors. Random numbers that are generated extend throughout the entire space of all 64-bit IEEE754 numbers.
;  The amount of random number to be generated is given by user and those numbers will be stored in an array. These numbers will be sorted 
;  in the order from smallest to largest and normalized within the interval 1.0<=num<2.0.
;  The initial, sorted, and normalized version of the array will be printed in both IEEE754 and scientific decimal format. 
;
;This file
;  File name: show_array.asm
;  Language: X86-64
;  Syntax: Intel
;  Max page width: 172 columns
;  Optimal print specification: Landscape, 7-point font, monospace, 172 columns, 8½x11 paper
;  Assemble: nasm -f elf64 -l show_array.lis -o show_array.o show_array.asm
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;
;Author information
;  Author name: William Sutanto
;  Author email: wsutanto@csu.fullerton.edu
;
;Program information
;  Program name: Random numbers
;  Programming languages: C, C++, X86 assembly
;  Date program began: 2023-March-5
;  Date of last update: 2023-March-8
;
;Purpose
;  This asm file receives an array filled with qwords as the first parameter and the size of the array as the second parameter.
;  This function will loop through the array and print the qwords both in IEEE754 and scientific decimal format.
;
;Project information
;  Project files: main.cpp, executive.asm, fill_random_array.asm, show_array.asm, compare.c, normalize.asm, isnan.asm, r.sh
;  Status: Available for public review.
;
;Translator information
;  Linux: nasm -f elf64 -l show_array.lis -o show_array.o show_array.asm
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
extern printf       ;external C++ print function
global show_array

segment .data
;========== message to be printed to user =================================================================================================================================
heading db "IEEE754		   Scientific Decimal",10,0     ;header to organize output of IEEE754 and scientific decimal format
line db "0x%016lx %-18.13e", 10, 0                      ;this will output the qword in IEEE754 format first and scientific decimal format second

segment .bss

segment .text

show_array:                 ;start execution of program

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

push qword 0        ;push to remain on the boundary

mov r13, rdi        ;r13 now stores the array
mov r14, rsi        ;r14 now stores the size of array
mov r15, 0          ;counter for loop

;========== output heading =============================================================================================================================================
push qword 0        ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0          ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, heading    ;"IEEE754		   Scientific Decimal"
call printf         ;call external C++ print function
pop rax             ;remove earlier push

;========= loop through each qword in the array and print in both IEEE754 and scientific decimal format ================================================================
beginLoop:
    cmp r15, r14                ;compare counter with size of array
    je outofLoop                ;if equal, all qwords in the array have been looped through, then exit
        
    push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
    mov rax, 1                  ;1xmm register will be printed
    mov rdi, line               ;"0x%016lx %-18.13e"
    mov rsi, [r13 + 8*r15]      ;move the qword in a specific location of the array to rsi
    movsd xmm0, [r13 + 8*r15]   ;move the qword in a specific location of the array to xmm0
    call printf                 ;call external C++ print function
    pop rax                     ;remove earlier push
    
    inc r15                     ;increment counter to move on to next qword in the array
    jmp beginLoop               ;jump to beginning of loop to repeat printing qwords in the array
outofLoop:                      ;if done, continue here

pop rax             ;counter push at beginning

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
;========== End of program show_array.asm =================================================================================================================================
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
