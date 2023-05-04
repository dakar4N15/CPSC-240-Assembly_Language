;***************************************************************************************************************************
;Program name: "Sleep time". This program will output a happy birthday message for chris for a user specified amount of     *
;times followed by a sleep block for user specified amount of time after outputting each message. The time on the clock in  *
;tics before and after the process is recorded to get the elapsed tics.
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
;  Program name: Sleep time
;  Programming languages: C++, X86 assembly
;  Date program began: 2023-May-03
;  Date of last update: 2023-May-04
;  Comments reorganized: 2023-May-04
;  Files in the program: main.cpp, birthday.asm, r.sh
;
;Purpose
;  This file is the main assembly file of the program. Everything occurs in this file.
;
;This file
;  File name: birthday.asm
;  Language: X86-64
;  Syntax: Intel
;  Max page width: 172 columns
;  Optimal print specification: Landscape, 7-point font, monospace, 172 columns, 8½x11 paper
;  Assemble: nasm -f elf64 -l birthday.lis -o birthday.o birthday.asm
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;
;Author information
;  Author name: William Sutanto
;  Author email: wsutanto@csu.fullerton.edu
;
;Program information
;  Program name: Sleep time
;  Programming languages: C++, X86 assembly
;  Date program began: 2023-May-03
;  Date of last update: 2023-May-04
;
;Purpose
;   This program will first prompt the user for the amount of birthday cards to be outputted, the delay
;   time in milliseconds between outputting the message, and the max frequency of the cpu. Then, the 
;   time on the clock in tics is recorded, and the iterations of outputting the birthday messages for
;   user specified amount of times followed by the sleep block is executed. At the end of the process,
;   the time on the clock in tics is recorded again and from there we could obtain the elapsed tics
;   for the whole process.
;
;Project information
;  Project files: main.cpp, birthday.asm, r.sh
;  Status: Available for public review.
;
;Translator information
;  Compile this file: nasm -f elf64 -l birthday.lis -o birthday.o birthday.asm
;  Link the project files: g++ -m64 -std=c++17 -fno-pie -no-pie -o final.out main.o birthday.o
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
extern usleep               ;external C++ sleep function
extern atoi                 ;external C++ function that converts string to integer

global birthday

segment .data        ;Place initialized data here
;========== message to be printed to user =================================================================================================================================
intro db "We will send a birthday greeting to Chris.",10,0                                          ;Brief introduction to the program
promptCard db 10,"How many birthday cards do you wish to send? ",0                                  ;prompt user for the amount of birthday messages to be printed
promptDelay db 10,"What is the delay time (ms) between sending greetings? ",0                       ;prompt user for the delay time in milliseconds for sleep block between printing messages
promptFreq db 10,"What is the max frequency of the cpu in this computer as a whole integer? ",0     ;prompt user for the max cpu frequency
ticsStart db 10,"Thank you.  The time on the clock is now %llu tics.",10,0                          ;output the time on clock in tics before iteration starts
ticsEnd db 10,"The time on the clock is now %llu tics",10,0                                         ;output the time on clock in tics after iteration ends
HappyBirthday db 10,"Happy Birthday, Chris",10,0                                                    ;Birthday message to be printed
elapsedTics db 10,"The elapsed time was %llu tics.",10,0                                            ;output the elapsed tics for the iteration process
return db 10,"The elapsed time will be returned to the caller.",10,0                                ;output to tell user that value of elapsed tics will be return to main.cpp

one_string_format db "%s",0
one_float_format db "%lf",0

segment .bss
input_times resq 20     ;to store input by user of the amount of birthday cards and delay time
delay_times resq 50     ;to store input by user of the amount of delay time (ms) between sending greetings

segment .text

birthday:            ;start execution of program

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

;========== Output introduction message ========================================================================================================================================
push qword 0            ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0              ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, intro          ;"We will send a birthday greeting to Chris."
call printf             ;call external C++ print function
pop rax                 ;remove earlier push

;========== Output to prompt user for the number of birthday cards =============================================================================================================
push qword 0            ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0              ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, promptCard     ;"How many birthday cards do you wish to send? "
call printf             ;call external C++ print function
pop rax                 ;remove earlier push

;========= Extract from user for the number of birthday cards using scanf =======================================================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, one_string_format  ;"%s"
mov rsi, input_times        ;store the value entered by user in input_times
call scanf                  ;call external C++ scan function
pop rax                     ;remove earlier push

;========== Convert the string for the number of birthday cards entered by user to integer ============================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary   
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, input_times        ;move the value entered by user to rdi so that it will be passed when calling atoi function
call atoi                   ;call external C++ atoi function to convert string to integer
mov r15, rax                ;r15 now stores the number of birthday cards to be output
pop rax                     ;remove earlier push

;========== Output to prompt user for delay time between greetings =============================================================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, promptDelay        ;"What is the delay time (ms) between sending greetings? "
call printf                 ;call external C++ print function
pop rax                     ;remove earlier push

;========= Extract from user for the delay time using scanf =======================================================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, one_string_format  ;"%s"
mov rsi, delay_times        ;store the value entered by user in delay_times
call scanf                  ;call external C++ scan function
pop rax                     ;remove earlier push

;========== Convert the string for the delay time entered by user to integer ============================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary   
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, delay_times        ;move the value entered by user to rdi so that it will be passed when calling atoi function
call atoi                   ;call external C++ atoi function to convert string to integer
mov r14, rax                ;r14 now stores the delay time in milliseconds
pop rax                     ;remove earlier push

;========== Convert delay time in milliseconds to microseconds to be passed to usleep function ========================================================================
mov rax, r14                ;pass the time in milliseconds stored in r14 to rax for multiplication
mov rbx, 1000               ;pass 1000 to rbx to be multiplied with delay time in milliseconds to convert to microseconds
mul rbx                     ;result of multiplication is stored in rax
mov r14, rax                ;r14 now stores the delay time in microseconds

;========== Get CPU Max clock speed from user==========================================================================================================
;prompt user for max clock speed
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, promptFreq         ;"What is the max frequency of the cpu in this computer as a whole integer? "
call printf                 ;call external C++ print function
pop rax                     ;remove earlier push

;get max clock speed using scanf
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, one_float_format   ;"%lf"
mov rsi, rsp                ;point scanf to the reserved memory
call scanf                  ;call external C++ scanf function to extract input from user
movsd xmm15, xmm0           ;move the value entered to xmm15. xmm15 now stores the max clock speed in Hz
pop rax                     ;remove earlier push

;========== Get the number of tics at the start before iteration of birthday cards begins ================================================================================================
xor rdx, rdx                ;sets rdx register to zero    
xor rax, rax                ;sets rax register to zero
cpuid                       ;get cpu info
rdtsc                       ;read the currrent value of the processor's time-stamp counter
shl rdx, 32                 ;shift left rdx register by 32
add rdx, rax                ;add rdx with rax and store the value in rdx
mov r13, rdx                ;number of tics at start is stored in r13

;========= Output the time on the clock in tics ========================================================================================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, ticsStart          ;"Thank you.  The time on the clock is now %llu tics."
mov rsi, r13                ;move the tics at start in r13 to rsi to be printed
call printf                 ;call external C++ print function
pop rax                     ;remove earlier push

;========= Perform iteration of printing birthday cards followed by sleep block after each card printed =============================================================================
mov r12, 0                  ;loop counter
beginLoop:
cmp r12, r15                ;compare if out of bounds
je done                     ;if max number of iterations is achieved, jump to done
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, HappyBirthday      ;"Happy Birthday, Chris"
call printf                 ;call external C++ print function
pop rax                     ;remove earlier push

;sleep block
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  
mov rdi, r14                ;pass the delay time in microseconds in r14 to rdi to be passed to usleep function
call usleep                 ;call C++ usleep function to pause the program for an amount of time in microseconds
pop rax                     ;remove earlier push
inc r12                     ;increment counter
jmp beginLoop               ;jump back to beginning of loop

done:
;========== Get the number of tics at the end of iterations ===========================================================================================================
xor rdx, rdx                ;sets rdx register to zero 
xor rax, rax                ;sets rax register to zero
cpuid                       ;get cpu info
rdtsc                       ;read the currrent value of the processor's time-stamp counter
shl rdx, 32                 ;shift left rdx register by 32
add rdx, rax                ;add rdx with rax and store the value in rdx
mov r12, rdx                ;number of tics at end is stored in r12

;========== Output the time on clock in tics after iteration completes =================================================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, ticsEnd            ;"The time on the clock is now %llu tics"
mov rsi, r12                ;move the tics at end in r12 to rsi to be printed
call printf                 ;call external C++ print function
pop rax                     ;remove earlier push

;========== Calculate elapsed tics ==================================================================================================================================
sub r12, r13                ;elapsed tics is stored in r12

;========== Output elapsed tics =====================================================================================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, elapsedTics        ;"The elapsed time was %llu tics."
mov rsi, r12                ;move elapsed tics to rsi
call printf                 ;call external C++ print function
pop rax                     ;remove earlier push

;========== Output to tell that the elapsed tics will be returned to main ============================================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, return             ;"The elapsed time will be returned to the caller."
call printf                 ;call external C++ print function
pop rax                     ;remove earlier push

pop rax                     ;counter push at beginning of program
mov rax, r12                ;return elapsed tics stored in r12 to main

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
;========== End of program birthday.asm =================================================================================================================================
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**