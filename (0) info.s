
# General-purpose registers:
# %eax - (%ah | %al)
# %ebx
# %ecx
# %edx
# %edi
# %esi

# Special-purpose registers:
# %eip
# %ebp
# %esp

# 64-bit  32-bits 16-bits 8-bits
# rax     eax     ax      al
# rbx     ebx     bx      bl
# rcx     ecx     cx      cl
# rdx     edx     dx      dl
# rsi     esi     si      sil
# rdi     edi     di      dil
# rbp     ebp     bp      bpl
# rsp     esp     sp      spl
# r8      r8d     r8w     r8b
# r9      r9d     r9w     r9b
# r10     r10d    r10w    r10b
# r11     r11d    r11w    r11b
# r12     r12d    r12w    r12b
# r13     r13d    r13w    r13b
# r14     r14d    r14w    r14b
# r15     r15d    r15w    r15b


# ADDRESS_OR_OFFSET(%BASE_OR_OFFSET,%INDEX,MULTIPLIER)
# FINAL ADDRESS = ADDRESS_OR_OFFSET + %BASE_OR_OFFSET + MULTIPLIER * %INDEX

#  Different addressing modes:
#  direct:
#     movl ADDRESS, %eax
#     -- load %eax with the value @ address ADDRESS

#  indirect mode:
#     movl (%eax), %ebx
#     -- load value from address indicated by register
#     -- if %eax held an address, we could move the value at that address to %ebx by doing above

#  indexed mode:
#     movl string_start(,%ecx,1), %eax
#     -- access the nth value of string_start where n = value at %ecx
 
#  base-pointer mode:
#     movl 4(%eax), %ebx
#     -- Base-pointer addressing is similar to indirect addressing, except that it adds a constant
#     --  value to the address in the register. For example, if you have a record where the age value
#     --  is 4 bytes into the record, and you have the address of the record in %eax, you can retrieve
#     --  the age into %ebx by issuing the following instruction:
 
#  immediate mode:
#     movl $12, %eax
#     -- if you wanted to load the number 12 into %eax, you would simply do the above


# Conditionals:
# je: Jump if the values were equal
# jg: Jump if the second value was greater than the first value
# jge: Jump if the second value was greater than or equal to the first value
# jl: Jump if the second value was less than the first value
# jle: Jump if the second value was less than or equal to the first value
# jmp: Jump no matter what. This does not need to be preceeded by a comparison.
# - These (except `jmp`) are instructions called immediately after a `cmp` type instruction (cmpl, cmpb, e.t.c)



# The UNIX File Concept

# Each operating system has it’s own way of dealing with files. However, the UNIX method, which is used on Linux, is the simplest and most
# universal.

# UNIX files, no matter what program created them, can all be accessed as a sequential stream of bytes When you access a file, you start by
# opening it by name.
# The operating system then gives you a number, called a file descriptor, which you use to refer to the file until you are through with it.

# You can then read and write to the file using its file descriptor. When you are done reading and writing, you then close the file,
# which then makes the file descriptor useless.

# In our programs we will deal with files in the following ways:

# 1. Tell Linux the name of the file to open, and in what mode you want it opened (read, write, both read and write, create it if it doesn’t exist,
#  etc.). This is handled with the open system call, which takes a filename, a number representing the mode, and a permission set as its
# parameters. %eax will hold the system call number, which is 5. The address of the first character of the filename should be stored in %ebx.
# The read/write intentions, represented as a number, should be stored in %ecx. For now, use 0 for files you want to read from, and 03101 for
# files you want to write to (you must include the leading zero).1 Finally, the permission set should be stored as a number in %edx. If you are
# unfamiliar with UNIX permissions, just use 0666 for the permissions (again, you must include the leading zero).

# 2. Linux will then return to you a file descriptor in %eax. Remember, this is a number that you use to refer to this file throughout your
# program.

# 3. Next you will operate on the file doing reads and/or writes, each time giving Linux the file descriptor you want to use. read is
# system call 3, and to call it you need to have the file descriptor in %ebx, the address of a buffer for storing the data that is read in %ecx,
# and the size of the buffer in %edx. Buffers will be explained in the Section called Buffers and .bss. read will return with either the number 
# of characters read from the file, or an error code. Error codes can be distinguished because they are always negative numbers (more information
# on negative numbers can be found in Chapter 10). write is system call 4, and it

# 4. When you are through with your files, you can then tell Linux to close them. Afterwards, your file descriptor is no longer valid.
# This is done using close, system call 6. The only parameter to close is the file descriptor, which is placed in %ebx.
