CC = gcc
FILES = main.c ../wifiFrame.c ../usartFrame.c ../frameTypes.h ../lib_crc.c
OUT_EXE = test

build: $(FILES)
	$(CC) -o $(OUT_EXE) $(FILES)

clean:
	rm -f *.o core

rebuild: clean build
