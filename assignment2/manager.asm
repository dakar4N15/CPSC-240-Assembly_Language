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
;  Files in the program: main.c, manager.asm, display_array.c, magnitude.asm, append.asm, input_array.asm, isfloat.asm, r.sh
;
;Purpose
;  Build a program in assembly language that will take in floats from user and store it into an array. This program will repeat the steps twice
;  so that there will be 2 arrays and the magnitude of each array will be calculated. At the end, the 2 arrays will be combined into an array
;  and the magnitude of that array will be calculated and returned to main.
;
;This file
;  File name: manager.asm
;  Language: X86-64
;  Syntax: Intel
;  Max page width: 172 columns
;  Optimal print specification: Landscape, 7-point font, monospace, 172 columns, 8½x11 paper
;  Assemble: nasm -f elf64 -l manager.lis -o manager.o manager.asm
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
;  Linux: nasm -f elf64 -l manager.lis -o manager.o manager.asm
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
; Declare external C++ functions & make funct 'manager' visible to other languages & create constant
extern printf            ;external C++ function to print to console
extern scanf             ;external C++ function to read input from console
extern input_array       ;asm module to read input of floats from console and store it into an array
extern display_array     ;C module to display floats in an array
extern magnitude         ;asm module to calculate magnitude of all floats stored in an array
extern append            ;asm module to append arrayA and arrayB to a single combined array
global manager        

segment .data                       ;Place initialized data here
;========== message to be printed to user =================================================================================================================================
welcome db "This program will manage your arrays of 64-bit floats",10,0                              ;output a welcome message to user
prompt_arrayA db "For array A enter a sequence of 64-bit floats separated by white space.",10,0      ;to prompt user to enter floats for array A
prompt_arrayB db 10,"For array B enter a sequence of 64-bit floats separated by white space.",10,0   ;to prompt user to enter floats for array B
prompt_enter db "After the last input press enter followed by Control+D: ",10,0                      ;after this line user will have to enter floats
confirm_arrayA db 10,"These number were received and placed into array A:",10,0                      ;output floats entered for array A
confirm_arrayB db 10,"These number were received and placed into array B:",10,0                      ;output floats entered for array B
output_arrayA db "The magnitude of array A is %.5lf",10,0                                            ;output magnitude of array A
output_arrayB db "The magnitude of this array B is %.5lf",10,0                                       ;output magnitude of array B
confirm_appended db 10,"Arrays A and B have been appended and given the name A⊕ B.",10,0            ;let user know that array A and B have been appended
output_AB db "A⊕ B contains",10,0                                                                   ;output appended A+B
output_magnitudeAB db 10,"The magnitude of  A⊕ B is %.5lf",10,0                                     ;output magnitude of appended A+B

max equ 50  ;declare array size


segment .bss
arrayA resq max         ;declare array A
arrayB resq max         ;declare array B
combined_array resq max ;declare combined array of A and B

segment .text

manager:         ;start execution of program

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

push qword 0                   ;push to remain on the boundary

;========== Output welcome message =====================================================================================================================================
push qword 0                    ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                      ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, welcome                ;"This program will manage your arrays of 64-bit floats"
call printf                     ;call the external C++ print function
pop rax                         ;remove the earlier push

;========== Output prompt for array A ==================================================================================================================================
push qword 0                    ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                      ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, prompt_arrayA          ;"For array A enter a sequence of 64-bit floats separated by white space."
call printf                     ;call the external C++ print function
pop rax                         ;remove earlier push

;========== Output instruction for user to enter floats ================================================================================================================
push qword 0                    ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                      ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, prompt_enter           ;"After the last input press enter followed by Control+D: "
call printf                     ;call the external C++ print function
pop rax                         ;remove earlier push

;========== Fill the array using the input_array module ===============================================================================================================
push qword 0                    ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                      ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, arrayA                 ;move arrayA to rdi so that it will be the first parameter being passed when calling input_array module
mov rsi, max                    ;move size of arrayA to rsi so that it will be the second parameter being passed when calling input_array module
call input_array                ;call input_array asm module to fill the array with floats entered by user
mov r15, rax                    ;r15 stores the count of floats entered into the array
pop rax                         ;remove earlier push

;========== Heading to output floats that were entered into arrayA ====================================================================================================
push qword 0                    ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                      ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, confirm_arrayA         ;"These number were received and placed into array A:"
call printf                     ;call the external C++ function
pop rax                         ;remove earlier push

;========== Output floats that were entered into arrayA by calling display_array module ===============================================================================
push qword 0                    ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                      ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, arrayA                 ;move arrayA to rdi so that it will be the first parameter being passed when calling display_array module
mov rsi, r15                    ;move r15 to rsi so that it will be the second parameter being passed when calling display_array module
call display_array              ;call the display_array module that will output floats stored in the array in a single line separated by white spaces
pop rax                         ;remove earlier push

;========== Compute magnitude of arrayA by calling magnitude module ======================================================================================================
push qword 0                    ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                      ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, arrayA                 ;move arrayA to rdi so that it will be the first parameter being passed when calling magnitude module
mov rsi, max                    ;move size of arrayA to rsi so that it will be the second parameter passed when calling magnitude module
call magnitude                  ;call magnitude module that will calculate the magnitude of the floats in arrayA
movsd xmm15, xmm0               ;xmm15 now contains the magnitude of arrayA
pop rax                         ;remove earlier push

;========== Output magnitude of arrayA =================================================================================================================================
push qword 0                    ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 1                      ;1 xmm register will be printed
mov rdi, output_arrayA          ;"The magnitude of array A is %.5lf"
movsd xmm0, xmm15               ;move magnitude of arrayA stored in xmm15 to xmm0 to be printed
call printf                     ;call external C++ print function
pop rax                         ;remove earlier push


;========== Output prompt for array B ==================================================================================================================================
push qword 0                    ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                      ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, prompt_arrayB          ;"For array B enter a sequence of 64-bit floats separated by white space."
call printf                     ;call external C++ function to print
pop rax                         ;remove earlier push

;========== Output instruction for user to enter floats ================================================================================================================
push qword 0                    ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                      ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, prompt_enter           ;"After the last input press enter followed by Control+D: "
call printf                     ;call external C++ function to print
pop rax                         ;remove earlier push

;========== Fill the array using the input_array module ===============================================================================================================
push qword 0                    ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                      ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, arrayB                 ;move arrayB to rdi so that it will be the first parameter being passed when calling input_array module
mov rsi, max                    ;move size of arrayB to rsi so that it will be the second parameter being passed when calling input_array module
call input_array                ;call input_array asm module to fill the array with floats entered by user
mov r14, rax                    ;r14 stores the count of floats entered into the array
pop rax                         ;remove earlier push

;========== Heading to output floats that were entered into arrayB ====================================================================================================
push qword 0                    ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                      ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, confirm_arrayB         ;"These number were received and placed into array B:"
call printf                     ;call external C++ function to print
pop rax                         ;remove earlier push

;========== Output floats that were entered into arrayB by calling display_array module ===============================================================================
push qword 0                    ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                      ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, arrayB                 ;move arrayB to rdi so that it will be the first parameter being passed when calling display_array module
mov rsi, r14                    ;move r15 to rsi so that it will be the second parameter being passed when calling display_array module
call display_array              ;call the display_array module that will output floats stored in the array in a single line separated by white spaces
pop rax                         ;remove earlier push

;========== Compute magnitude of arrayB by calling magnitude module ======================================================================================================
push qword 0                    ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                      ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, arrayB                 ;move arrayB to rdi so that it will be the first parameter being passed when calling magnitude module
mov rsi, max                    ;move size of arrayA to rsi so that it will be the second parameter passed when calling magnitude module
call magnitude                  ;call magnitude module that will calculate the magnitude of the floats in arrayB
movsd xmm15, xmm0               ;xmm15 now contains the magnitude of arrayB
pop rax                         ;remove earlier push

;========== Output magnitude of arrayB =================================================================================================================================
push qword 0                    ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 1                      ;1 xmm register will be printed
mov rdi, output_arrayB          ;"The magnitude of array B is %.5lf"
movsd xmm0, xmm15               ;move magnitude of arrayB stored in xmm15 to xmm0 to be printed
call printf                     ;call external C++ print function
pop rax                         ;remove earlier push

;========== Output heading to tell user that arrayA and arrayB have been appended =======================================================================================
push qword 0                    ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                      ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, confirm_appended       ;"Arrays A and B have been appended and given the name A⊕B."
call printf                     ;call external C++ print function
pop rax                         ;remove earlier push

;========== Output another heading that indicates after this line, the appended array will be outputted ================================================================
push qword 0                    ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                      ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, output_AB              ;"A⊕B contains"
call printf                     ;call external C++ print function
pop rax                         ;remove earlier push

;========== Append array A and B by calling the append module ==========================================================================================================
push qword 0                    ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                      ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, arrayA                 ;move arrayA to rdi so that it will be the first parameter being passed when calling append module
mov rsi, r15                    ;move r15(size of arrayA) to rsi so that it will be the second parameter being passed when calling append module
mov rdx, arrayB                 ;move arrayB to rdx so that it will be the thrid parameter being passed when calling append module
mov rcx, r14                    ;move r14(size of arrayB) to rcx so that it will be the fourth parameter being passed when calling append module
mov r8, combined_array          ;move the combined_array that will contain floats from arrayA and B to r8
call append                     ;call asm append module
mov r13, rax                    ;rax contains the size of combined_array
pop rax                         ;remove earlier push

;========== Display appended array by calling display_array module =====================================================================================================
push qword 0                    ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                      ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, combined_array         ;move the combined array to rdi so that it will be the first parameter being passed when calling display_array module
mov rsi, r13                    ;move r13(size of combined array) to rsi so that it will be the second parameter being passed when calling display_array module
call display_array              ;call C display_array module that will output floats from the combined array
pop rax                         ;remove earlier push

;========== Compute magnitude of the combined array by calling the magnitude module =====================================================================================
push qword 0                    ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                      ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, combined_array         ;move the combined array to rdi so that it will be the first parameter being passed when calling magnitude module
mov rsi, r13                    ;move r13(size of combined array) to rsi so that it will be the second parameter being passed when calling magnitude module
call magnitude                  ;call asm magnitude module
movsd xmm15, xmm0               ;move the magnitude returned from magnitude module to xmm15 for storage
pop rax                         ;remove earlier push

;========== Output magnitude of the combined array =======================================================================================================================
push qword 0                    ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 1                      ;1 xmm register will be used in this section
mov rdi, output_magnitudeAB     ;"The magnitude of  A",0xE2, 0x8A, 0x95, " B is %.5lf"
movsd xmm0, xmm15               ;move magnitude stored in xmm15 to xmm0 to be printed
call printf                     ;call external C++ function to print
pop rax                         ;remove earlier push

movsd xmm0, xmm15               ;move magnitude of combined array stored in xmm15 to xmm0 so that it will be returned to main file
pop rax                         ;counter push at the beginning
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

