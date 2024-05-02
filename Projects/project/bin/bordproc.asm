; (enter) board
; (return) draw board on screen
proc drawBoard
	; vertical lines
	mov [lineX], 160
	mov [lineY], 0
	mov [rectHeight], 160
	mov [rectColor], 0Fh
	
	mov cx, 7
drawBoardVerticalLines:
	add [lineX], 20
	call drawVerticalLine
	loop drawBoardVerticalLines
	
	
	; horizontal lines
	mov [lineX], 160
	mov [lineY], -1
	mov [rectWidth], 160
	mov [rectColor], 0Fh
	
	mov cx, 8
drawBoardHorizontalLines:
	add [lineY], 20
	call drawLine
	loop drawBoardHorizontalLines
	
	
	; draw the tiles
	mov [rectY], 0
	mov [rectWidth], 19
	mov [rectHeight], 19
	mov bx, offset board
	
	mov cx, 8
drawBoardRow:
	push cx
	mov [rectX], 161
	mov cx, 8
drawBoardTile:
	mov al, [byte ptr bx]
	mov [rectColor], al
	call drawRect
	add [rectX], 20
	inc bx
	loop drawBoardTile
	add [rectY], 20
	pop cx
	loop drawBoardRow
	
	ret
endp drawBoard

; (enter) mouseX, mouseY
; (return) carry flag = 1: mouse on board, else mouse not on board
proc isMouseOnBoard
	
	cmp [mouseX], 161
	jb mouseNotOnBoard
	cmp [mouseX], 320
	ja mouseNotOnBoard
	cmp [mouseY], 160
	ja mouseNotOnBoard
	
	stc ; mouse on board
	ret
mouseNotOnBoard:
	clc
	ret
endp isMouseOnBoard

; (enter) mouseX, mouseY
; (return) tileIndex
proc getTileIndexAtMousePos
	push ax bx
	
	mov ax, [mouseY] ; al = tileY = mouseY (0-160) / 20 
	mov bl, 20 
	div bl
	shl al, 3 ; al = tileIndex = tileY * 8
	mov [tileIndex], al
	
	mov ax, [mouseX] ; al = tileX = mouseX (0-160) / 20
	sub ax, 160
	div bl
	add [tileIndex], al ; tileIndex = tileY * 8 + tileX
	
	pop bx ax
	ret
endp getTileIndexAtMousePos


; (enter) shapeIndex, tileIndex
; (return) carry flag = 1: place valid for shape, else place not valid
proc isPlaceValid
	push ax bx cx si [word ptr tileIndex]
	
	xor bh, bh
	mov bl, [tileIndex] ; the first tile in shape
	add bx, offset board 
	
	cmp [byte ptr bx], 0 ; check if first tile free
	jnz placeNotValid
	
	mov si, [shapeIndex] ; si = shapeIndex
	inc si ; skip color byte
	
	mov cx, 4
checkRestOfTiles:
	mov ax, [si] ; ax = tile offset
	
	cmp ax, 0 ; if offset == 0: shape over
	jz endCheckTiles
	
	call getTileOffset
	jnc placeNotValid ; if carry == 0: place not valid
	
	xor bh, bh
	mov bl, [tileIndex] ; calculate byte index
	add bx, offset board 
	cmp [byte ptr bx], 0 ; check if tyle free
	jnz placeNotValid
	
	add si, 2 ; next offset
	loop checkRestOfTiles
	
endCheckTiles:
	stc ; place valid
	pop [word ptr tileIndex] si cx bx ax
	ret
	
placeNotValid:
	clc
	pop [word ptr tileIndex] si cx bx ax
	ret
endp isPlaceValid


; enter: ax! - offset (word), tileIndex
; return: tileIndex += offsetY * 8 + offsetX
; flag: if carry == 0: place not valid, offset leads out of bounds
proc getTileOffset
	push bx dx
	
	; Separate X and Y offsets
	mov dl, al ; X offset - low byte
	mov dh, ah ; Y offset - high byte
	
	; calculate new tileIndex
	xor ah, ah ; seperate tileIndex to tileX and tileY
	mov al, [tileIndex] 
	mov bl, 8
	div bl ; ah = tileX, al = tileY
	
	; X offset
	add ah, dl ; tileX + Xoffset
	cmp ah, 0 ; check if index stays in board
	jl offsetNotValid 
	cmp ah, 7
	ja offsetNotValid
	add [tileIndex], dl ; if Xoffset valid
	
	; Y offset
	add al, dh ; tileY + Yoffset
	cmp al, 0 ; check if index stays in board
	jl offsetNotValid 
	cmp al, 7
	ja offsetNotValid
	; if Yoffset valid
	shl dh, 3 ; multiply by tiles in row (8)
	add [tileIndex], dh
	
	stc ; offset valid
	pop dx bx
	ret
	
offsetNotValid:
	clc 
	pop dx bx
	ret
endp getTileOffset


; (enter) tileIndex, shapeIndex
; (return) places the shape at tileIndex. !make sure place valid!
proc placeShape
	push ax bx cx dx si [word ptr tileIndex]
	
	mov ax, [mouseX]
	sub ax, 10
	mov [rectX], ax
	mov ax, [mouseY]
	sub ax, 10
	mov [rectY], ax
	call retShape
	
	mov si, [shapeIndex] ; si = shapeIndex
	mov dl, [si] ; dl = shape color
	inc si ; skip color byte
	
	mov bx, [word ptr tileIndex] ; the first tile in shape
	add bx, offset board 
	mov [bx], dl
	inc [score]
	
	mov cx, 4
placeRestOfShape:
	mov ax, [si] ; ax = tile offset
	
	cmp ax, 0 ; if offset == 0: shape over
	jz endPlaceShape
	
	call getTileOffset
	
	mov bx, [word ptr tileIndex] ; calculate byte index
	add bx, offset board 
	mov [bx], dl
	inc [score]
	
	add si, 2 ; next offset
	loop placeRestOfShape

endPlaceShape:
	pop [word ptr tileIndex] si dx cx bx ax
	ret
endp placeShape


; (enter) tileIndex
; (return) if row complete: empty row
; (flag) if carry == 0: row incomplete, else row complete
proc isRowComplete
	push bx cx 
	
	mov bx, [word ptr tileIndex] ; calculate index of first tile in row
	and bl, 11111000b ; round down to multiply of 8
	add bx, offset board
	push bx ; save for later
	cmp [byte ptr bx], 0 ; check first tile of row
	jz rowNotComplete
	
	mov cx, 7
checkRestOfRow:
	inc bx
	cmp [byte ptr bx], 0 ; check tile
	jz rowNotComplete
	loop checkRestOfRow
	
	; if row complete
	add [score], 8
	mov [currentSound], offset completeSound ; play "row completed" sound
	call playSound
	pop bx ; index of start of row
	mov cx, 8
emptyRow:
	mov [byte ptr bx], 0
	inc bx
	loop emptyRow
	
	stc ; flag row complete
	pop cx bx
	ret
	
rowNotComplete:
	clc ; flag row incomplete
	pop bx cx bx
	ret
endp isRowComplete

; (enter) tileIndex
; (return) if col complete: empty col
; (flag) if carry == 0: col incomplete, else col complete
proc isColComplete
	push bx cx 
	
	mov bx, [word ptr tileIndex] ; calculate index of first tile in col
	and bl, 00000111b ; modulu 8 (tileIndex % 8)
	add bx, offset board
	push bx ; save for later
	cmp [byte ptr bx], 0 ; check first tile of col
	jz colNotComplete
	
	mov cx, 7
checkRestOfCol:
	add bx, 8
	cmp [byte ptr bx], 0 ; check tile
	jz rowNotComplete
	loop checkRestOfCol
	
	; if col complete
	add [score], 8
	mov [currentSound], offset completeSound ; play "column completed" sound
	call playSound
	pop bx ; index of start of col
	mov cx, 8
emptyCol:
	mov [byte ptr bx], 0
	add bx, 8
	loop emptyCol
	
	stc ; flag col complete
	pop cx bx
	ret
	
colNotComplete:
	clc ; flag col incomplete
	pop bx cx bx
	ret
endp isColComplete

; (enter) tileIndex, shapeIndex
; (return) if any row / col complete, delete them
proc isComplete
	push ax bx cx
	
	call isRowComplete ; check completion for the first tile
	call isColComplete
	
	mov bx, [shapeIndex] ; bx = shape
	inc bx ; skip color byte
	
	mov cx, 4
checkTileComplete:
	mov ax, [bx] ; ax = tile offset
	
	cmp ax, 0 ; if offset == 0: shape over
	jz endIsComplete
	
	call getTileOffset
	
	call isRowComplete ; check completion for tile
	call isColComplete
	
	add bx, 2
	loop checkTileComplete
	
endIsComplete:
	pop cx bx ax
	ret 
endp isComplete


; (enter) none
; (return)  carry flag = 1: there is any valid place, else there is not
proc isAnySpaceValid
	push ax bx cx [shapeIndex]
	
	mov bx, offset bankShapes
	mov cx, 3
isSpaceForShape:
	mov ax, [bx] ; ax = offset of the shape
	cmp ax, 0
	jz checkNextShape
	
	mov [shapeIndex], ax
	push cx
	mov cx, 64
isValidForShape:
	mov [tileIndex], cl
	dec [tileIndex]
	call isPlaceValid
	jc thereIsValidSpace 
	loop isValidForShape
	
	pop cx
checkNextShape:
	add bx, 2
	loop isSpaceForShape
	
thereIsNoValidSpace:
	clc
	pop [shapeIndex] cx bx ax
	ret
	
thereIsValidSpace:
	stc
	pop cx [shapeIndex] cx bx ax
	ret
endp isAnySpaceValid

; resets board to all 0
proc resetBoard
	push ax cx di es
	
	mov ax, ds
	mov es, ax
	mov di, offset board
	mov ax, 0
	mov cx, 32
	rep stosw
	
	pop es di cx ax
	ret
endp resetBoard