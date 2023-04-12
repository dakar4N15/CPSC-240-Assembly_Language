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
;  File name: executive.asm
;  Language: X86-64
;  Syntax: Intel
;  Max page width: 172 columns
;  Optimal print specification: Landscape, 7-point font, monospace, 172 columns, 8½x11 paper
;  Assemble: nasm -f elf64 -l executive.lis -o executive.o executive.asm
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
;  This file is the main assembly caller file. This file mainly calls other functions necessary to run the program
;
;Project information
;  Project files: main.cpp, executive.asm, fill_random_array.asm, show_array.asm, compare.c, normalize.asm, isnan.asm, r.sh
;  Status: Available for public review.
;
;Translator information
;  Linux: nasm -f elf64 -l executive.lis -o executive.o executive.asm
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
extern printf
extern scanf
extern getfreq
extern getradicand
extern atoi                 ;external C++ function that converts string to integer

global manager

segment .data        ;Place initialized data here
;========== message to be printed to user =================================================================================================================================
welcome db "Welcome to Square Root Benchmarks by William Sutanto",10,0                  ;welcome message
contact db 10,"For customer service contact me at wsutanto@csu.fullerton.edu",10,0      ;contact info
cpuName db 10,"Your CPU is %s",10,0                                                     ;display cpu name and type
cpuSpeed db 10,"Your max clock speed is %.0lf MHz",10,0                                    ;display cpu max clock speed
sqrtDisplay db 10,"The square root of %.10lf is %.11lf.",10,0                           ;display float entered by user and the result of square root from it
promptIteration db 10,"Next enter the number of times iteration should be performed: ",0 ;prompt user for the number of iterations to be performed
displayTicsStart db 10,"The time on the clock is %llu tics.",10,0                         ;display the tics at start before iteration began
benchmarkStart db 10,"The bench mark of the sqrtsd instruction is in progress. ",10,0   ;display to tell user that the benchamrks process has already begun
displayTicsEnd db 10,"The time on the clock is %llu tics and the benchmark is completed.",10,0 ;Display tics at the end of benchmark
displayElapsed db 10,"The elapsed time was %d tics",10,0                                ;display the elapsed tics
result db 10,"The time for one square root computation is %.5lf tics which equals %.5lf ns.",10,0 ;display results 

string_format db "%s", 0   ;Format indicating a null-terminated string, c-string

segment .bss
cpu_name resb 100
input_times resq 20      ;to store input by user of the amount of iteration times

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

push qword 0

;========== Output welcome message =====================================================================================================================================
push qword 0
mov rax, 0
mov rdi, welcome
call printf
pop rax

;========== Output contact info message =================================================================================================================================
push qword 0
mov rax, 0
mov rdi, contact
call printf
pop rax

;========== CPU Name ====================================================================================================================================================
mov r15, 0x80000002 ;this value is to be passed to cpuid to get info about the processor
mov rax, r15        ;rax will get cpu info
cpuid               ;to get cpu info

mov [cpu_name], rax
mov [cpu_name +4], rbx
mov [cpu_name +8], rcx
mov [cpu_name +12], rdx

mov r15, 0x80000003
mov rax, r15
cpuid

mov [cpu_name +16], rax
mov [cpu_name +20], rbx
mov [cpu_name +24], rcx
mov [cpu_name +28], rdx

mov r15, 0x80000004
mov rax, r15
cpuid

mov [cpu_name +32], rax
mov [cpu_name +36], rbx
mov [cpu_name +40], rcx
mov [cpu_name +44], rdx

push qword 0
mov rax, 0
mov rdi, cpuName
mov rsi, cpu_name
call printf
pop rax

;========== Max clock speed =============================================================================================================================================
;push qword 0
;mov rax,0
;mov rdi,cpuSpeed
;mov rsi, getfreq
;call printf
;pop rax

call getfreq
movsd xmm15, xmm0   ;store the cpu max clock speed in GHz in xmm15 

;convert max clock speed from GHZ to MHZ
mov rax, 1000
cvtsi2sd xmm1, rax
movsd xmm14, xmm15  ;xmm14 now stores a copy of cpu max clock speed
mulsd xmm14, xmm1   ;xmm14 now stores a copy of cpu max clock speed in MHz

push qword 0
mov rax, 1
mov rdi, cpuSpeed
movsd xmm0, xmm14
call printf
pop rax

;========== Call getradicand module to extract float from user ==========================================================================================================
push qword 0
mov rax, 0
call getradicand
movsd xmm10, xmm0   ;store the float entered by user in xmm10
pop rax

;========= Output the float entered by user and the square root value of it =============================================================================================
;calculate square root of the float
sqrtsd xmm11, xmm10     ;store the value of sqrt in xmm11

push qword 0
mov rax, 2
mov rdi, sqrtDisplay
movsd xmm0, xmm10
movsd xmm1, xmm11
call printf
pop rax

;========= Prompt user for the number of times iterations should be performed ===========================================================================================
push qword 0
mov rax, 0
mov rdi, promptIteration
call printf
pop rax

;========= Extract from user for the number of times iterations should be performed using scanf =========================================================================
push qword 0
mov rax, 0
mov rdi, string_format
mov rsi, input_times
call scanf
pop rax

;========== Convert the string for the number of iteration times entered by user to integer ============================================================================
push qword 0
mov rax, 0
mov rdi, input_times
call atoi
mov r15, rax        ;r15 now stores the number of iteration times to be performed
pop rax

;========== Get the number of tics at the start before iteration begins ================================================================================================
xor rdx, rdx
xor rax, rax
cpuid
rdtsc
shl rdx, 32
add rdx, rax
mov r13, rdx    ;number of tics at start is stored in r13

;========== Perform iteration =========================================================================================================================================
mov r12, 0              ;counter for loop
beginLoop:
cmp r12, r15
je done
sqrtsd xmm11, xmm10     ;store the value of sqrt in xmm11
inc r12
jmp beginLoop
done:

;========== Get the number of tics at the end of iteration ===========================================================================================================
xor rdx, rdx
xor rax, rax
cpuid
rdtsc
shl rdx, 32
add rdx, rax
mov r14, rdx    ;number of tics at end is stored in r14

;========== Display the tics at the start of the iteration ==========================================================================================================
push qword 0
mov rax, 0
mov rdi, displayTicsStart
mov rsi, r13
call printf
pop rax

;========== Display to user that the benchmark is in progress =======================================================================================================
push qword 0
mov rax, 0
mov rdi, benchmarkStart
call printf
pop rax

;========== Display the tics at the end of the iteration ============================================================================================================
push qword 0
mov rax, 0
mov rdi, displayTicsEnd
mov rsi, r14
call printf
pop rax

;========== Calculate elapsed tics ==================================================================================================================================
sub r14, r13        ;elapsed tics is stored in r14

;========== Display the elapsed tics to user ========================================================================================================================
push qword 0
mov rax, 0
mov rdi, displayElapsed
mov rsi, r14
call printf
pop rax

;========== Calculate time for one square root computation in tics and nano seconds =================================================================================
cvtsi2sd xmm10, r14     ;xmm10 now stores a copy of elapsed time
cvtsi2sd xmm11, r15     ;xmm11 now stores a copy of number of iteration times
divsd xmm10, xmm11

cvtsi2sd xmm12, r14
divsd xmm12, xmm15  ;xmm12 now stores the benchmark in ns

;========== Display results to user =================================================================================================================================
push qword 0
mov rax, 2
mov rdi, result
movsd xmm0, xmm10
movsd xmm1, xmm12
call printf
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
;========== End of program executive.asm =================================================================================================================================
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**

