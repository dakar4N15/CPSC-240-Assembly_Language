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
;  File name: normalize.asm
;  Language: X86-64
;  Syntax: Intel
;  Max page width: 172 columns
;  Optimal print specification: Landscape, 7-point font, monospace, 172 columns, 8½x11 paper
;  Assemble: nasm -f elf64 -l normalize.lis -o normalize.o normalize.asm
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
;  This file normalize the 64 bit random numbers produced by rdrand that is stored in an array so that it is within the interval 1.0<=num<2.0
;
;Project information
;  Project files: main.cpp, executive.asm, fill_random_array.asm, show_array.asm, compare.c, normalize.asm, isnan.asm, r.sh
;  Status: Available for public review.
;
;Translator information
;  Linux: nasm -f elf64 -l normalize.lis -o normalize.o normalize.asm
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
global normalize

segment .data

segment .bss

segment .text

normalize:                 ;start execution of program

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

mov r13, rdi    ;r13 now stores the array
mov r14, rsi    ;r14 now stores the size of array
mov r15, 0      ;counter for loop

;========== normalize all the random numbers in the array ==================================================================================================================
beginLoop:                  ;start of loop
    cmp r15, r14            ;compare counter with size of array
    je exitLoop             ;if counter already equal size of array, exit the loop
    mov r12, [r13 + 8*r15]  ;move the random number stored in a specific location of the array to r12
    shl r12, 12             ;shift left r12 by 12 so now r12 have mantissa followed by trailing zeros
    shr r12, 12             ;shift right r12 by 12 so now r12 have 12 zeros infront followed by the mantissa
    mov rbx, 1023           ;rbx now contains 3FF. 3FF is a number between 1.0<=num<2.0
    shl rbx, 52             ;shift left rbx by 52 so that it has 3FF infront followed by trailing zeros
    or r12, rbx             ;merge r12 and rbx together so that it forms a complete IEEE754 number between 1.0<=num<2.0
    mov [r13 + 8*r15], r12  ;move r12 back into the same specific location in the array to replace the old number with the new normalized number
    inc r15                 ;increment counter to repeat until all numbers in the array are normalized
    jmp beginLoop           ;jump to start of loop
exitLoop:                   ;if done, exit the loop here

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
;========== End of program normalize.asm =================================================================================================================================
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
