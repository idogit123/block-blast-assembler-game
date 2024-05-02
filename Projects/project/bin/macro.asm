 ; switch to graphic mode
graphicMode macro
	mov ax, 13h 
	int 10h
endm

; x, y, (byte) 
setCursorPos macro x, y
	mov bh, 0
	mov dl, x
	mov dh, y
	mov ah, 2h
	int 10h
endm

; switch to text mode
textMode macro
	mov ax,3
	int 10h
endm

waitForKeyPressed macro
	mov ah,00h
	int 16h
endm

; waits until new acion in keyboard
waitForNewScanCode macro
	local waitForData
waitForData:
	in  al,64h	; read keyboard status port
	cmp al, 10b	; Data in buffer? (equal=no data)
	je waitForData
endm

; get new scan code from keyboard
; (return) al = scan code
getScanCode macro
	in      al,60h	; read scan code
	mov [scanCode], al
endm

; (enter) var: scanCode (byte)
; zf = 1 if key released. zf = 0 if key pressed
pressedOrRelessed macro
	test [scanCode], 80h ; if result is 0 a key is pressed , 
						 ; if it 1 a key is released
endm

activateSpeaker macro
	in al, 61h
	or al, 00000011b
	out 61h, al
endm

turnoffSpeaker macro
	in al, 61h
	and al, 11111100b
	out 61h, al
endm

getSpeakerAccess macro
	mov al, 0B6h
	out 43h, al
endm

; (enter) freq: word
sendFrequency macro freq
	mov ax, freq
	out 42h, al 	; Sending lower byte
	mov al, ah
	out 42h, al	 ; Sending upper byte
endm

activateMouse macro 
	mov ax,0h
	int 33h
endm

showMouse macro
	mov ax,1h
	int 33h
endm

hideMouse macro
	mov ax,2h
	int 33h
endm

; get mouse pos and button status
getMouse macro 
	mov ax, 3
	int 33h	
	shr cx, 1
	mov ax, [mouseX]
	mov [oldMouseX], ax
	mov ax, [mouseY]
	mov [oldMouseY], ax
	
	mov [mouseX], cx
	mov [mouseY], dx
endm

