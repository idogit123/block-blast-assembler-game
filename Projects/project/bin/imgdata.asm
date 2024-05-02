startImg    db 'startimg.bmp',0 ; put in current file to draw
howToImg	db 'howtoimg.bmp',0 
loseImg		db 'loseimg.bmp',0

Header      db 54 dup (0)
Palette     db 256*4 dup (0)
ScrLine     db 320 dup (0)
imgWidth dw 320
imgHeight dw 200
imgX dw 0
imgY dw 0