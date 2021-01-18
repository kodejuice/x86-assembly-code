# Simple function to print string to STDOUT
# 
# INPUT:
# - address of string to print out
#
# USAGE:
# 
# .section .data
# string: .ascii "hello world\0"

# .globl _start
# _start:
#   pushl $string
#   call print
#


.include "integer-to-number.s"

.section .data

# 
# CONSTANT
# 
.equ STDOUT, 1
.equ SYS_WRITE, 4
.equ SYS_CLOSE, 6
.equ SYS_EXIT, 1
.equ LINUX_SYSCALL, 0x80

.section .text

.type print, @function
print:
    .equ ST_STRING, 8

    pushl %ebp          # save old base pointer
    movl %esp, %ebp     # make stack pointer the base pointer

    # get string length
    pushl ST_STRING(%ebp)
    call count_chars
    # length is stored in the %eax register
    addl $4, %esp               # restore stack pointer

    movl %eax, %edx             # size of string
    movl $SYS_WRITE, %eax
    movl $STDOUT, %ebx          # file-descriptor to write to (STDOUT in this case)
    movl ST_STRING(%ebp), %ecx  # address of string to print
    int $LINUX_SYSCALL

close_stdout:
    movl $SYS_CLOSE, %eax
    movl $STDOUT, %ebx
    int $LINUX_SYSCALL

print_end:
    movl %ebp, %esp         # restore the stack pointer
    popl %ebp               # restore the base pointer
    ret



# Simple function to print number to STDOUT
# 
# INPUT:
# - number to print out
#
# USAGE:
# 
# .section .data
# string: .ascii "hello world\0"
#
# _start:
#    pushl $string
#    call print_num
#

.type print_num, @function
.section .data
tmp_buffer: .ascii "\0\0\0\0\0\0\0\0\0\0\0"

print_num:
    # This is where our one parameter is on the stack
    .equ ST_NUMBER, 8

    # standard function stuff
    pushl %ebp
    movl %esp, %ebp

    # convert number to string
    # store result in tmp_buffer
    pushl $tmp_buffer
    pushl ST_NUMBER(%ebp)
    call integer2number

    # print buffer
    pushl $tmp_buffer
    call print

print_num_end:
    movl %ebp, %esp         # restore the stack pointer
    popl %ebp               # restore the base pointer
    ret




# PURPOSE: Count the characters until a null byte is reached. 
#  
# INPUT: The address of the character string 
#   
# OUTPUT: Returns the count in %eax 
# 
# Registers used:
#  %ecx - character count
#  %al - current character
#  %edx - current character address
#  
# Returns:
#  %eax - string length
#

.type count_chars, @function
# This is where our one parameter is on the stack
.equ ST_STRING_START_ADDRESS, 8

count_chars:
    pushl %ebp
    movl %esp, %ebp

    # Counter starts at zero
    movl $0, %ecx

    # Starting address of data
    movl ST_STRING_START_ADDRESS(%ebp), %edx

count_loop_begin:
    # Grab the current character
    movb (%edx), %al

    # Is it null?
    cmpb $0, %al

    # If yes, we’re done
    je count_loop_end

    # Otherwise, increment the counter and the pointer
    incl %ecx
    incl %edx

    # Go back to the beginning of the loop
    jmp count_loop_begin

count_loop_end:
    # We’re done. Move the count into %eax
    # and return.
    movl %ecx, %eax
    popl %ebp
    ret
