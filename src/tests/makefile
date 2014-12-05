CC = gcc
FILES = main.c ../wifiFrame.c ../frameTypes.h ../lib_crc.c ../commands_drone.h
OUT_EXE = test

build: $(FILES)
	$(CC) -o $(OUT_EXE) $(FILES)

clean:
	rm -f *.o core

rebuild: clean build
