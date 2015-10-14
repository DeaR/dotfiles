include Makefile

CXX = g++
CXXFLAGS = -fpermissive

sudo: sudo.o sudo_server.o sudo_client.o utils.o main.o
sudow: sudow.o utils.o main.o

main.o: ../../../.vim/tools/sudo/main.c
	$(COMPILE.C) $(OUTPUT_OPTION) $<
