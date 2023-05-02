;***************************************************************************************************************************
;Program name: "Benchmark and data validation". This program will compute the sin value from an angle in degrees and get the*
;number of tics elapsed to get the sin value using Taylor series in a specific number of terms. This program will also      *
;compute the sin value using the sin function in the math C library, including the number of tics elapsed for comparison.   *
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
;  Program name: Benchmark and data validation
;  Programming languages: C++, X86 assembly
;  Date program began: 2023-April-25
;  Date of last update: 2023-April-27
;  Comments reorganized: 2023-April-27
;  Files in the program: driver.cpp, manager.asm, isfloat.asm, r.sh
;
;Purpose
;  This file is the main assembly file of the program. Everything occurs in this file.
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
;  Program name: Benchmark and data validation
;  Programming languages: C++, X86 assembly
;  Date program began: 2023-April-25
;  Date of last update: 2023-April-27
;
;Purpose
;   This program will prompt user for an angle number in degrees and the number of terms in
;   a taylor series to be computed. Next, this program will compute the sin value using Taylor
;   series for the user specified amount of terms while getting the tics elapsed to run the program.
;   This program will output to user the number of tics elapsed for computing sin value using Taylor
;   series and the result from the calculation. After that, the program will use the same angle value
;   to compute the sin value using the sin function in C library while getting the number of tics
;   as well for comparison. This program will validate user's input for the float entered for use as
;   the angle for calculation. If invalid data is entered, program will keep asking user until
;   correct format is entered.
;
;Project information
;  Project files: driver.cpp, manager.asm, isfloat.asm, r.sh
;  Status: Available for public review.
;
;Translator information
;  Compile this file: nasm -f elf64 -l manager.lis -o manager.o manager.asm
;  Link the project files: g++ -m64 -std=c++17 -fno-pie -no-pie -o final.out driver.o manager.o isfloat.o
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
; Declare external C++ functions & make funct 'executive' visible to other languages & create constant
extern printf               ;external C++ function to print to console
extern scanf                ;external C++ function to read input from console
extern fgets                ;external C++ function to read input from console that contain white space
extern stdin                ;external C++ function necessary to perform fgets
extern strlen               ;external C++ function that counts the size of string
extern atof                 ;external C++ function that converts string to float
extern isfloat              ;asm module to check for float correctness
extern atoi                 ;external C++ function that converts string to integer
extern sin                  ;external sin library function

global manager

segment .data        ;Place initialized data here
;========== message to be printed to user =================================================================================================================================
welcome db "This program Sine Function Benchmark is maintained by William Sutanto",10,0                                 ;Output welcome message of program to user
promptName db 10,"Please enter your name: ",0                                                                           ;prompt user to enter name
greetUser db 10,"It is nice to meet you ",0                                                                             ;Greet user with the entered name
promptAngle db ". Please enter an angle number in degrees: ",0                                                          ;prompt user for an angle number in degrees to be used 
promptTaylor db 10,"Thank you.  Please enter the number of terms in a Taylor series to be computed: ",0                 ;prompt user for number of terms in a Taylor series to be computed
computeTaylor db 10,"Thank you.  The Taylor series will be used to compute the sine of your angle.",10,0                ;Output user that Taylor series is in progress
result1 db 10,"The computation completed in %llu tics and the computed value is %.9lf",10,0                             ;Output the elapsed tics and result from the Taylor series
result2 db 10,"The computation completed in %llu tics and gave the value %.9lf",10,0                                    ;Output the elapsed tics and result from sin library function
invalid_input db "Invalid. Please try again: ",0                                                                        ;tell user that the last input is not a vaild float       
computeSinLibrary db 10,"Next the sine of %.9lf will be computed by the function “sin” in the library <math.h>.",10,0   ;Output user that sin library function calculation is in progress

INPUT_LEN equ 256               ; Max bytes of name
one_string_format db "%s",0
one_float_format db "%lf",0

segment .bss
name resb INPUT_LEN     ;reserve bytes for name
input_times resq 20     ;to store input by user of the amount of iteration times

segment .text

manager:            ;start execution of program

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

push qword 0            ;push to remain on the boundary

;========== Output welcome message ========================================================================================================================================
push qword 0            ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0              ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, welcome        ;"This program Sine Function Benchmark is maintained by William Sutanto"
call printf             ;call external C++ print function
pop rax                 ;remove earlier push

;========== Output prompt to enter user name =============================================================================================================================
push qword 0            ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0              ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, promptName     ;"Please enter your name: "
call printf             ;call external C++ print function
pop rax                 ;remove earlier push

;========== Extract name from user and store it in name variable =========================================================================================================
push qword 0            ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0              ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, name           ;move name variable as first argument into register rdi
mov rsi, INPUT_LEN      ;provide fgets with second argument, the size of the bytes reserved
mov rdx, [stdin]        ;provide fgets with third argument, the contents at address of stdin
call fgets              ;call C++ function fgets to extract input from user with white spaces
pop rax                 ;remove earlier push

;========== Remove newline char from previous fgets input of name =====================================================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, name               ;move name variable as first argument into register rdi
call strlen                 ;call C++ function strlen that counts the length of string, strlen will return the length of the string in register rax
sub rax, 1                  ;substract 1 from the length of string to obtain the location of '\n'
mov byte [name + rax], 0    ;Replace the byte where '\n' exits with '\0'
pop rax                     ;remove earlier push

;========== Output welcome message to greet user with name =============================================================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, greetUser          ;"It is nice to meet you "
call printf                 ;call external c++ print function
pop rax                     ;remove earlier push

;========== Output name of user ========================================================================================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, name               ;name entered by user
call printf                 ;call external C++ print function
pop rax                     ;remove earlier push

;========== Prompt user to enter an angle number in degrees =============================================================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, promptAngle        ;". Please enter an angle number in degrees: "
call printf                 ;call external C++ print function
pop rax                     ;remove earlier push

;========== Extract float from user using scanf =========================================================================================================================
beginLoop:
    push qword 0                    ;Push 8 bytes to get onto an 16-byte boundary
    mov rax, 0                      ;no data from SSE will be printed i.e. 0 xmm registers used
    mov rdi, one_string_format      ;"%s"
    mov rsi, rsp                    ;point scanf to the reserved storage
    call scanf                      ;call external C++ function to read user input
    ;check input by calling isfloat module
    mov rax, 0                      ;no data from SSE will be printed i.e. 0 xmm registers used
    mov rdi, rsp                    ;move the string extracted from user earlier using scanf to rdi so that it will be passed as first parameter to asm isfloat module
    call isfloat                    ;call asm isfloat module
    cmp rax, -1                     ;isfloat will return -1 if the previously entered string is a float and return 0 if not a float
    je continue                     ;if isfloat return -1 indicating that its a float, jump to continue
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
pop rax                     ;remove earlier push at the beginning of loop

;========== Prompt user to enter the number of terms in a Taylor series to be computed =================================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, promptTaylor       ;"Thank you.  Please enter the number of terms in a Taylor series to be computed: "
call printf                 ;call external C++ print function
pop rax                     ;remove earlier push

;========= Extract from user for the number of times iterations should be performed using scanf =========================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, one_string_format  ;"%s"
mov rsi, input_times        ;store the value entered by user in input_times
call scanf                  ;call external C++ scan function
pop rax                     ;remove earlier push

;========== Convert the string for the number of iteration times entered by user to integer ============================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary   
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, input_times        ;move the value entered by user to rdi so that it will be passed when calling atoi function
call atoi                   ;call external C++ atoi function to convert string to integer
mov r15, rax                ;r15 now stores the number of iteration times to be performed
pop rax                     ;remove earlier push

;========== Output to tell user that the taylor series will be used to compute the sine of your angle ==================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, computeTaylor      ;"Thank you.  The Taylor series will be used to compute the sine of your angle."
call printf                 ;call external C++ print function
pop rax                     ;remove earlier push

;========== Get the number of tics at the start before Taylor series begins ================================================================================================
xor rdx, rdx                ;sets rdx register to zero    
xor rax, rax                ;sets rax register to zero
cpuid                       ;get cpu info
rdtsc                       ;read the currrent value of the processor's time-stamp counter
shl rdx, 32                 ;shift left rdx register by 32
add rdx, rax                ;add rdx with rax and store the value in rdx
mov r13, rdx                ;number of tics at start is stored in r13

;========== Perform Taylor series =========================================================================================================================================
;convert the angle in degrees to radians first
mov rax, 0x400921FB54442D18 ;move pi value into rax
push rax                    
movsd xmm0, [rsp]           ;pi value stored in xmm0
pop rax
mov r10, 180                ;r10 now stores 180
cvtsi2sd xmm1, r10          ;xmm1 stores the value 180
;(π/180) * angle in degrees
movsd xmm3, xmm15           ;xmm3 now stores a copy of the angle in degrees inputted by user
divsd xmm3, xmm1
mulsd xmm3, xmm0            ;xmm3 now stores the angle in radians

;   -1*x^2
;----------------
;  (2k+3)*(2k+2)

movsd xmm1, xmm3        ;xmm1 stores current term of Taylor series, first term of the Taylor series is the angle in radians, now stored in xmm14
mov rax, 3              ;move 3 to rax
cvtsi2sd xmm13, rax     ;xmm13 now stores 3.0 for 3 in (2k+3)
mov rax, 2              ;move 2 to rax
cvtsi2sd xmm12, rax     ;xmm12 now stores 2.0
mov rax, -1             ;move -1 to rax
cvtsi2sd xmm11, rax     ;xmm11 now stores -1.0
mov r14, 0              ;r14 stores counter
cvtsi2sd xmm14, r14     ;xmm14 now stores counter in float (0.0)
xorpd xmm10, xmm10      ;xmm10 stores the total sum so far

beginloop:
    cmp r15, r14        ;check if counter is out of bounds for max number of terms for taylor series
    je outofloop        ;if max is reached, jump outofloop
    addsd xmm10, xmm1   ;add the current term of the sequence to total sum

    ; 2k+2 
    movsd xmm9, xmm12
    mulsd xmm9, xmm14
    addsd xmm9, xmm12   ;xmm9 stores value of 2k+2

    ; 2k+3 
    movsd xmm8, xmm12
    mulsd xmm8, xmm14
    addsd xmm8, xmm13   ;xmm8 stores value of 2k+3

    ; (2k+3) * (2k+2)
    mulsd xmm8, xmm9    ;xmm8 stores value of (2k+3) * (2k+2)

    ; X^2
    movsd xmm7, xmm3    ;xmm7 now stores a copy of angle in radians
    mulsd xmm7, xmm7    ;xmm7 now stores X^2

    ;     X^2
    ; -----------
    ;(2k+3) (2k+2)
    divsd xmm7, xmm8    ;xmm7 stores the value of calculation above
    mulsd xmm7, xmm11   ;multiply value of xmm7 with -1 to get final value
    mulsd xmm1, xmm7    ;multiply value of xmm8 with current term of Taylor series
    inc r14             ;increment counter
    cvtsi2sd xmm14, r14
    jmp beginloop       ;jump to beginning of loop

outofloop:

;========== Get the number of tics at the end of Taylor series ===========================================================================================================
xor rdx, rdx                ;sets rdx register to zero 
xor rax, rax                ;sets rax register to zero
cpuid                       ;get cpu info
rdtsc                       ;read the currrent value of the processor's time-stamp counter
shl rdx, 32                 ;shift left rdx register by 32
add rdx, rax                ;add rdx with rax and store the value in rdx
mov r14, rdx                ;number of tics at end is stored in r14

;========== Calculate elapsed tics ==================================================================================================================================
sub r14, r13                ;elapsed tics is stored in r14

;========== Output elapsed tics and result of taylor series ==========================================================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 1                  ;1xmm register will be printed in this section
mov rdi, result1            ;"The computation completed in %llu tics and the computed value is %.9lf"
mov rsi, r14                ;move elapsed tics to rsi
movsd xmm0, xmm10           ;move result from calculation of Taylor series stored in xmm10 to xmm0
call printf                 ;call external C++ print function
pop rax                     ;remove earlier push

;========== Output to tell user that now we will use sin in the library math.h to compare values =====================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 1                  ;1xmm register will be printed in this section
mov rdi, computeSinLibrary  ;"Next the sine of %.9lf will be computed by the function “sin” in the library <math.h>."
movsd xmm0, xmm15           ;move the angle in degrees entered by user stored in xmm15 to xmm0
call printf                 ;call external C++ print function
pop rax                     ;remove earlier push

;========== Get the number of tics at the start before sin library function begins ================================================================================================
xor rdx, rdx                ;sets rdx register to zero    
xor rax, rax                ;sets rax register to zero
cpuid                       ;get cpu info
rdtsc                       ;read the currrent value of the processor's time-stamp counter
shl rdx, 32                 ;shift left rdx register by 32
add rdx, rax                ;add rdx with rax and store the value in rdx
mov r12, rdx                ;number of tics at start is stored in r12

;========== Call the sin library function ================================================================================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
movsd xmm0, xmm3            ;move the angle in radians stored in xmm3 to xmm0 to be passed to sin function
call sin                    ;call sin library function to calculate the sin value of the angle
movsd xmm9, xmm0            ;xmm9 now stores the result returned from sin library function
pop rax                     ;remove earlier push

;========== Get the number of tics at the end ===========================================================================================================
xor rdx, rdx                ;sets rdx register to zero 
xor rax, rax                ;sets rax register to zero
cpuid                       ;get cpu info
rdtsc                       ;read the currrent value of the processor's time-stamp counter
shl rdx, 32                 ;shift left rdx register by 32
add rdx, rax                ;add rdx with rax and store the value in rdx
mov r13, rdx                ;number of tics at end is stored in r13

;========== Calculate elapsed tics ==================================================================================================================================
sub r13, r12                ;elapsed tics is stored in r13

;========== Output the elapsed tics and result from the sin function =======================================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 1                  ;1xmm register will be printed in this section
mov rdi, result2            ;"The computation completed in %llu tics and gave the value %.9lf"
mov rsi, r13                ;move elapsed tics to rsi
movsd xmm0, xmm9            ;move the value returned by sin library function stored in xmm9 to xmm0
call printf                 ;call the external C++ print function
pop rax                     ;remove earlier push

pop rax
mov rax, r14                 ;return the elapsed tics from Taylor series to driver.

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
;========== End of program manager.asm =================================================================================================================================
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**