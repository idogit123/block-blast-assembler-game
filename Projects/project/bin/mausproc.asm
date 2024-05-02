; (enter) rectX, rectY, shapeSize, keepRectOffset
; (return) returns keepRect to screen
proc retRect
	push ax cx es si di
	mov ax, 0A000h ; set es to screen memory
	mov es, ax
	
	mov ax, 320	; calculate starting pixel
	mul [rectY]
	add ax, [rectX]
	mov di, ax
	
	mov si, [keepRectOffset]
	mov cx, [shapeSize] ; height of keepRect
ret_row:
	push cx
	mov cx, [shapeSize] ; width of keepRect
ret_pixel:
	mov al, [si] ; mov pixel from keepRect to screen
	mov [es:di], al
	inc si ; next pixel
	inc di
	loop ret_pixel
	
	add di, 320 ; next row
	sub di, [shapeSize] ; start of row
	
	pop cx
	loop ret_row
	
	pop di si es cx ax
	ret
endp retRect

; (enter) rectX, rectY, shapeIndex
; (return) return pixels from keepShape to screen 
proc retShape
	push ax bx cx [rectX] [rectY]
	
	; ret the first tile
	mov [keepRectOffset], offset keepShape ; the pixels of the tile would be stored at keepRectOffset
	call retRect
	
	mov bx, [shapeIndex] ; bx = shapeIndex
	inc bx ; skip color byte
	
	mov cx, 4
retRestOfShape:
	mov ax, [word ptr bx] ; ax = tile offset 

	; check if offset is 0
	cmp ax, 0
	jz endRetShape
	
	; adds X and Y offset to rectX and rectY
	call getShapeOffset
	
	add [keepRectOffset], 20*20 ; next keepTile
	call retRect
	
	add bx, 2 ; next word (next offset)
	loop retRestOfShape
	
endRetShape:
	pop [rectY] [rectX] cx bx ax
	ret
endp retShape

; (enter) rectX, rectY, shapeSize, keepRectOffset
; (return) takes a keepRect from screen
proc takeRect
	push ax cx es si di
	mov ax, 0A000h ; set es to screen memory
	mov es, ax
	
	mov ax, 320	; calculate starting pixel
	mul [rectY]
	add ax, [rectX]
	mov di, ax
	
	mov si, [keepRectOffset]
	mov cx, [shapeSize] ; height of keepRect
take_row:
	push cx
	mov cx, [shapeSize] ; width of keepRect
take_pixel:
	mov al, [es:di] ; mov pixel from screen to keepRect
	mov [si], al
	inc si ; next pixel
	inc di
	loop take_pixel
	
	add di, 320 ; next row
	sub di, [shapeSize] ; start of row
	
	pop cx
	loop take_row
	
	pop di si es cx ax
	ret
endp takeRect

; (enter) rectX, rectY, shapeIndex, keepShape
; (return) take pixels in shape from screen to keepShape
proc takeShape
	push ax bx cx [rectX] [rectY]
	
	; take the first tile
	mov [keepRectOffset], offset keepShape ; the pixels of the tile would be stored at keepRectOffset
	call takeRect
	
	; bx = shapeIndex, skip color byte.
	mov bx, [shapeIndex]
	inc bx
	
	mov cx, 4
takeRestOfShape:
	mov ax, [word ptr bx] ; ax = tile offset 

	; check if offset is 0
	cmp ax, 0
	jz endTakeShape
	
	; adds X and Y offset to rectX and rectY
	call getShapeOffset
	
	add [keepRectOffset], 20*20 ; next keepTile
	call takeRect
	
	add bx, 2 ; next word (next offset)
	loop takeRestOfShape
	
endTakeShape:
	pop [rectY] [rectX] cx bx ax
	ret
endp takeShape


; (enter) oldMouseX, oldMouseY, mouseX, mouseY, shapeIndex
; (return) draws shape at mouse pos
proc drawShapeAtMousePos
	push ax
	
	mov ax, [oldMouseX]
	cmp ax, [mouseX]
	jnz moveShape
	
	mov ax, [oldMouseY]
	cmp ax, [mouseY]
	jz dontMove
	
moveShape:
	mov ax, [oldMouseX] ; set mouse at center of tile
	sub ax, 10
	mov [rectX], ax
	mov ax, [oldMouseY]
	sub ax, 10
	mov [rectY], ax
	mov [shapeSize], 20

	call retShape
	
	mov ax, [mouseX] ; set mouse at center of tile
	sub ax, 10
	mov [rectX], ax
	mov ax, [mouseY]
	sub ax, 10
	mov [rectY], ax
	
	call takeShape
	call drawShape
	
dontMove:
	pop ax
	ret
endp drawShapeAtMousePos