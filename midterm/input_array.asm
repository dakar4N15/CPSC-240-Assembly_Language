;Author: William Sutanto
;Author: wsutanto@csu.fullerton.edu
;Course and section:  CPSC240-7
;Today’s date: Mar 22, 2023

extern scanf            ;external C++ function to read input from console
extern printf           ;external C++ function to print to console
extern stdin            ;external C++ function involved to set failbit to zero
extern clearerr         ;external C++ function involved to set failbit to zero
global input_array  

segment .data                    
one_float_format db "%lf",0

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

push qword 0

mov r13, rdi ;array
mov r14, rsi ;max size
mov r15, 0   ;counter

beginLoop:
    cmp r15, r14                    ;compare if index is still within boundary of max size of array
    je done                         ;jump to out of loop if capacity exceeded
    push qword 33                   ;reserve space in memory
    mov rax, 1                      
    mov rdi, one_float_format     
    mov rsi, rsp                    ;point scanf to the reserved storage
    call scanf                      ;call external C++ function to read user input
    movsd xmm10, [rsp]
    ;this section starts ctrl+d checking (if ctrl+d, exit the loop)
    cdqe
    cmp rax, -1                     ;if ctrl+d is entered, rax will be filled with -1
    pop rax
    je done                         ;if rax equal to -1, jump to done to exit loop

    movsd [r13 + r15*8], xmm10
    inc r15
    jmp beginLoop

done:
;Block to set the failbit to zero. Equivalent to cin.clear()
mov rax, 0
mov rdi, [stdin]
call clearerr

pop rax
mov rax, r15


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
;========== End of program input_array.asm =================================================================================================================================
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**