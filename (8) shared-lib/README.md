Building a Shared Library

Let’s say that we wanted to take all of our shared code from Chapter 6 `(6) record-keeping` and build it into a shared library to use in our programs.

The first thing we would do is assemble them like normal:

    `$ as write-record.s -o write-record.o as read-record.s -o read-record.o`

Now, instead of linking them into a program, we want to link them into a shared library.

This changes our linker command to this:
    `$ ld -shared write-record.o read-record.o -o librecord.so`

This links both of these files together into a shared library called `librecord.so`.

This file can now be used for multiple programs. If we need to update the functions contained within it, we can just update this one file and not have to worry about which programs use it.

Let’s look at how we would link against this library.
To link the write-records program, we would do the following:
 
    `$ as write-records.s -o write-records ld -L . -dynamic-linker /lib/ld-linux.so.2 -o write-records -lrecord write-records.o`

In this command, `-L .` told the linker to look for libraries in the current directory (it usually only searches `/lib` directory, `/usr/lib` directory, and a few others).
As we’ve seen, the option `-dynamic-linker /lib/ld-linux.so.2` specified the dynamic linker.

The option `-lrecord` tells the linker to search for functions in the file named librecord.so.

Now the write-records program is built, but it will not run. If we try it, we will get an error like the following:
`./write-records: error while loading shared libraries: librecord.so: can- not open shared object file: No such file or directory`

This is because, by default, the dynamic linker only searches `/lib`, `/usr/lib`, and whatever directories are listed in `/etc/ld.so.conf` for libraries.

In order to run the program, you either need to move the library to one of these directories, or execute the following command: `LD_LIBRARY_PATH=.`
`export LD_LIBRARY_PATH`

Alternatively, if that gives you an error, do this instead:
`setenv LD_LIBRARY_PATH .`

Now, you can run write-records normally by typing `./write-records`.

Setting `LD_LIBRARY_PATH` tells the linker to add whatever paths you give it to the library search path for dynamic libraries


For further information about dynamic linking, see the following sources on the Internet:
- The man page for `ld.so` contains a lot of information about how the Linux dynamic linker works.


