;Author: William Sutanto
;Author: wsutanto@csu.fullerton.edu
;Course and section:  CPSC240-7
;Today’s date: Mar 22, 2023

extern printf               ;external C++ function to print to console
extern scanf                ;external C++ function to read input from console
extern fgets                ;external C++ function to read input from console that contain white space
extern stdin                ;external C++ function necessary to perform fgets
extern strlen               ;external C++ function that counts the size of string
extern input_array
extern reverse
extern display_array


global manager     

segment .data                       ;Place initialized data here
;========== message to be printed to user =================================================================================================================================
promptName db "Please enter your name: ",0
promptTitle db 10,"What is your title: ",0
greetUser db 10,"Welcome ",0
programDesc db 10,10,"This is our reversible program.",10,0
promptFloat db 10,"Please enter float numbers separated by ws and press <enter><control+d> to terminate inputs.",10,0
youentered db 10,"You entered",10,0
count1 db "The array has %d doubles.",10,0
reversemsg db 10,"The function reverse was called",10,0
array2 db 10,"The second array holds these values",10,0

format db "%s", 0   ;Format indicating a null-terminated string, c-string
spc db " ", 0       ;space character

INPUT_LEN equ 256   ; Max bytes of name, title
max equ 10

segment .bss
arrayA resq max
arrayB resq max          
name resb INPUT_LEN     ;reserve bytes for name
title resb INPUT_LEN    ;reserve bytes for title

segment .text

manager:              ;start execution of program

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

;========== Prompt user to enter name ==================================================================================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, promptName         ;"Please enter your name: "
call printf                 ;call external C++ print function
pop rax                     ;remove earlier push

;========== Extract name from user and store it in name variable =======================================================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, name               ;move name variable as first argument into register rdi
mov rsi, INPUT_LEN          ;provide fgets with second argument, the size of the bytes reserved
mov rdx, [stdin]            ;provide fgets with third argument, the contents at address of stdin
call fgets                  ;call C++ function fgets to extract input from user with white spaces
pop rax                     ;remove earlier push

;========== Remove newline char from previous fgets input of name =====================================================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, name               ;move name variable as first argument into register rdi
call strlen                 ;call C++ function strlen that counts the length of string, strlen will return the length of the string in register rax
sub rax, 1                  ;substract 1 from the length of string to obtain the location of '\n'
mov byte [name + rax], 0    ;Replace the byte where '\n' exits with '\0'
pop rax                     ;remove earlier push

;========== Prompt user for title =====================================================================================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, promptTitle        ;"Please enter your title (Mr,Ms,Sargent,Chief,Project Leader,etc): "
call printf                 ;call external C++ print function
pop rax                     ;remove earlier push

;========== Extract title from user and store it in title variable ======================================================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, title              ;move title variable as first argument into register rdi
mov rsi, INPUT_LEN          ;provide fgets with second argument, the size of the bytes reserved
mov rdx, [stdin]            ;provide fgets with third argument, the contents at address of stdin
call fgets                  ;call C++ function fgets to extract input from user with white spaces
pop rax                     ;remove earlier push

;========== Remove newline char from previous fgets input of title =====================================================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, title              ;move title variable as first argument into register rdi
call strlen                 ;call C++ function strlen that counts the length of string, strlen will return the length of the string in register rax
sub rax, 1                  ;substract 1 from the length of string to obtain the location of '\n'
mov byte [title + rax], 0   ;Replace the byte where '\n' exits with '\0'
pop rax                     ;remove earlier push

;========== Output welcome message that contains title and name of user that was previously obtained ===================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, greetUser          
call printf                 ;call external c++ print function
pop rax                     ;remove earlier push

;========== Output title of user =======================================================================================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, title              ;title entered by user
call printf                 ;call external c++ print function
pop rax                     ;remove earlier push

;========== Output space required in between title and name of user ====================================================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, spc                ;empty space " "to print a space between title and name of user to be printed
call printf                 ;call external C++ print function
pop rax                     ;remove earlier push

;========== Output name of user ========================================================================================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, name               ;name entered by user
call printf                 ;call external C++ print function
pop rax                     ;remove earlier push

;========== Output brief description of program ========================================================================================================================
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, programDesc        ;
call printf                 ;call external C++ print function
pop rax                     ;remove earlier push

;output prompt to enter floats
push qword 0                ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                  ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, promptFloat      
call printf                 ;call external C++ print function
pop rax                     ;remove earlier push

;call input_array to input floats into arrayA
push qword 0
mov rax, 0
mov rdi, arrayA
mov rsi, max
call input_array
mov r15, rax
pop rax

;output message to user
push qword 0
mov rax, 0
mov rdi, youentered
call printf
pop rax

;call display_array to ouput floats in arrayA
push qword 0
mov rax, 0
mov rdi, arrayA
mov rsi, r15
call display_array
pop rax

;output size of array
push qword 0
mov rax, 0
mov rdi, count1
mov rsi, r15
call printf
pop rax

;call reverse
push qword 0
mov rax, 0
mov rdi, arrayA
mov rsi, arrayB
mov rdx, r15
call reverse
pop rax

;output reverse message
push qword 0
mov rax, 0
mov rdi, reversemsg
call printf
pop rax

;output message to tell that arrayB will be outputted
push qword 0
mov rax, 0
mov rdi, array2
call printf
pop rax

;call display_array to output floats in arrayB
push qword 0
mov rax, 0
mov rdi, arrayB
mov rsi, r15
call display_array
pop rax

pop rax
mov rax, name

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