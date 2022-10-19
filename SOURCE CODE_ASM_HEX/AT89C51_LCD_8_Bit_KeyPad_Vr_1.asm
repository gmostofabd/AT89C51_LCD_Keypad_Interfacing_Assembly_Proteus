;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ORG	00H
	MOV	SP, #70H
	MOV	PSW, #00H


IO_DECLERATION:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RS EQU P2.1 ; RS ON LCD
EN EQU P2.2 ; EN ON LCD

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PORT_INIT:
	MOV 	P0, #00H
	MOV 	P1, #00H
	MOV 	P2, #00H
	MOV 	P3, #0FEH

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
REG_INIT:
	MOV 	R0, #00H
	MOV 	R1, #00H
	MOV 	R2, #00H
	MOV 	R3, #00H
	MOV 	R4, #00H
	MOV 	R5, #00H
	MOV 	R6, #00H
	MOV 	R7, #00H

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LCD_INIT:
	MOV 	R0, #38H
	ACALL 	COMMAND		;call command subroutine
	MOV 	R0, #0EH
	ACALL 	COMMAND
	MOV 	R0, #01H
	ACALL 	COMMAND
	MOV 	A,#06H 		;Increment cursor
	ACALL 	COMMAND
	MOV 	R0, #80H
	ACALL 	COMMAND
	MOV 	A,#3CH 		;Activate second line
	ACALL 	COMMAND

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
STARTUP_MSG:		
	MOV 	R0, #01H
	ACALL 	COMMAND
	MOV	DPTR, #MSG_START
DO_LOOP1:	
	CLR	A
	MOVC	A, @A+DPTR
	MOV 	R0, A
	JZ	EXIT1
	ACALL 	DISPLAY			;call display subroutine
	ACALL 	DELAY			;give LCD some time
	INC	DPTR
	LJMP	DO_LOOP1
EXIT1:
	MOV 	R0, #01H
	ACALL 	COMMAND


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;SCANNING ALL COLUMN  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
L1:
	JNB 	P3.0, C1
	JNB 	P3.1, C2
	JNB 	P3.2, C3
	JNB 	P3.3, C4
	SJMP 	L1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;SCANNING COLUMN1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
C1:
	JNB 	P3.4, JUMP_TO_7	
	JNB 	P3.5, JUMP_TO_4	
	JNB 	P3.6, JUMP_TO_1	
	JNB 	P3.7, JUMP_2CLR	
	SETB 	P3.0
	CLR 	P3.1
	SJMP 	L1
;SCANNING COLUMN2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
C2:
	JNB 	P3.4, JUMP_TO_8	
	JNB 	P3.5, JUMP_TO_5	
	JNB 	P3.6, JUMP_TO_2	
	JNB 	P3.7, JUMP_TO_0	
	SETB 	P3.1
	CLR 	P3.2
	SJMP 	L1
;SCANNING COLUMN3 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
C3:
	JNB 	P3.4, JUMP_TO_9	
	JNB 	P3.5, JUMP_TO_6	
	JNB 	P3.6, JUMP_TO_3	
	JNB 	P3.7, JUMP_EQUAL	
	SETB 	P3.2
	CLR 	P3.3
	SJMP 	L1
;SCANNING COLUMN4 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
C4:
	JNB 	P3.4, JUMP_DIVIDE	;JUMP_DIVIDE
	JNB 	P3.5, JUMP_MULTI	;JUMP_MULTI
	JNB 	P3.6, JUMP_MINUS	;JUMP_MINUS
	JNB 	P3.7, JUMP_PLUS	;JUMP_PLUS
	SETB 	P3.3
	CLR 	P3.0
	LJMP 	L1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
JUMP_2CLR: 	LJMP 	BOT_ON
JUMP_TO_0: 	LJMP 	NUM_0
JUMP_TO_1: 	LJMP 	NUM_1
JUMP_TO_2: 	LJMP 	NUM_2
JUMP_TO_3: 	LJMP 	NUM_3
JUMP_TO_4: 	LJMP 	NUM_4
JUMP_TO_5: 	LJMP 	NUM_5
JUMP_TO_6: 	LJMP 	NUM_6
JUMP_TO_7: 	LJMP 	NUM_7
JUMP_TO_8: 	LJMP 	NUM_8
JUMP_TO_9: 	LJMP 	NUM_9
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
JUMP_PLUS: 	LJMP 	ADD_FUNC
JUMP_MINUS: 	LJMP 	SUB_FUNC
JUMP_MULTI: 	LJMP 	MUL_FUNC
JUMP_DIVIDE: 	LJMP	DIV_FUNC
JUMP_EQUAL: 	LJMP 	EQU_FUNC
BOT_ON: 
	MOV 	R0, #01H
	ACALL 	COMMAND
	LJMP 	L1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NUM_0:		;LOAD DECIMAL 0
	JNB 	P3.7,NUM_0
	MOV 	R0, #'0';MOVE CHARACTER 0 TO R0 REG	
	ACALL 	DISPLAY	;PRINT ON LCD
	LJMP 	L1

NUM_1:		;LOAD DECIMAL 1 
	JNB 	P3.6,NUM_1			
	MOV 	R0, #'1'
	ACALL 	DISPLAY	;PRINT ON LCD
	LJMP 	L1

NUM_2:		;LOAD DECIMAL 2		
	JNB 	P3.6,NUM_2
	MOV 	R0, #'2'	
	ACALL 	DISPLAY	;PRINT ON LCD	
	LJMP 	L1

NUM_3:		;LOAD DECIMAL 3
	JNB 	P3.6,NUM_3
	MOV 	R0, #'3'	
	ACALL 	DISPLAY	;PRINT ON LCD
	LJMP 	L1

NUM_4:		;LOAD DECIMAL 4
	JNB 	P3.5,NUM_4
	MOV 	R0, #'4'
	ACALL 	DISPLAY	;PRINT ON LCD
	LJMP 	L1

NUM_5:		;LOAD DECIMAL 5
	JNB 	P3.5,NUM_5
	MOV 	R0, #'5'	
	ACALL 	DISPLAY	;PRINT ON LCD
	LJMP 	L1

NUM_6:		;LOAD DECIMAL 6
	JNB 	P3.5,NUM_6
	MOV 	R0, #'6'
	ACALL 	DISPLAY	;PRINT ON LCD
	LJMP 	L1

NUM_7:		;LOAD DECIMAL 7
	JNB 	P3.4,NUM_7
	MOV 	R0, #'7'	
	ACALL 	DISPLAY	;PRINT ON LCD
	LJMP 	L1

NUM_8:		;LOAD DECIMAL 8
	JNB 	P3.4,NUM_8	
	MOV 	R0, #'8'	
	ACALL 	DISPLAY	;PRINT ON LCD
	LJMP 	L1

NUM_9:		;LOAD DECIMAL 9
	JNB 	P3.4,NUM_9
	MOV 	R0, #'9'		
	ACALL 	DISPLAY
	LJMP 	L1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EQU_FUNC:	;LOAD = SIGN
	JNB 	P3.7,EQU_FUNC
	MOV 	R0, #'='			
	ACALL 	DISPLAY	
	LJMP 	L1

ADD_FUNC: 	;LOAD + SIGN
	JNB 	P3.7,ADD_FUNC
	MOV 	R0, #'+'	
	ACALL 	DISPLAY	;PRINT ON LCD
	LJMP 	L1

SUB_FUNC:	;LOAD - SIGN
	JNB 	P3.6,SUB_FUNC
	MOV 	R0, #'-'
	ACALL 	DISPLAY	;PRINT ON LCD
	LJMP 	L1

MUL_FUNC:	;LOAD * SIGN
	JNB 	P3.5,MUL_FUNC
	MOV 	R0, #'*'
	ACALL 	DISPLAY	;PRINT ON LCD
	LJMP 	L1

DIV_FUNC:	;LOAD DIVISSION SIGN
	JNB 	P3.4,DIV_FUNC
	MOV 	R0, #'/'	
	ACALL 	DISPLAY	;PRINT ON LCD
	LJMP 	L1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DISPLAY:
	MOV 	P0, R0
	SETB 	RS
	SETB 	EN
	ACALL 	DELAY
	CLR 	EN
	RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
COMMAND:
	MOV 	P0, R0
	CLR 	RS
	SETB 	EN
	ACALL 	DELAY
	CLR 	EN
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DELAY:	MOV 	62, #2		;APPROX DELAY DE 0.25s
DELAY1:	MOV 	61, #100
DELAY2:	MOV 	60, #250
	DJNZ 	60, $
	DJNZ 	61, DELAY2
	DJNZ 	62, DELAY1
	RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;DB - DEFINE BYTE (INITIALIZE THE MEMORY)
MSG_START: DB 'AT89S52 KEYPAD',0 ;START MESSAGE

END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;