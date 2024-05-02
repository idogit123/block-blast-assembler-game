include macro.asm

IDEAL
MODEL small
STACK 100h
DATASEG
jumps
; --------------------------
; Your variables here
; --------------------------
	include "filedata.asm"
	include "gamedata.asm"
CODESEG
	include "fileproc.asm"
start:
	mov ax, @data
	mov ds, ax
	
	call SaveHighScore
	
exit:
	waitForKeyPressed
	mov ax, 4c00h
	int 21h
END start


