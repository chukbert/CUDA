CC = nvcc

CFLAGS = -g -Wall

TARGET = main

all:	$(TARGET)

$(TARGET):	src/$(TARGET).cu
	$(CC) src/$(TARGET).cu -o src/$(TARGET)

clean:
	$(RM) src/$(TARGET)

run:
	./src/$(TARGET)