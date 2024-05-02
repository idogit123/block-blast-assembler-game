include macro.asm

IDEAL
MODEL small
STACK 100h
DATASEG
jumps
; --------------------------
; Your variables here
; --------------------------
	include "rectdata.asm"
	include "shapdata.asm"
	include "bankdata.asm"
	include "borddata.asm"
	include "mausdata.asm"
	include "gamedata.asm"
	include "imgdata.asm"
	include "sunddata.asm"
	include "filedata.asm"
CODESEG
	include "rectproc.asm"
	include "shapproc.asm"
	include "bankproc.asm"
	include "bordproc.asm"
	include "mausproc.asm"
	include "gameproc.asm"
	include "imgproc.asm"
	include "sundproc.asm"
	include "fileproc.asm"
start:
	mov ax, @data
	mov ds, ax
	graphicMode
	
startScreen:
	call resetBoard
	mov [word ptr score], 0 ; reset score
	
	call drawStartScreen
waitForNewGame:
	waitForNewScanCode
	getScanCode ; scan code in var: [scanCode]
	pressedOrRelessed
	jnz waitForNewGame
	cmp [scanCode], 57 ; check if space pressed
	je newGame
	cmp [scanCode], 23 ; check if 'i' pressed
	jne waitForNewGame
	
howToScreen:
	call drawHowToScreen
waitForReturn:
	waitForNewScanCode
	getScanCode ; scan code in var: [scanCode]
	pressedOrRelessed
	jnz waitForReturn
	cmp [scanCode], 1 ; check if esc pressed
	je startScreen
	jmp waitForReturn
	
newGame:
	textMode ; retrive old palette
	graphicMode
	
	call printScore
	call newBankShapes
	call drawBank
	call drawBoard
	
	activateMouse
	showMouse
	
waitForMouse:
	call playNote
	showMouse
	getMouse
	hideMouse
	cmp bl, 0
	jnz mousePressed
	
	
	cmp [shapeIndex], 0
	jz waitForMouse
	
	call drawShapeAtMousePos
	jmp waitForMouse
	
mousePressed:
	cmp [mouseX], 160 ; check if mouse on bank
	ja checkMouseOnBoard
	
	call getShapeAtMousePos
	mov [currentSound], offset pickUpSound ; play "shape picked" sound
	call playSound
	jmp waitForMouse
	
checkMouseOnBoard:
	call isMouseOnBoard
	jnc waitForMouse
	
	call getTileIndexAtMousePos
	
	call isPlaceValid
	jnc waitForMouse
	
	call placeShape
	mov [currentSound], offset placeSound ; play "shape placed" sound
	call playSound
	
	call isComplete
	mov [shapeIndex], 0
	call drawBoard
	call printScore
	
	call isBankEmpty
	jnc checkGameOver
	call newBankShapes
	call drawBank
	
checkGameOver:
	call isAnySpaceValid
	jnc gameOver
	jmp waitForMouse
	
gameOver:
	turnoffSpeaker
	call printGameOver
waitForGameOver:
	waitForNewScanCode
	getScanCode ; scan code in var: [scanCode]
	pressedOrRelessed
	jnz waitForGameOver
	cmp [scanCode], 1 ; check if esc pressed
	jne waitForGameOver
	
waitForEscUnpressed:
	waitForNewScanCode
	getScanCode
	pressedOrRelessed
	jz waitForEscUnpressed ; if esc released, continue
	
	call drawLoseScreen
waitForExit:
	waitForNewScanCode
	getScanCode ; scan code in var: [scanCode]
	pressedOrRelessed
	jnz waitForExit
	cmp [scanCode], 57 ; check if space pressed
	je startScreen
	cmp [scanCode], 1 ; check if esc pressed
	jne waitForExit
	
exit:
	waitForKeyPressed
	textMode
	mov ax, 4c00h
	int 21h
END start


