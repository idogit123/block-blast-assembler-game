currentSound	dw ?
soundTimer		dw ?
clock 			equ es:6Ch
lastClock		dw ?


pickShapeSound	dw 069fh, 5, 0a98h, 5, 0be3h, 5, 11d1h, 2, 0fdfh, 2, 0
pickUpSound		dw 11d1h, 2, 0a98h, 3, 0
placeSound		dw 0a98h, 2, 11d1h, 3, 0
completeSound	dw 0fdfh, 3, 0be3h, 2, 069fh, 5, 0