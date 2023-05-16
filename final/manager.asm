;Author: William Sutanto
;Author: wsutanto@csu.fullerton.edu
;Course and section:  CPSC240-7
;Today’s date: May 15 2023

;Hi professor, I think the value for total resistance in your document is incorrect,
;as it only totals the value of 1/r1 + 1/r2 + 1/r3, hence getting a total of 1/R at the end.
;I think to get the total resistance R, we still need to divide 1/R (1/1/R), it is also
;stated in the document that the formula is 1/R = 1/R1 + 1/R2 + 1/R3, hence to get total
;resistance R we still need to divide 1/R to get R. Thank you.



extern printf               ;external C++ function to print to console
extern scanf                ;external C++ function to read input from console
extern getfreq

global manager

segment .data        ;Place initialized data here
;========== message to be printed to user =================================================================================================================================
promptCurrent db "Please enter the current: ",0
promptResistance1 db "Please enter the resistance on circuit 1: ",0
promptResistance2 db "Please enter the resistance on circuit 2: ",0
promptResistance3 db "Please enter the resistance on circuit 3: ",0
totalResistance db 10,"The total resistance is R = %.8lf",10,0
voltage db 10,"The voltage is V = %.8lf",10,0
cpuFreq db 10,"The frequency of this processor is %.0lf tics/second",10,0
resultTics db 10,"The computations were performed in %llu tics, which equals %.10lf seconds.",10,0

one_float_format db "%lf",0

segment .bss


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

;prompt current
push qword 0
mov rax, 0
mov rdi, promptCurrent
call printf
pop rax

;extract current
push qword 0
mov rax, 1
mov rdi, one_float_format
mov rsi, rsp
call scanf
movsd xmm10, xmm0   ;xmm10 contains current
pop rax

;prompt resistance 1
push qword 0
mov rax, 0
mov rdi, promptResistance1
call printf
pop rax

;extract resistance 1
push qword 0
mov rax, 1
mov rdi, one_float_format
mov rsi, rsp
call scanf
movsd xmm11, xmm0   ;xmm11 contains resistance 1
pop rax

;prompt resistance 2
push qword 0
mov rax, 0
mov rdi, promptResistance2
call printf
pop rax

;extract resistance 2
push qword 0
mov rax, 1
mov rdi, one_float_format
mov rsi, rsp
call scanf
movsd xmm12, xmm0   ;xmm12 contains resistance 2
pop rax

;prompt resistance 3
push qword 0
mov rax, 0
mov rdi, promptResistance3
call printf
pop rax

;extract resistance 3
push qword 0
mov rax, 1
mov rdi, one_float_format
mov rsi, rsp
call scanf
movsd xmm13, xmm0   ;xmm13 contains resistance 3
pop rax

;read clock
xor rdx, rdx                ;sets rdx register to zero    
xor rax, rax                ;sets rax register to zero
cpuid                       ;get cpu info
rdtsc                       ;read the currrent value of the processor's time-stamp counter
shl rdx, 32                 ;shift left rdx register by 32
add rdx, rax                ;add rdx with rax and store the value in rdx
mov r13, rdx                ;number of tics at start is stored in r13

;compute total resistance
mov rax, 1
cvtsi2sd xmm1, rax
movsd xmm2, xmm1
movsd xmm3, xmm1
movsd xmm4, xmm1

divsd xmm1, xmm11
divsd xmm2, xmm12
divsd xmm3, xmm13

addsd xmm1, xmm2
addsd xmm1, xmm3

divsd xmm4, xmm1

;output total resistance
push qword 0
mov rax, 1
mov rdi, totalResistance
movsd xmm0, xmm4
call printf
pop rax

;calculate voltage
mulsd xmm10, xmm4

;output voltage
push qword 0
mov rax, 1
mov rdi, voltage
movsd xmm0, xmm10
call printf
pop rax

;read clock
xor rdx, rdx                ;sets rdx register to zero 
xor rax, rax                ;sets rax register to zero
cpuid                       ;get cpu info
rdtsc                       ;read the currrent value of the processor's time-stamp counter
shl rdx, 32                 ;shift left rdx register by 32
add rdx, rax                ;add rdx with rax and store the value in rdx
mov r14, rdx                ;number of tics at end is stored in r14

;getfrequency
push qword 0
mov rax, 0
call getfreq
movsd xmm15, xmm0           ;xmm15 contains cpu freq
pop rax

;convert GHZ to Hz
movsd xmm14, xmm15          ;xmm14 contains cpu freq
mov rax, 1000000000
cvtsi2sd xmm0, rax
mulsd xmm14, xmm0

;output frequency
push qword 0
mov rax, 1
mov rdi, cpuFreq
movsd xmm0, xmm14
call printf
pop rax

;calculate elapsed tics
sub r14, r13

;calculate elapsed time in seconds
cvtsi2sd xmm4, r14      ;xmm4 contains elapsed tics
divsd xmm4, xmm15       ;xmm4 contains time in ns
mov rax, 1000000000
cvtsi2sd xmm0, rax
divsd xmm4, xmm0        ;xmm4 contains time in seconds


;output results
push qword 0
mov rax, 1
mov rdi, resultTics
mov rsi, r14
movsd xmm0, xmm4
call printf
pop rax

pop rax
movsd xmm0, xmm10
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
