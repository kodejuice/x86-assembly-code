
# Our search-record program.
#
# It will do the following:
# • Open the file
# • Attempt to read a record
# • If we are at the end of the file, exit
# • Otherwise, count the characters of the first name
# • Write the first name to STDOUT
# • Write a newline to STDOUT
# • Go back to read another record


.include "linux.s"
.include "record-def.s"

.section .data
file_name:
    .ascii "test.dat\0"

.section .bss
.lcomm record_buffer, RECORD_SIZE
.lcomm stdin_buffer, 6

.section .text
# Main program
.globl _start
_start:
    # These are the locations on the stack where
    # we will store the input and output descriptors
    # (FYI - we could have used memory addresses in
    #  a .data section instead)

    .equ ST_INPUT_DESCRIPTOR, -4
    .equ ST_OUTPUT_DESCRIPTOR, -8

    # Copy the stack pointer to %ebp
    movl %esp, %ebp

    # Allocate space to hold the file descriptors
    subl $8, %esp

    # Open the file
    movl $SYS_OPEN, %eax
    movl $file_name, %ebx
    movl $0, %ecx # This says to open read-only
    movl $0666, %edx
    int $LINUX_SYSCALL

    # Save file descriptor
    movl %eax, ST_INPUT_DESCRIPTOR(%ebp)

    # Read from STDIN
    # Store content in stdin_buffer
    movl $STDIN, %ebx
    movl $stdin_buffer, %ecx
    movl $5, %edx
    movl $SYS_READ, %eax
    int $LINUX_SYSCALL


record_read_loop:
    pushl ST_INPUT_DESCRIPTOR(%ebp)
    pushl $record_buffer
    call read_record
    addl $8, %esp

    # Returns the number of bytes read.
    # If it isn’t the same number we
    # requested, then it’s either an
    # end-of-file, or an error, so we’re
    # quitting
    cmpl $RECORD_SIZE, %eax
    jne finished_reading

    # if first 5 character of
    #  stdin_buffer and ($RECORD_FIRSTNAME + record_buffer) doesnt matches
    #  repeat loop
    pushl $stdin_buffer
    pushl $RECORD_FIRSTNAME + record_buffer
    call compare_strings
    addl $8, %esp

    cmpl $1, %eax
    jne record_read_loop # return value isnt 1,
                         # hence first 5 characters dont match

    # Otherwise they match!,
    # print out the first name

    # but first, we must know it’s size
    pushl $RECORD_FIRSTNAME + record_buffer
    call count_chars
    addl $4, %esp

    movl %eax, %edx
    movl $STDOUT, %ebx
    movl $SYS_WRITE, %eax
    movl $RECORD_FIRSTNAME + record_buffer, %ecx
    int $LINUX_SYSCALL

    pushl $STDOUT
    call write_newline
    addl $4, %esp
    jmp record_read_loop

finished_reading:
    movl $SYS_EXIT, %eax
    movl $0, %ebx
    int $LINUX_SYSCALL


# PURPOSE: compares two strings upto 5 characters
# 
# Parameters:
#  12(%ebp) - first string
#  8(%ebp)  - second string
#
# Registers used:
# 
#  %ecx -  holds address of first string argument
#  %edx -  holds address of second string argument
# 
#  Returns:
# 
#  %eax -  will hold 1 if strings match, else 0
#
.type compare_strings, @function
compare_strings:
    pushl %ebp
    movl %esp, %ebp

    .equ STRING_1_START_ADDRESS, 12
    .equ STRING_2_START_ADDRESS, 8

    movl STRING_1_START_ADDRESS(%ebp), %ecx
    movl STRING_2_START_ADDRESS(%ebp), %edx

    movl $5, %esi # max iteration (5)

compare_loop:
    # Grab the characters
    movb (%ecx), %al
    movb (%edx), %ah

    # Are we done?
    cmpl $0, %esi
    # No in-equalities so far, hence both strings are equal
    je equal

    # Compare current characters
    cmpb %al, %ah
    jne not_equal

    # Increment the pointers
    incl %ecx
    incl %edx

    # Decrement counter
    decl %esi
    # Repeat
    jmp compare_loop

equal:
    movl $1, %eax
    jmp end_compare

not_equal:
    movl $0, %eax
    jmp end_compare

end_compare:
    popl %ebp
    ret

