# PURPOSE: This program finds the maximum number of a set of data items

# VARIABLES: The registers have the following uses:
# 
# %edi: Holds index of data beign examined
# %ebx: Largest data item found
# %eax: Current data item
# 
# The following mem. locations are used:
# 
# data_items -  contains the item data, A 0 is used to terminate the data

.include "print.s"

.section .data

data_items:
.long 3,67,34,1250,45,75,54,2034,44,3433,22,11,66,1,2,0

.section .text

.globl _start
_start:
    movl $0, %edi                         # move 0 into index register
    movl data_items(, %edi, 4), %eax      # load first byte of data

start_loop:
    cmpl $0, %eax                           # check to see if weve hit the end (last value '0')
    je loop_exit                            # if equal, go to loop_exit procedure
    incl %edi                               # load next value (increment index register)
    movl data_items(, %edi, 4), %eax
    cmpl %ebx, %eax                         # compare values maximum value %ebx with pointed value @ %eax
    jle start_loop                          # jmp to beginning of loop, if new is less or equal to current max (not bigger)
    movl %eax, %ebx                         # didnt jump, new value is larger, move larger value
    jmp start_loop                          # jump to loop beginning (repeat)

loop_exit:
    pushl %ebx
    call print_num

    movl $1, %eax
    movl $0, %ebx
    int $0x80

