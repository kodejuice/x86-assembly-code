# PURPOSE: 
# This program will compute factorials
#
# Everything in the main program is stored in registers,
# so the data section doesn’t have anything.

.include "print.s"

.section .data

.section .text

.globl _start
_start:
    pushl $5            # compute factorial of 5
    call factorial
    addl $4, %esp       # Scrubs the parameter that was pushed on the stack

    pushl %eax
    call print_num

    movl $0, %ebx
    movl $1, %eax       # exit
    int $0x80


# PURPOSE:
#   This function is used to compute factorials iteratively
#
# VARIABLES:
#  %ebx  -  holds the passed parameter
#
#   return values goes in %eax

.type factorial, @function
factorial:
    pushl %ebp
    movl %esp, %ebp

    movl $1, %eax       # put 1 as initial result in %eax
    movl 8(%ebp), %ebx  # put passed parameter in %ebx

factorial_iteration:
    cmpl $1, %ebx
    je end_factorial

    imul %ebx, %eax
    decl %ebx

    jmp factorial_iteration

    
end_factorial:
    movl %ebp, %esp
    popl %ebp
    ret
