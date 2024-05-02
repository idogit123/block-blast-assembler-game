; (enter) bankShapes
; (return) draw shape bank on screen
proc drawBank
	push ax bx cx [shapeIndex]

	; draw skeleton
	mov [rectX], 0 ; draw black background
	mov [rectY], 0
	mov [rectWidth], 160
	mov [rectHeight], 200
	mov [rectColor], 0
	call drawRect
	
	mov [lineX], 160 ; draw vertical line
	mov [lineY], 0
	mov [rectHeight], 200
	mov [rectColor], 0Fh
	call drawVerticalLine
	
	mov [lineX], 0 ; draw horizontal lines
	mov [lineY], 67
	mov [rectWidth], 160
	call drawLine
	mov [lineY], 134
	call drawLine
	
	; loop over bank shapes
	mov [shapeSize], 10
	mov bx, offset bankShapes + 4
	mov cx, 3
drawBankShapes:
	dec cx
	mov ax, [bx]
	cmp ax, 0
	jz nextBankShape
	
	mov [shapeIndex], ax
	mov al, 67 ; calculate Y
	mul cl
	add ax, 33
	mov [rectY], ax
	mov [rectX], 80 ; middle of bank
	call drawShape
	
nextBankShape:
	sub bx, 2
	inc cx
	loop drawBankShapes
	
	pop [shapeIndex] cx bx ax
	ret
endp drawBank


; (enter) mouseY, bankShapes !make sure mouse on bank!
; (return) shapeIndex = the shape the mouse is on
proc getShapeAtMousePos
	push ax bx
	
	; call retShape
	
	mov bx, 67
	mov ax, [mouseY]
	div bl
	
	shl al, 1
	
	mov bl, al
	add bx, offset bankShapes
	
	push [bx]
	mov ax, [shapeIndex]
	mov [bx], ax
	pop ax
	mov [shapeIndex], ax
	
	call drawBank
	
	mov ax, [mouseX]
	sub ax, 10
	mov [rectX], ax
	mov ax, [mouseY]
	sub ax, 10
	mov [rectY], ax
	mov [shapeSize], 20
	call takeShape
	
	pop bx ax
	ret
endp getShapeAtMousePos


; (enter) ax = seed
; (return) ax = random number (size: byte)
proc randomNumber
	push bx cx dx
	
	mov ah,2ch ; read time
	int 21h ; dl = miliseconds, dh = seconds, cl = minutes, ch = hours
	
	mov bx, dx ; bx = miliseconds
	add bx, ax
	xor bh, bh
	
	mov al, [byte ptr cs:bx] ; one byte from codeseg
	mov ah, dh ; ah = seconds
	xor al, ah ; xor code and time to get random number
	xor ah, ah
	
	pop dx cx bx
	ret
endp randomNumber


; (enter) none
; (return) if carry == 1: bank empty, else bank not empty
proc isBankEmpty
	push bx cx
	
	mov bx, offset bankShapes
	mov cx, 3
checkBankShape:
	cmp [word ptr bx], 0
	jnz bankNotEmpty
	add bx, 2
	loop checkBankShape
	
	stc
	pop cx bx
	ret
	
bankNotEmpty:
	clc 
	pop cx bx
	ret
endp isBankEmpty

; (enter) none
; (return) generate 3 new random shapes for the bank
proc newBankShapes
	push ax bx cx dx
	
	mov bx, offset bankShapes
	mov cx, 3
newBankShape:
	mov ax, bx ; seed different then last one
	call randomNumber ; al = random number
	and al, 00001111b ; limit to 15
	mov dx, ax
	mov ax, bx ; seed different then last one
	inc ax
	call randomNumber ; al = random number
	and al, 00000100b ; limit to 4
	add ax, dx ; ax = random 0-19
	mov dl, 9
	mul dl
	add ax, offset shapes
	mov [bx], ax
	add bx, 2
	loop newBankShape
	
	pop dx cx bx ax
	ret
endp newBankShapes