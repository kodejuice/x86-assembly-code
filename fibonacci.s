# Puropose: This program calculates the nth fibonacci number
#
# Fib(N) = Fib(N-1) + Fib(N-2)
# Fib(0) = 0, Fib(1) = 1 
#

.include "print.s"

.section .data
# nothing here


.section .text
.globl _start
_start:
    movl $5, %edi       # 5th fibonacci
    call fibonacci

    pushl %eax
    call print_num

    movl $1, %eax
    movl $0, %ebx
    int $0x80

.equ N, -4
.equ RESULT, -8
.equ TMP, -12


# PURPOSE:
#   This function is used to compute fibonacci recursively
# 
# PARAMETERS:
#  %edi
# 
# VARIABLES:
#  %eax  -  holds the result of Fib(N-1) parameter
#  %ecx  -  holds the result of Fib(N-2) parameter
# 
# Return values goes in %eax
#
.type fibonacci, @function
fibonacci:
    pushl %ebp
    movl %esp, %ebp
    subl $12, %esp          # save stack space for local variables (F1 and F2 and RESULT)

    movl %edi, N(%ebp)      # move parameter to %eax register

    cmpl $0, N(%ebp)
    jne .S1
    movl $0, RESULT(%ebp)
    jmp .S3

.S1:
    cmpl $1, N(%ebp)
    jne .S2
    movl $1, RESULT(%ebp)
    jmp .S3

.S2:
    # calculate Fib(N-1)
    movl N(%ebp), %eax
    subl $1, %eax
    movl %eax, %edi
    call fibonacci
    movl %eax, TMP(%ebp)        # move result to temp variable

    # calculate Fib(N-2)
    movl N(%ebp), %ecx
    subl $2, %ecx
    movl %ecx, %edi
    call fibonacci

    movl TMP(%ebp), %ecx
    addl %eax, %ecx
    movl %ecx, RESULT(%ebp)

.S3:
    movl RESULT(%ebp), %eax
    addl $12, %esp
    movl %ebp, %esp
    popl %ebp
    ret


