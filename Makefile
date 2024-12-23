all:
	odin build . -out:mutual_information_measure.exe -debug

opti:
	odin build . -out:mutual_information_measure.exe -o:speed

opti_max:
	odin build . -out:mutual_information_measure.exe -o:aggressive -microarch:native -no-bounds-check -disable-assert -no-type-assert


clean:
	rm mutual_information_measure.exe

run:
	./mutual_information_measure.exe