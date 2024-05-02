include macro.asm

IDEAL
MODEL small
STACK 100h
DATASEG



CODESEG
	include "proc.asm"
start:
	mov ax, @data
	mov ds, ax

	

	
exit:
	mov ax, 4c00h
	int 21h
END start


