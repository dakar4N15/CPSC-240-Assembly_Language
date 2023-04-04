;***************************************************************************************************************************
;Program name: "Pythagoras Triangle".  This program  will compute the length of the hypotenuse of a right triangle given the*
;lengths of the two sides. The X86 collects the two sides from user and calculate the hypotenuse length, and the C++ receives*
;the length of the hypotenuse side from X86.  Copyright (C) 2023  William Sutanto                                           *
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
;  Program name: Pythagoras Triangle
;  Programming languages: One module in C++ and one module in X86
;  Date program began: 2023-Jan-31
;  Date of last update: 2023-Feb-02
;  Comments reorganized: 2023-Feb-02
;  Files in the program: driver.cpp, pythagoras.asm, r.sh
;
;Purpose
;  Build a program in assembly language that will compute the length of the hypotenuse of a right triangle given the lengths of the two sides.
;
;This file
;  File name: pythagoras.asm
;  Language: X86-64
;  Syntax: Intel
;  Max page width: 172 columns
;  Optimal print specification: Landscape, 7-point font, monospace, 172 columns, 8½x11 paper
;  Assemble: nasm -f elf64 -l pythagoras.lis -o pythagoras.o pythagoras.asm
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;
;Author information
;  Author name: William Sutanto
;  Author email: wsutanto@csu.fullerton.edu
;
;Program information
;  Program name: Pythagoras Triangle
;  Programming languages: X86 with one module in C++
;  Date program began: 2023-Jan-31
;  Date of last update: 2023-Feb-02
;
;Purpose
;  Build a program in assembly language that will compute the length of the hypotenuse of a right triangle given the lengths of the two sides.
;
;Project information
;  Project files: driver.cpp, pythagoras.asm, r.sh
;  Status: Available for public review.
;
;Translator information
;  Linux: nasm -f elf64 -l pythagoras.lis -o pythagoras.o pythagoras.asm
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
; Declare external C++ functions & make funct 'pythagoras' visible to other languages & create constant
extern printf                       
extern scanf                        
global pythagoras        

segment .data                       ;Place initialized data here

;========== message to be printed to user =================================================================================================================================
side1prompt db "Enter the length of the first side of the triangle:   ",0         ;to prompt user for length of first side of triangle
side2prompt db "Enter the length of the second side of the triangle:   ",0        ;to prompt user for length of second side of triangle
confirm db 10,"Thank you. You entered two sides:   %.6lf and %.6lf.",10, 0           ;output the length of two sides of triangle entered by user
output_hypotenuse db "The length of the hypotenuse is  %.6lf.", 10, 0            ;output the length of hypotenuse side
reject_negative db "Negative values not allowed.  Try again:        ",0                 ;error message when user input negative value for side of triangle

one_float_format db "%lf",0

zeroData dq 0.0     ;declare 0 to be compared to check for negative inputs

segment .bss

segment .text

pythagoras:         ;start execution of program

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

push qword 0                ;registers rax, rip, rsp are usually not backed up

;========== prompt the length for first side of triangle =================================================================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, side1prompt        ;Move message to print to general purpose register rdi
                            ;"Enter the length of the first side of the triangle: "
call printf                 ;Call external C++ print function
pop rax                     ;Remove the earlier push of the 16-byte boundary

;========== Extract user input by scanf block ============================================================================================================================
back1:
push qword 0                ;reserve space in memory for the incoming number
mov rax, 1                  ;1 xmm register will be used in this scanf section
mov rdi, one_float_format   ;"%lf"
mov rsi, rsp                ;point scanf to the reserved storage
call scanf                  ;Call external C++ input function
movsd xmm10, [rsp]          ;xmm10 register now have the value of user input
pop rax                     ;remove the earlier push

;========== check user input for negative value ===========================================================================================================================
movsd xmm5, qword [zeroData]  ;move the initialized data zero to xmm5 register
ucomisd xmm10, xmm5           ;compare the user input stored in xmm10 to zero
jb isNegative1                ;jump to the portion isNegative1 if input is negative i.e. program will prompt user until positive value is entered
jmp continue1                 ;jump to continue1 if input is not negative i.e. the program continues to prompt user for second side

;========== if input is negative, print input is negative =================================================================================================================
isNegative1:
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;0 xmm register is used in this section
mov rdi, reject_negative    ;"Negative values not allowed. Try again: "
call printf                 ;call external C++ print function
pop rax                     ;remove earlier push
jmp back1                   ;jump to back1 to get new user input

;========== prompt the length for second side of triangle =================================================================================================================
continue1:                  ;if not negative, continue here
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;0 XMM register used in this section
mov rdi, side2prompt        ;"Enter the length of the second side of the triangle: "
call printf                 ;call external C++ print function
pop rax                     ;remove earlier push

;========== Extract user input by scanf block ============================================================================================================================
back2:
push qword 0                ;reserve space in memory for incoming number
mov rax, 1                  ;1 xmm register will be used in this input section
mov rdi, one_float_format   ;"%lf"
mov rsi, rsp                ;point scanf to the reserved storage
call scanf                  ;call external C++ input function
movsd xmm11, [rsp]          ;store the input in xmm11 register
pop rax                     ;remove earlier push

;========== check user input for negative value ==========================================================================================================================
movsd xmm5, qword [zeroData]  ;move the initialized data zero to xmm5 register
ucomisd xmm11, xmm5           ;compare the user input stored in xmm11 to zero
jb isNegative2                ;jump to the portion isNegative2 if input is below 0 i.e. program will prompt user until positive value is entered
jmp continue2                 ;jump to continue2 if input is not negative i.e. the program continues to prompt user for second side

;========== if input is negative, print input is negative ===============================================================================================================
isNegative2:
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;0 xmm register will be used in this section
mov rdi, reject_negative    ;"Negative values not allowed. Try again: "
call printf                 ;call external C++ print function
pop rax                     ;remove earlier push
jmp back2                   ;jump to back2 to get new user input

;========== output the two sides entered ===============================================================================================================================
continue2:
push qword 0          ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 2            ;2 xmm registers will be used in this section
movsd xmm0, xmm10     ;move the input value stored in xmm10 to xmm0 for the purpose of printing output
movsd xmm1, xmm11     ;move the input value stored in xmm11 to xmm1 for the purpose of printing output
mov rdi, confirm      ;"Thank you. You entered two sides: %.8lf and %.8lf."
call printf           ;call external c++ print function
pop rax               ;remove earlier push

;========== calculate hypotenuse length ================================================================================================================================
movsd xmm12, xmm10    ;copy first side
movsd xmm13, xmm11    ;copy second side
mulsd xmm12, xmm12    ;a^2
mulsd xmm13, xmm13    ;b^2
addsd xmm12, xmm13    ;a^2 + b^2
sqrtsd xmm14, xmm12   ;sqrt(a^2 + b^2)

;========== output hypotenuse length ===================================================================================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte memory
mov rax, 1                  ;1 xmm register will be used in this section
movsd xmm0, xmm14           ;move hypotenuse length stored in xmm14 to xmm0 for the purpose of printing output
mov rdi, output_hypotenuse  ;"The length of the hypotenuse is %.12lf."
call printf                 ;call external c++ print function
pop rax                     ;remove earlier push

movsd xmm0, xmm14           ;to return the hypotenuse length to cpp file
pop rax                     ;remove earlier push at beginning of code

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