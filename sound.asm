PUBLIC SOUND

.MODEL LARGE
DATA1 SEGMENT PARA 'DATA'


FILENAME DB 'KINGSV.WAV', 0

FILEHANDLE DW ?

SOUNDDATA DB 51529 DUP(0)

DATA1 ENDS

.CODE
SOUND PROC FAR
    
    ASSUME DS:DATA1
    MOV AX , DATA1
    MOV DS , AX
	
    CALL OPENFILE
    CALL READDATA
	
    LEA BX , SOUNDDATA ; BL CONTAINS INDEX AT THE CURRENT DRAWN PIXEL
	
	
; DRAWING LOOP
ALOOP:
    MOV DX, 22CH
	MOV AL, 10H
	OUT DX, AL
	MOV AL,[BX]
	OUT DX, AL
	MOV CX, 9433
	DELAY:
	NOP
	LOOP DELAY 
    PUSH AX
    ;{ TAKE THE USER INPUT FROM THE KEYBOARD BUFFER
         MOV    AH, 1
         INT    16H      
         CALL   CLRBUFF  
    ;} 
    ;{
         CMP    AL,1BH
         JE    EXITPROG
    ;}
    POP AX
    INC BX
    CMP BX , 51529
JNE ALOOP
EXITPROG:
    CALL CLOSEFILE
    
RETF    
SOUND ENDP
   
;--------------------------------------
CLRBUFF		PROC NEAR
	PUSH		AX
	PUSH		ES
	MOV		AX, 0000H
	MOV		ES, AX
	MOV		ES:[041AH], 041EH
	MOV		ES:[041CH], 041EH				; CLEARS KEYBOARD BUFFER
	POP		ES
	POP		AX
	RETN
CLRBUFF		ENDP 


;------------------------------------------

OPENFILE PROC NEAR

    ; OPEN FILE

    MOV AH, 3DH
    MOV AL, 0 ; READ ONLY
    LEA DX, FILENAME
    INT 21H
    
    ; YOU SHOULD CHECK CARRY FLAG TO MAKE SURE IT WORKED CORRECTLY
    ; CARRY = 0 -> SUCCESSFUL , FILE HANDLE -> AX
    ; CARRY = 1 -> FAILED , AX -> ERROR CODE
     
    MOV [FILEHANDLE], AX
    
    RETN

OPENFILE ENDP



;-----------------------------------------------


READDATA PROC NEAR

    MOV AH,3FH
    MOV BX, [FILEHANDLE]
    MOV CX, 51529 ; NUMBER OF BYTES TO READ
    LEA DX, SOUNDDATA
    INT 21H
    RETN
READDATA ENDP 

;------------------------------------------------

CLOSEFILE PROC NEAR
	MOV AH, 3EH
	MOV BX, [FILEHANDLE]

	INT 21H
	RETN
CLOSEFILE ENDP

    
    
    
    
    END SOUND
