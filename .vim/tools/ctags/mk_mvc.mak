include mk_mvc.mak

# Win32.mak requires that CPU be set appropriately.
# To cross-compile for Win64, set CPU=AMD64 or CPU=IA64.
!ifndef CPU
CPU = $(PROCESSOR_ARCHITECTURE)
! if ("$(CPU)" == "x86") || ("$(CPU)" == "X86")
CPU = i386
! endif
!endif

!if "$(CPU)" == "AMD64"
BINDIR = $(HOME)/bin64/
!else
BINDIR = $(HOME)/bin/
!endif

install:
	copy ctags.exe $(BINDIR)
