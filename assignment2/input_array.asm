;***************************************************************************************************************************
;Program name: "Arrays".  This program will prompt user to enter floats and store it into an array and calculate the        *   
;magnitude of that array. There will be 2 sets of arrays, so the program will repeat similar steps twice and at the end     *
;both arrays will be appended into a separate array and the magnitude of that array will be calculated as well. The magnitude*
;of the combined array will be returned to main. Main and display_array is implemented in c, and the rest is implemented    *
;in X86. Copyright (C) 2023  William Sutanto                                         *
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
;  Files in the program: main.c, manager.asm, display_array.c, magnitude.asm, append.asm, input_array.asm, isfloat.asm, r.sh
;
;Purpose
;  Build a program in assembly language that will take in floats from user and store it into an array. This program will repeat the steps twice
;  so that there will be 2 arrays and the magnitude of each array will be calculated. At the end, the 2 arrays will be combined into an array
;  and the magnitude of that array will be calculated and returned to main.
;
;This file
;  File name: input_array.asm
;  Language: X86-64
;  Syntax: Intel
;  Max page width: 172 columns
;  Optimal print specification: Landscape, 7-point font, monospace, 172 columns, 8½x11 paper
;  Assemble: nasm -f elf64 -l input_array.lis -o input_array.o input_array.asm
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;
;Author information
;  Author name: William Sutanto
;  Author email: wsutanto@csu.fullerton.edu
;
;Program information
;  Program name: Arrays
;  Programming languages: C, X86 assembly
;  Date program began: 2023-Feb-12
;  Date of last update: 2023-Feb-20
;
;Purpose
;  Build a program in assembly language that will take in floats from user and store it into an array. This program will repeat the steps twice
;  so that there will be 2 arrays and the magnitude of each array will be calculated. At the end, the 2 arrays will be combined into an array
;  and the magnitude of that array will be calculated and returned to main
;
;Project information
;  Project files: main.c, manager.asm, display_array.c, magnitude.asm, append.asm, input_array.asm, isfloat.asm, r.sh
;  Status: Available for public review.
;
;Translator information
;  Linux: nasm -f elf64 -l input_array.lis -o input_array.o input_array.asm
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
; Declare external C++ functions & make funct 'pythagoras' visible to other languages & create constant             
extern scanf            ;external C++ function to read input from console
extern printf           ;external C++ function to print to console
extern stdin            ;external C++ function involved to set failbit to zero
extern clearerr         ;external C++ function involved to set failbit to zero
extern atof             ;external C++ function that converts string to float
extern isfloat          ;asm module to check for float correctness
global input_array  

segment .data                       ;Place initialized data here
;========== message to be printed to user =================================================================================================================================
invalid_input db "The last input was invalid and not entered into the array.",10,0      ;tell user that the last input is not a vaild float

one_string_format db "%s",0


segment .bss

segment .text

input_array:         ;start execution of program

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

mov r13, rdi        ;this holds the array (array is in r13 now)
mov r14, rsi        ;this holds the max size of array
mov r15, 0          ;r15 now stores index to store floats into the array (starts at 0)

;========== extract floats from user and store into array ================================================================================================================
beginLoop:
    cmp r15, r14                    ;compare if index is still within boundary of max size of array
    je done                         ;jump to out of loop if capacity exceeded
    push qword 33                   ;reserve space in memory
    mov rax, 0                      ;no data from SSE will be printed i.e. 0 xmm registers used
    mov rdi, one_string_format      ;"%s"
    mov rsi, rsp                    ;point scanf to the reserved storage
    call scanf                      ;call external C++ function to read user input
    ;this section starts ctrl+d checking (if ctrl+d, exit the loop)
    cdqe
    cmp rax, -1                     ;if ctrl+d is entered, rax will be filled with -1
    je done                         ;if rax equal to -1, jump to done to exit loop
    ;check input by calling isfloat module
    mov rax, 0                      ;no data from SSE will be printed i.e. 0 xmm registers used
    mov rdi, rsp                    ;move the string extracted from user earlier using scanf to rdi so that it will be passed as first parameter to asm isfloat module
    call isfloat                    ;call asm isfloat module
    cmp rax, -1                     ;isfloat will return -1 if the previously entered string is a float and return 0 if not a float
    je continue                     ;if isfloat return -1 indicating that its a float, jump to continue to enter the float to array
    ;if invalid/value entered is not a float
    mov rax, 0                      ;no data from SSE will be printed i.e. 0 xmm registers used
    mov rdi, invalid_input          ;"The last input was invalid and not entered into the array."
    call printf                     ;call external C++ function to print
    pop rax                         ;remove earlier push at the beginning of beginLoop
    jmp beginLoop                   ;jump to beginning of loop to continue extract inputs from user
    ;if valid/value entered is a float
    continue:
        mov rdi, rsp                ;move the string extracted by scanf earlier to rdi so that it will passed when calling atof module
        call atof                   ;call external C++ function to convert string into float
        movsd xmm15, xmm0           ;store the float returned by atof in xmm15
        movsd [r13 + r15*8], xmm15  ;store the float into array
        inc r15                     ;increment index to store the next float into the array
        pop rax                     ;remove earlier push at the beginning of beginLoop
        jmp beginLoop               ;jump to beginning of loop to continue extract inputs from user

done:
;Block to set the failbit to zero. Equivalent to cin.clear()
mov rax, 0
mov rdi, [stdin]
call clearerr

pop rax             ;remove earlier push at the beginning of beginLoop
pop rax             ;counter push at beginning
mov rax, r15        ;store the index of the array, to be return to manager.asm to keep number of floats in the array

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

