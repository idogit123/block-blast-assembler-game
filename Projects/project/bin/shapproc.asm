; (enter) rectX, rectY, shapeSize, shapeIndex (number of shape to draw) – var 
; (return) draws shape on screen
proc drawShape
	push ax bx cx

	; set color
	mov bx, [shapeIndex]
	mov al, [byte ptr bx]
	mov [rectColor], al
	inc bx
	
	; draw the first tile
	mov ax, [shapeSize]
	mov [rectWidth], ax
	mov [rectHeight], ax
	call drawRect
	
	mov cx, 4
drawRestOfShape:
	mov ax, [word ptr bx] ; mov tile offset from shape to ax

	cmp ax, 0 ; if offset == 0: shape over
	jz endDrawShape
	
	; adds X and Y offset to rectX and rectY
	call getShapeOffset
	
	; draw tile
	call drawRect
	
	add bx, 2 ; next word (next offset)
	loop drawRestOfShape
	
endDrawShape:
	pop cx bx ax
	ret
endp drawShape

; enter: ax! - offset (word), shapeSize, rectX, rectY
; return: rectX += offsetX, rectY += offsetY 
proc getShapeOffset
	push dx
	
	; Separate X and Y offsets
	; X offset - low byte
	mov dl, al
	
	; Y offset - high byte
	mov dh, ah
	
	; calculate new tile pos
	; X offset - multiply by tile width
	mov al, [byte ptr shapeSize]
	mul dl
	
	mov ah, 0
	test dl, 10000000b ; if signed:
	jz addXoffset
	mov ah, 0FFh
	
addXoffset:
	; add X offset to rectX
	add [rectX], ax
	
Yoffset:	
	; Y offset - multiply by tile height
	mov al, [byte ptr shapeSize]
	mul dh
	
	; add Y offset to rectY
	add [byte ptr rectY], al
	
	pop dx
	ret
endp getShapeOffset