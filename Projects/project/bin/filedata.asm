openErrorMsg	db 'Error in open file', 13, 10,'$'
readErrorMsg	db 'Error in read file', 13, 10,'$'
writeErrorMsg	db 'Error in write file', 13, 10, '$'	
filehandle 	dw ?
currentFile dw ?
readBuffer 	db 5 dup(?)
fileBuffer	db 11 dup (?) ; name(8 bytes) + '$'(1 byte) + score(2 bytes)

testFile	db "filetest.txt", 0
testText	db 03h, 0E8h