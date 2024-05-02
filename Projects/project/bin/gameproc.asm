; enter – number in ax (word)
; exit – printing the numbers digit by digit
proc 	printNumber
	push 	ax bx dx
	
	mov 	bx, offset divisorTable
nextDigit:         		
	xor 	dx, dx
	div 	[word ptr bx]   	;ax = quotient, dx = remainder
	add 	ax,'0'
	call 	printCharacter  	;Display the quotient
	
	mov 	ax, dx          	;ax = remainder
	add  	bx, 2	            ;bx = address of next divisor
	cmp 	[word ptr bx], 0 	;Have all divisors been done?
    jnz 	nextDigit
	
	pop 	dx bx ax
	ret
endp 	printNumber

; enter – character in al
; exit – printing the character
proc 	printCharacter
	push	ax dx
	
	mov	dl, al
	mov	ah, 2
	int	21h
	
	pop	dx ax
	ret
endp	printCharacter

; (enter) score
; (return) print the score to the text window
proc printScore
	
	setCursorPos 21 21
	mov dx, offset scoreMsg ; print - "Score: "
	mov ah, 9
	int 21h
	
	mov ax, [score]
	call printNumber
	
	ret
endp printScore

; prints game over
proc printGameOver
	push ax bx cx dx
	
	setCursorPos 21 22
	mov dx, offset gameOverMsg
	mov ah, 9
	int 21h
	
	setCursorPos 21 23
	mov dx, offset gameOverExit
	mov ah, 9
	int 21h
	
	pop dx cx bx ax
	ret
endp printGameOver


; (return) draw start screen
proc drawStartScreen
	push ax dx
	
	mov [currentFile], offset startImg
	call printImg
	
	setCursorPos 14 5 ; print game name
	mov dx, offset gameNameMsg
	mov ah, 9
	int 21h
	
	setCursorPos 14 7 ; print credit
	mov dx, offset creditMsg
	mov ah, 9
	int 21h
	
	setCursorPos 13 9 ; print keys
	mov dx, offset startGameMsg
	mov ah, 9
	int 21h
	
	setCursorPos 13 10
	mov dx, offset howToPlayKey
	mov ah, 9
	int 21h
	
	pop dx ax
	ret
endp drawStartScreen


; (return) draw howToPlay screen
proc drawHowToScreen
	push ax dx
	
	mov [currentFile], offset howToImg
	call printImg
	
	setCursorPos 14 0 ; print screen title
	mov dx, offset howToPlayTitle
	mov ah, 9
	int 21h
	
	setCursorPos 0 1 ; print how to play
	mov dx, offset howToPlayMsg
	mov ah, 9
	int 21h
	
	pop dx ax
	ret
endp drawHowToScreen

; (return) draw loseScreen screen
proc drawLoseScreen
	push ax dx
	
	mov [currentFile], offset loseImg
	call printImg
	
	setCursorPos 0 1 ; print game over title
	mov dx, offset gameOverTitle
	mov ah, 9
	int 21h
	
	setCursorPos 0 3 ; print score
	mov dx, offset gameOverScore
	mov ah, 9
	int 21h
	mov ax, [score]
	call printNumber
	
	call LoadHighScore	
	mov ax, [score]
	cmp ax, [word ptr highScore]
	ja newHigh
	
	setCursorPos 0 5 ; print high score
	mov dx, offset highScoreMsg
	mov ah, 9
	int 21h
	mov ax, [highScore]
	call printNumber
	
	setCursorPos 0 6 ; print high score player name
	mov dx, offset highPlayerMsg
	mov ah, 9
	int 21h
	mov dx, offset playerName
	mov ah, 9
	int 21h
	
	jmp gameOverKeys
	
newHigh:
	mov [highScore], ax ; mov score to highScore
	
	setCursorPos 0 5 ; print new high score
	mov dx, offset newHighMsg
	mov ah, 9
	int 21h
	
	setCursorPos 0 6 ; get player name
	mov dx, offset enterNameMsg ; print "enter name"
	mov ah, 9
	int 21h
	setCursorPos 0 7 ; get player name
	mov dx, offset nameMaxLen ; input name
	mov ah, 0Ah
	int 21h
	mov bx, offset playerName ; put $ at end of name
	xor ah, ah
	mov al, [byte ptr nameLen]
	add bx, ax
	mov [byte ptr bx], '$'
	
	call SaveHighScore ; save highScore to file
	
gameOverKeys:
	setCursorPos 0 8 ; print new game key
	mov dx, offset startGameMsg
	mov ah, 9
	int 21h
	
	setCursorPos 0 9 ; print exit game key
	mov dx, offset gameOverExit
	mov ah, 9
	int 21h
	
	pop dx ax
	ret
endp drawLoseScreen