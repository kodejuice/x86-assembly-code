# Our max-age program will be straightforward.
#
# It will do the following:
# • Open the file
# • Attempt to read a record
# • If we are at the end of the file, exit
# • Otherwise, store the age
# • Update maximum age as appropriate
# • Go back to read another record
# • Exit, with max age as status code


.include "linux.s"
.include "record-def.s"

.section .data
file_name:
    .ascii "test.dat\0"

.section .bss
.lcomm record_buffer, RECORD_SIZE

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
    # and max age local variable
    subl $8, %esp

    # Open the file
    movl $SYS_OPEN, %eax
    movl $file_name, %ebx
    movl $0, %ecx # This says to open read-only
    movl $0666, %edx
    int $LINUX_SYSCALL

    # Save file descriptor
    movl %eax, ST_INPUT_DESCRIPTOR(%ebp)

    # Even though it’s a constant, we are
    # saving the output file descriptor in
    # a local variable so that if we later
    # decide that it isn’t always going to
    # be STDOUT, we can change it easily.
    movl $STDOUT, ST_OUTPUT_DESCRIPTOR(%ebp)

    # Store 0 as initial maximum age
    # in the %ebx register
    # this will be the exit status code
    movl $0, %ebx

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
    jne exit

    # compare current max age with age in record
    # repeat loop if current max age is larger
    cmpl %ebx, RECORD_AGE + record_buffer
    jl record_read_loop

    # else update max age and repeat loop
    movl RECORD_AGE + record_buffer, %ebx

    jmp record_read_loop


exit:
    # exit with max age as status code
    movl $SYS_EXIT, %eax
    # max age is already stored in the %ebx register
    int $LINUX_SYSCALL
