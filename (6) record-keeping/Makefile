write-records:
	as write-record.s --32 -o write-record.o
	as "(1) write-records.s" --32 -o write-records.o

	ld write-records.o write-record.o -melf_i386 -o write-records
	rm write-records.o write-record.o
	./write-records && rm ./write-records

read-records:
	as read-record.s --32 -o read-record.o
	as count-chars.s --32 -o count-chars.o
	as write-newline.s --32 -o write-newline.o
	as "(2) read-records.s" --32 -o read-records.o

	ld read-record.o count-chars.o write-newline.o read-records.o -melf_i386 -o read-records
	rm read-record.o count-chars.o write-newline.o read-records.o
	./read-records && rm ./read-records

modify-records:
	as read-record.s --32 -o read-record.o
	as write-record.s --32 -o write-record.o
	as "(3) modify-record.s" --32 -o modify-record.o

	ld modify-record.o read-record.o write-record.o -melf_i386 -o modify-record
	rm read-record.o write-record.o
	./modify-record && rm ./modify-record

# Extras

max-age:
	make write-records # creates the `test.dat` file

	as read-record.s --32 -o read-record.o
	as "(X) max-age.s" --32 -o max-age.o

	ld read-record.o max-age.o -melf_i386 -o max-age
	rm read-record.o max-age.o
	./max-age && rm ./max-age


search-record:
	make write-records # creates the `test.dat` file

	as read-record.s --32 -o read-record.o
	as count-chars.s --32 -o count-chars.o
	as write-newline.s --32 -o write-newline.o
	as "(X) search-record.s" --32 -o search-record.o

	ld read-record.o count-chars.o write-newline.o search-record.o -melf_i386 -o search-record
	rm read-record.o count-chars.o write-newline.o search-record.o
	./search-record && rm ./search-record


clean:
	rm *.dat
	rm *.o
