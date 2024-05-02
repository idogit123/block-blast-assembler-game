; 21, 21 is the start of the text window
scanCode 		db ?

divisorTable	dw 1000, 100, 10, 1, 0
scoreMsg 		db "Score: $"
score 			dw 51
nameMaxLen		db 8
nameLen			db 0
playerName		db 9 dup(0)
highScore		dw 0
; start screen
gameOverMsg 	db "Game Over!$"
gameNameMsg		db "Block Blast!$"
creditMsg 		db "By Ido V. Z.$"
startGameMsg	db "SPC - New game$" ; len = 14
howToPlayKey	db "i: How to play$"
; how to play screen
howToPlayTitle	db "How To Play:$"
howToPlayMsg 	db "Each turn you get 3 shapes in the bank.", 10
				db "Place these on the board to get points.", 10
				db "If you complete a row / column you get", 10, "more points.", 10
				db "When you place all 3", 10, "shapes you get 3", 10, "new ones.", 10
				db "If there is no", 10, "space on the", 10, "board you lose.", 10
				db "ESC: Return to start$"
; game over screen
gameOverTitle	db "Game Over!$"
gameOverScore	db "Score - $"
gameOverExit	db "ESC - Exit$" ; len = 10
highScoreMsg	db "High Score: $"
highPlayerMsg	db "By: $"
newHighMsg		db "New High!$"
enterNameMsg	db "Enter name: $"