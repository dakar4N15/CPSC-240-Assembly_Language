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
global append

segment .data

segment .bss

segment .text

append:                 ;start execution of program

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

mov r15, rdi        ;r15 holds arrayA
mov r14, rsi        ;r14 holds the size of arrayA
mov r13, rdx        ;r13 holds arrayB
mov r12, rcx        ;r12 holds the size of arrayB
mov r11, r8         ;r11 holds the combined_array
mov r10, 0          ;r10 stores the index of array A or B
mov r9, 0           ;r9 stores the index of combined array

;========== Append arrayA to the combined array ========================================================================================================================
begin_append_arrayA:
    movsd xmm10, [r15 + r10*8]      ;move float stored at a particular space in memory of arrayA to xmm10
    movsd [r11 + r9*8], xmm10       ;move the float stored in xmm10 to the combined array
    inc r10                         ;increment index of arrayA
    inc r9                          ;increment index of combined array
    cmp r10, r14                    ;compare if index is still within the boundary of arrayA
    jb begin_append_arrayA          ;if still within boundary, jump to beginning of loop to move more floats
    mov r10, 0                      ;reset index for appending arrayB next

;========== Append arrayB to the combined array =========================================================================================================================
begin_append_arrayB:
    movsd xmm10, [r13 + r10*8]      ;move float stored at a particular space in memory of arrayB to xmm10
    movsd [r11 + r9*8], xmm10       ;move the float stored in xmm10 to the combined array
    inc r10                         ;increment index of arrayB
    inc r9                          ;increment index of combined array
    cmp r10, r12                    ;compare if index is still within the boundary of arrayB
    jb begin_append_arrayB          ;if still within boundary, jump to beginning of loop to move more floats
    
mov rax, r9                     ;return index of combined array
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



