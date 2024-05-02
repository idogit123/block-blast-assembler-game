include macro.asm

IDEAL
MODEL small
STACK 100h
DATASEG
jumps
; --------------------------
; Your variables here
; --------------------------
	include "sunddata.asm"
	include "mausdata.asm"
CODESEG
	include "sundproc.asm"
start:
	mov ax, @data
	mov ds, ax
	graphicMode
	activateMouse
	showMouse
	
waitForMouse:
	call playNote
	showMouse
	getMouse
	hideMouse
	cmp bl, 0
	jnz mousePressed

	jmp waitForMouse
	
mousePressed:
	mov [currentSound], offset pickShapeSound
	call playSound
	jmp waitForMouse
	
exit:
	waitForKeyPressed
	textMode
	mov ax, 4c00h
	int 21h
END start


