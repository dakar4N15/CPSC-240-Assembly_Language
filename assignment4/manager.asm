;***************************************************************************************************************************
;Program name: "Benchmark". This program is coded in a combination of c++ as the main file and assembly for the manager,    *
;and getradicand modules, including one bash file. The purpose of this program is to benchmark the                          *
;performance of your device's CPU upon running the square root instruction in SSE and also the square root program in the   *
;standard C library.
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
;  Program name: Benchmark
;  Programming languages: C++, X86 assembly
;  Date program began: 2023-April-10
;  Date of last update: 2023-April-14
;  Comments reorganized: 2023-April-14
;  Files in the program: main.cpp, manager.asm, getradicand.asm, r.sh
;
;Purpose
;  This file is the main assembly caller file. This file mainly calls other functions necessary to run the program
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
;  Program name: Benchmark
;  Programming languages: C++, X86 assembly
;  Date program began: 2023-April-10
;  Date of last update: 2023-April-14
;
;Purpose
;  This program will run a benchmark test on your device's CPU performance by running the square root instruction in SSE and 
;  also the square root program in the standard C library. The main objective is to find how much time is required for a single
;  sqrt instruction to execute. This program will first identify your CPU name, type, and max clock speed. Then, this program 
;  will prompt user for a float to be used for square root benchmarking, followed by the number of times the iteration should 
;  be performed. Next, this program will get the time on the clock in tics before the iteration starts, iterate the sqrt instruction 
;  for the user's specified amount of times, and get the time on the clock in tics again after the iteration process finished. 
;  The elapsed time in tics will be displayed to the user, along with the time for one square root computation in tics and nano seconds.
;
;Project information
;  Project files: main.cpp, manager.asm, getradicand.asm, r.sh
;  Status: Available for public review.
;
;Translator information
;  Compile this file: nasm -f elf64 -l manager.lis -o manager.o manager.asm
;  Link the project files: g++ -m64 -std=c++17 -fno-pie -no-pie -o final.out main.o manager.o getradicand.o
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
extern getradicand          ;asm module to obtain a floating radicand from user
extern atoi                 ;external C++ function that converts string to integer

global manager

segment .data        ;Place initialized data here
;========== message to be printed to user =================================================================================================================================
welcome db "Welcome to Square Root Benchmarks by William Sutanto",10,0                              ;welcome message
contact db 10,"For customer service contact me at wsutanto@csu.fullerton.edu",10,0                  ;contact info
cpuName db 10,"Your CPU is %s",10,0                                                                 ;display cpu name and type
cpuSpeed db 10,"Your max clock speed is %.0lf MHz",10,0                                             ;display cpu max clock speed
sqrtDisplay db 10,"The square root of %.10lf is %.11lf.",10,0                                       ;display float entered by user and the result of square root from it
promptIteration db 10,"Next enter the number of times iteration should be performed: ",0            ;prompt user for the number of iterations to be performed
displayTicsStart db 10,"The time on the clock is %llu tics.",10,0                                   ;display the tics at start before iteration began
benchmarkStart db 10,"The bench mark of the sqrtsd instruction is in progress. ",10,0               ;display to tell user that the benchamrks process has already begun
displayTicsEnd db 10,"The time on the clock is %llu tics and the benchmark is completed.",10,0      ;Display tics at the end of benchmark
displayElapsed db 10,"The elapsed time was %llu tics",10,0                                          ;display the elapsed tics
result db 10,"The time for one square root computation is %.5lf tics which equals %.5lf ns.",10,0   ;display results 
promptspeed db 10,"Enter your max clock speed in MHz: ",0                                           ;prompt user to enter max clock speed

one_float_format db "%lf",0
string_format db "%s", 0   ;Format indicating a null-terminated string, c-string

segment .bss
cpu_name resb 100           ;to store CPU name and type
input_times resq 20         ;to store input by user of the amount of iteration times

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

;========== Output welcome message =====================================================================================================================================
push qword 0            ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0              ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, welcome        ;"Welcome to Square Root Benchmarks by William Sutanto"
call printf             ;call external C++ function
pop rax                 ;remove earlier push

;========== Output contact info message =================================================================================================================================
push qword 0            ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0              ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, contact        ;"For customer service contact me at wsutanto@csu.fullerton.edu"
call printf             ;call external C++ function
pop rax                 ;remove earlier push

;========== CPU Name ====================================================================================================================================================
mov r15, 0x80000002     ;this value is to be passed to cpuid to get info about the processor
mov rax, r15            ;rax will get cpu info
cpuid                   ;to get cpu info

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

push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, cpuName            ;"Your CPU is %s"
mov rsi, cpu_name           ;contains cpu data obtained from the above
call printf                 ;call external C++ function
pop rax                     ;remove earlier push

;========== Get Max clock speed and display to user using printf==========================================================================================================
;prompt user for max clock speed
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, promptspeed        ;promptspeed db 10,"Enter your max clock speed in MHz: ",0   
call printf                 ;call external C++ print function
pop rax                     ;remove earlier push

;get max clock speed using scanf
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, one_float_format   ;"%lf"
mov rsi, rsp                ;point scanf to the reserved memory
call scanf                  ;call external C++ scanf function to extract input from user
movsd xmm14, xmm0           ;move the value entered to xmm14. xmm14 now stores the max clock speed in MHz
pop rax                     ;remove earlier push

;output to user
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 1                  ;1 xmm register will be printed in this section
mov rdi, cpuSpeed           ;"Your max clock speed is %.0lf MHz"
movsd xmm0, xmm14           ;move the cpu max clock speed in MHz stored in xmm14 to xmm0 to be printed
call printf                 ;call the external C++ print function
pop rax                     ;remove earlier push

;========== Call getradicand module to extract float from user ==========================================================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
call getradicand            ;call the asm module getradicand to extract floating radicand from user
movsd xmm10, xmm0           ;store the float entered by user in xmm10
pop rax                     ;remove earlier push

;========= Output the float entered by user and the square root value of it =============================================================================================
;calculate square root of the float
sqrtsd xmm11, xmm10     ;store the value of sqrt in xmm11

push qword 0            ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 2              ;2 xmm registers will be printed in this section
mov rdi, sqrtDisplay    ;"The square root of %.10lf is %.11lf."
movsd xmm0, xmm10       ;move the value of float entered by user stored in xmm10 to xmm0 to be printed
movsd xmm1, xmm11       ;move the result of sqrt stored in xmm11 to xmm1 to be printed
call printf             ;call external C++ print function
pop rax                 ;remove earlier push

;========= Prompt user for the number of times iterations should be performed ===========================================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, promptIteration    ;"Next enter the number of times iteration should be performed: "
call printf                 ;call external C++ print function
pop rax                     ;remove earlier push

;========= Extract from user for the number of times iterations should be performed using scanf =========================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, string_format      ;"%s"
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

;========== Get the number of tics at the start before iteration begins ================================================================================================
xor rdx, rdx                ;sets rdx register to zero    
xor rax, rax                ;sets rax register to zero
cpuid                       ;get cpu info
rdtsc                       ;read the currrent value of the processor's time-stamp counter
shl rdx, 32                 ;shift left rdx register by 32
add rdx, rax                ;add rdx with rax and store the value in rdx
mov r13, rdx                ;number of tics at start is stored in r13

;========== Perform iteration =========================================================================================================================================
mov r12, 0                  ;counter for loop
beginLoop:                  ;marks the beginning of loop
cmp r12, r15                ;compare the counter with times of iterations to be performed
je done                     ;if counter has reached the times of iterations to be performed, jump out of the loop to done
sqrtsd xmm11, xmm10         ;square root the user-entered value in xmm10 and store the value in xmm11
inc r12                     ;increment counter
jmp beginLoop               ;jump to beginning of loop
done:                       ;if done, continue here

;========== Get the number of tics at the end of iteration ===========================================================================================================
xor rdx, rdx                ;sets rdx register to zero 
xor rax, rax                ;sets rax register to zero
cpuid                       ;get cpu info
rdtsc                       ;read the currrent value of the processor's time-stamp counter
shl rdx, 32                 ;shift left rdx register by 32
add rdx, rax                ;add rdx with rax and store the value in rdx
mov r14, rdx                ;number of tics at end is stored in r14

;========== Display the tics at the start of the iteration ==========================================================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary 
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, displayTicsStart   ;"The time on the clock is %llu tics."
mov rsi, r13                ;move the tics value stored in r13 to rsi to be printed
call printf                 ;call the external C++ print function
pop rax                     ;remove the earlier push

;========== Display to user that the benchmark is in progress =======================================================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, benchmarkStart     ;"The bench mark of the sqrtsd instruction is in progress. "
call printf                 ;call the external C++ print function
pop rax                     ;remove earlier push

;========== Display the tics at the end of the iteration ============================================================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, displayTicsEnd     ;"The time on the clock is %llu tics and the benchmark is completed."
mov rsi, r14                ;move the tics value stored in r14 to rsi to be printed
call printf                 ;call the external C++ print function
pop rax                     ;remove earlier push

;========== Calculate elapsed tics ==================================================================================================================================
sub r14, r13                ;elapsed tics is stored in r14

;========== Display the elapsed tics to user ========================================================================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, displayElapsed     ;"The elapsed time was %llu tics"
mov rsi, r14                ;move the elapsed tics stored in r14 to rsi to be printed
call printf                 ;call the external C++ print function
pop rax                     ;remove earlier push

;========== Calculate time for one square root computation in tics and nano seconds =================================================================================
cvtsi2sd xmm10, r14     ;xmm10 now stores a copy of elapsed time
cvtsi2sd xmm11, r15     ;xmm11 now stores a copy of number of iteration times
divsd xmm10, xmm11      ;divide elapsed time in tics with number of iteration times to get time for one square root computation in tics

;convert max clock speed from MHz to GHz
mov rax, 1000           ;rax now store the value of 1000
cvtsi2sd xmm1, rax      ;convert 1000 int stored in rax to float that will be stored in xmm1
divsd xmm14, xmm1       ;xmm14 now stores a copy of cpu max clock speed in GHz

movsd xmm13, xmm10      ;xmm13 now stores a copy of time for one square root computation in tics
divsd xmm13, xmm14      ;divide time in tics with cpu max clock freq in GHz to obtain benchmark in ns. xmm13 now stores the benchmark in ns

;========== Display results to user =================================================================================================================================
push qword 0            ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 2              ;2 xmm registers will be printed in this section
mov rdi, result         ;"The time for one square root computation is %.5lf tics which equals %.5lf ns."
movsd xmm0, xmm10       ;move the time in tics for one square root computation stored in xmm10 to xmm0 to be printed
movsd xmm1, xmm13       ;move the time in ns for one square root computation stored in xmm13 to xmm1 to be printed
call printf             ;call the external C++ print function
pop rax                 ;remove earlier push

movsd xmm0, xmm13       ;return the benchmark result in ns to main
pop rax                 ;counter push at beginning of program

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

