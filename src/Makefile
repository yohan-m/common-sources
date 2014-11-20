.PHONY: clean
.SUFFIXES:

CC = /opt/Codesourcery/bin/arm-none-linux-gnueabi-gcc

all :  lib_crc.o serialFrame.o wifiFrame.o

%o: %c
	$(CC) -c $^ -o $@ 

clean:
	rm -rf *.o
