; (enter) var: pixelX (word, 0-320), pixelY (word, 0-200), rectColor (byte)
; (return) draw pixel  
proc drawPixel	
	push bx cx dx ax 
	mov bh, 0
	mov cx, [pixelX]
	mov dx, [pixelY]
	mov al, [rectColor]
	mov ah, 0ch
	int 10h
	pop ax dx cx bx
	ret
endp

; (enter) var: lineX (word, 0-320), lineY (word, 0-200), rectWidth (word, length of line), rectColor (byte)
; return: draw horizontal line  
proc drawLine
	push ax cx
	
	mov cx, [rectWidth]
	mov ax, [lineX]
	mov [pixelX], ax
	mov ax, [lineY]
	mov [pixelY], ax
	
drawPixelLoop:
	call drawPixel
	inc [pixelX]
	loop drawPixelLoop
	
	pop cx ax
	ret
endp

; (enter) var: rectX (word, 0-320), rectY (word, 0-200), rectWidth (word), rectHeight (word), rectColor (byte)
; return: draw rect 
proc drawRect
	push ax cx

	mov cx, [rectHeight]
	mov ax, [rectY]
	mov [lineY], ax
	mov ax, [rectX]
	mov [lineX], ax
	
drawLineLoop: 
	call drawLine
	inc [lineY]
	loop drawLineLoop
	
	pop cx ax
	ret
endp

; (enter) var: lineX (word, 0-320), lineY (word, 0-200), rectHeight (word, length of line), rectColor (byte)
; return: draw vertical line  
proc drawVerticalLine
	push ax cx
	
	mov cx, [rectHeight]
	mov ax, [lineX]
	mov [pixelX], ax
	mov ax, [lineY]
	mov [pixelY], ax
	
drawPixelLoopVertical:
	call drawPixel
	inc [pixelY]
	loop drawPixelLoopVertical
	
	pop cx ax
	ret
endp