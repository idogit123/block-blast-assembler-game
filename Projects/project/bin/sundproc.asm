; (enter) currentSound
; (return) play the sound
proc playSound
	push ax
	
	activateSpeaker
	call nextNote
	
	pop ax
	ret
endp playSound

; (enter) offset of note in currentSound
; (return) set the note
proc nextNote
	push ax bx es
	
	getSpeakerAccess
	mov bx, [currentSound]
	mov ax, [word ptr bx]
	cmp ax, 0
	jz soundOver
	mov ax, [word ptr bx]
	out 42h, al 	; Sending lower byte
	mov al, ah
	out 42h, al	 ; Sending upper byte
	mov ax, [word ptr bx + 2] ; number of clock cycles to play note
	mov [soundTimer], ax
	
	mov ax, 40h ; save clock at start of note
	mov es, ax
	mov ax, [clock]
	mov [lastClock], ax
	
	pop es bx ax
	ret
soundOver:
	turnoffSpeaker
	pop es bx ax
	ret
endp nextNote


proc playNote
	push ax es
	
	; check if time for next note
	mov ax, 40h
	mov es, ax
	mov ax, [clock]
	sub ax, [lastClock] ; calculate time passed since start of note
	cmp ax, [soundTimer] ; check if enugh time passed
	jb notTimeForNextNote
	
	add [currentSound], 4 ; next note offset
	call nextNote
	
notTimeForNextNote:
	pop es ax
	ret
endp playNote