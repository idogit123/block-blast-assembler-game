shapeIndex dw 0
shapeSize dw 16

shapes  db 1,  0FFh, 0FFh,  000h, 001h,  002h, 000h,  000h, 000h ; L - top
		db 1,  0FFh, 000h,  002h, 000h,  000h, 001h,  000h, 000h ; L - bottom
		db 1,  000h, 0FFh,  0FFh, 002h,  001h, 000h,  000h, 000h ; L - left
		db 1,  000h, 0FFh,  001h, 000h,  0FFh, 002h,  000h, 000h ; L - right
		db 2,  0FFh, 000h,  002h, 000h,  0FFh, 001h,  000h, 000h ; T - top
		db 2,  0FFh, 000h,  002h, 000h,  0FFh, 0FFh,  000h, 000h ; T - bottom
		db 2,  000h, 0FFh,  000h, 002h,  001h, 0FFh,  000h, 000h ; T - left
		db 2,  000h, 0FFh,  000h, 002h,  0FFh, 0FFh,  000h, 000h ; T - right
		db 3,  0FFh, 0FFh,  000h, 001h,  001h, 001h,  000h, 000h ; S - top
		db 3,  001h, 0FFh,  000h, 001h,  0FFh, 001h,  000h, 000h ; S - bottom
		db 3,  0FFh, 0FFh,  001h, 000h,  001h, 001h,  000h, 000h ; S - left
		db 3,  0FFh, 000h,  001h, 0FFh,  001h, 000h,  000h, 000h ; S - right
		db 4,  000h, 000h,  000h, 000h,  000h, 000h,  000h, 000h ; 1 Tile
		db 5,  001h, 000h,  000h, 000h,  000h, 000h,  000h, 000h ; 2 Line - Horizontal
		db 5,  000h, 001h,  000h, 000h,  000h, 000h,  000h, 000h ; 2 Line - Vertical
		db 6,  0FFh, 000h,  002h, 000h,  000h, 000h,  000h, 000h ; 3 Line - Horizontal
		db 6,  000h, 0FFh,  000h, 002h,  000h, 000h,  000h, 000h ; 3 Line - Vertical
		db 7,  0FFh, 000h,  002h, 000h,  001h, 000h,  000h, 000h ; 4 Line - Horizontal
		db 7,  000h, 0FFh,  000h, 002h,  000h, 001h,  000h, 000h ; 4 Line - Vertical
		db 8,  001h, 000h,  0FFh, 001h,  001h, 000h,  000h, 000h ; Squere