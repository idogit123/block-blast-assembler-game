;enter – file name in currentFile, al = 0 (read), 1 (write), 2 (read & write)
;exit - Open file, put handle in filehandle
proc OpenFile
	push dx
	
	mov ah, 3Dh
	mov dx,  [currentFile]
	int 21h
	jc openerror
	
	mov [filehandle], ax
	pop dx
	ret
	
openerror:
	mov dx, offset openErrorMsg
	mov ah, 9h
	int 21h
	mov ax, 4c00h ; exit the program
	int 21h
endp OpenFile

;enter – filehandle
;exit – close the
proc CloseFile
	push ax bx
	mov ah,3Eh
	mov bx, [filehandle]
	int 21h
	pop bx ax
	ret
endp CloseFile


; (enter) cuurentFile, buffer, cx = number of bytes to read
; (return) read (cx) bytes out of file
proc ReadFile
	push ax bx dx
	
	mov al, 0
	call OpenFile
readChunk:
	mov dx, offset fileBuffer
	mov bx, [filehandle]
	mov ah, 3Fh
	int 21h
	jc readError
	cmp ax, cx ; check if read number of bytes requested
	jb partialRead
wholeChunk:
	jmp endOfFile
	
partialRead:
	test ax, ax ; check if no bytes left
	jz endOfFile
partialChunk:
	; do something with partial chunk
	
endOfFile:
	mov bx, [filehandle] ; close file
	mov ah, 3Eh
	int 21h
	pop dx bx ax
	ret
	
readError:
	mov dx, offset readErrorMsg
	mov ah, 9h
	int 21h
	mov ax, 4c00h ; exit the program
	int 21h
endp ReadFile

; (enter) buffer, ax = number of bytes in buffer
; (return) print the bytes in the buffer
proc printBuffer
	push bx cx
	
	mov cx, ax
	mov bx, offset readBuffer
printByte:
	mov dl, [byte ptr bx]
	mov ah, 2
	int 21h
	inc bx
	loop printByte
	
	pop cx bx
	ret
endp printBuffer


; (enter) cuurentFile, dx = point to what to write, cx = bytes to write
; (return) write to file
proc WriteFile
	push ax bx
	
	mov al, 1
	call OpenFile
	mov bx, [filehandle] ; write to file
	mov ah, 40h
	int 21h
	jc writeError
	
	; cmp ax, cx ; check if wrote number of bytes requested
	; jb writeError
	
	mov bx, [filehandle] ; close file
	mov ah, 3Eh
	int 21h
	pop bx ax
	ret
	
writeError:
	mov dx, offset writeErrorMsg
	mov ah, 9h
	int 21h
	mov ax, 4c00h ; exit the program
	int 21h
endp WriteFile


; (enter) playerName, highScore
; (return) write them to file
proc SaveHighScore
	push ax cx dx si di ds es 
	
	mov ax, ds
	mov es, ax
	
	mov si, offset playerName ; copy player name into file buffer
	mov di, offset fileBuffer
	mov cx, 9
	rep movsb
	
	mov ax, [highScore]
	mov di, offset fileBuffer
	add di, 9 ; offset of the score bytes in the file buffer
	mov [word ptr di], ax ; copy high score to end of file buffer
	
	mov [currentFile], offset testFile
	mov dx, offset fileBuffer
	mov cx, 11
	call writeFile
	
	pop es ds di si dx cx ax
	ret
endp SaveHighScore


; (return) loads playerName, highScore from file
proc LoadHighScore
	push ax cx si di es
	
	mov cx, 11
	mov [currentFile], offset testFile
	call ReadFile ; read 11 bytes out of file
	
	mov ax, ds
	mov es, ax
	
	mov si, offset fileBuffer ; copy player name from file buffer
	mov di, offset playerName
	mov cx, 9
	rep movsb
	
	mov ax, [word ptr si] ; copy high score from fileBuffer
	mov [highScore], ax
	
	pop es di si cx ax
	ret
endp LoadHighScore