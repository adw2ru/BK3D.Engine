	;
CALCD:	; CALC DIVS
	MOV #DIVS,R0
	MOV #256.,R5
1$:	MOV #16.,R2
	SWAB R2
	MOV #257.,R4
	SUB R5,R4
	CALL SPDIV
	MOV R2,(R0)+
	SOB R5,1$
	;
	; WRC TABLES
	MOV #WRC+64.,R0
	MOV R0,R3
	MOV #32.,R5
100$:	MOV R3,-(R0)
	MOV R0,-(SP)
	;MOV #33.,R4
	;SUB R5,R4
	;MOV #16.,R2
	;SWAB R2
	;MOV R3,-(SP)
	;CALL SPDIV
	;MOV (SP)+,R3
	MOV R5,R2
	ASL R2
	MOV DIVS-2(R2),R2
	MOV R5,R4
	CLR R0
101$:	MOV R0,R1
	SWAB R1
	MOVB R1,(R3)+
	ADD R2,R0
	SOB R4,101$
	MOV (SP)+,R0
	SOB R5,100$
	; END WRC TABLES
	;
	; FLOOR/CEILING	DRAW CODE
	MOV #FCTAB+100.,R0
	MOV #FCTAB+34.,R1
	MOV #VSCR+10000,R3
	MOV #10107,-(R0)	; MOV R1,PC
	MOV R0,-(R1)
	MOV #16.,R2
10$:	MOV R3,-(R0)		;
	MOV #110063,-(R0)	; MOVB R0,X(R3)
	MOV R0,-(R1)
	ADD #256.,R3
	SOB R2,10$
	; DONE FLOOR&CEILING
	;
	RET
DIVS:	.BLKW 256.
FCTAB:	.BLKB 100.		; (2+16*4)+2*17
	;
	; DRAW FRAME
DRDIFF:	CLR R5
F1:	CALL @SNDPR
	MOV #32.,R1
	MOV FRBF1(R5),R2
	MOV R2,R0
	BIC #177000,R2
	MOV DIVS(R2),R4	; DIVS
	ASR R2
	; PEEK MATERIAL
	MOV FRBF2(R5),R3
	BIC #177741,R3
	MOV MTRLHV(R3),R3
	; TEXTURE COORD.
	BIC #141777,R0
	ASL R0
	ASL R0
	SWAB R0
	ADD R3,R0	; TEXTURE
	MOV R0,TXTB+2
	MOV R0,TXTS+2
	CMP R2,R1	; CLIP HEIGHT
	BEQ FD		; SAME
	BLO F2
	MOV R1,R2	; CLIP HEIGHT
	BR FC		; NO FLOOR VISIBLE
F2:	; DRAW FLOOR&CEILING
	MOV #42021,R0	; R2=63,62,...,1->31,31...0
	MOV R5,R3
	ASR R3
	MOV #FA,R1
	MOV FCTAB(R2),PC
FA:	SWAB R0
	ADD #128.,R3
	MOV #FD,R1
	BIT R2,#1
	BEQ FB
	MOV FCTAB+1(R2),PC
	BR FD
FB:	MOV FCTAB(R2),PC
	; DONE FLOOR&CEILING
FD:	; DRAW SMALL WALLS
	MOV R5,-(SP)
	ASR R5
	ADD #VSCR+20000,R5
	MOV #128.,R3
	MOV R2,R0
	ASL R0
	MOV WRC-2(R0),R0
DWLS:	SUB R3,R5		; 1
	MOVB (R0)+,R1		; 2
TXTS:	MOVB 0(R1),(R5)		; 3
	SOB R2,DWLS		; 4
	MOV (SP)+,R5
	; DONE DRAW SMALL WALLS
	BR FE
	; DRAW BIG WALLS
FC:	MOV R5,-(SP)
	ASR R5
	ADD #VSCR+20000,R5
	MOV #128.,R3
	CLR R0
DWLB:	SUB R3,R5		; 1
	MOV R0,R1		; 2
	ADD R4,R0		; 3
	SWAB R1			; 4
	MOVB R1,R1		; 5
TXTB:	MOVB 0(R1),(R5)		; 6
	SOB R2,DWLB		; 7
	MOV (SP)+,R5
	; DONE DRAW BIG	WALLS
FE:	TST (R5)+
	CMP R5,#128.
	BLO F1
	; HALF-SCREEN MIRROR
	MOV #70000-256.,R0
	MOV #50000,R1
	MOV #32.-1.,R5
2$:	MOV #2,R2
1$:	MOV (R1)+,(R0)+
	MOV (R1)+,(R0)+
	MOV (R1)+,(R0)+
	MOV (R1)+,(R0)+
	MOV (R1)+,(R0)+
	MOV (R1)+,(R0)+
	MOV (R1)+,(R0)+
	MOV (R1)+,(R0)+
	MOV (R1)+,(R0)+
	MOV (R1)+,(R0)+
	MOV (R1)+,(R0)+
	MOV (R1)+,(R0)+
	MOV (R1)+,(R0)+
	MOV (R1)+,(R0)+
	MOV (R1)+,(R0)+
	MOV (R1)+,(R0)+
	SOB R2,1$
	ADD #64.,R1
	SUB #128.+64.,R0
	SOB R5,2$
	RET
	;
	; INTERNAL RAY TRACE ROUTINE
	; IN:
	; R3=DA
	; R4=DB
	; OUT:
	; R0=RAW TYPE
	; R2=RAW HEIGHT	AND RAW	TEXT.COORD.
CORE:	CALL @SNDPR
	;
	MOV R3,-(SP)
	MOV R4,-(SP)
	MOV R5,-(SP)
	MOV R3,R2
	BMI S1
	MOV #5202,DDII		; MOV #1.,DDI,INC R2
	MOV #64.,R0
	SUB DU0,R0		; R0=U,	64..1
	BR S2
S1:	MOV #5302,DDII		; MOV #-1.,DDI,DEC R2
	MOV DU0,R0
	INC R0			; R0=U,	1..64
	NEG R2			; -A1
S2:	MOV R4,R3
	BMI S3
	MOV #62702,DDJI		; MOV #16.,DDJ,ADD #16,R2
	MOV #64.,R1
	SUB DV0,R1		; R1=V,	64..1
	BR S4
S3:	MOV #162702,DDJI	; MOV #-16.,DDJ,SUB #16,R2
	MOV DV0,R1
	INC R1			; R1=V,	1..64
	NEG R3			; -B1
S4:	; R0=U,	R1=V, R2=A1, R3=B1
	MOV R0,R4
	SUB #64.,R4
	MOV R1,R5
	SUB #64.,R5
	; R4=DX, R5=DY
	MOV R2,-(SP)
	MOV R3,-(SP)
	MOV R5,-(SP)
	ASR R2
	ASR R2
	ASR R2
	ASR R2
	ASR R2
	ASR R2
	; R2*R1
	CLR R5
	BR 11$
13$:	BCC 12$
	ADD R1,R5
12$:	ASL R1
11$:	ROR R2
	BNE 13$
	BCC 14$
	ADD R1,R5
14$:	MOV R5,R1
	ASR R3
	ASR R3
	ASR R3
	ASR R3
	ASR R3
	ASR R3
	; R3*R0
	CLR R5
	BR 21$
23$:	BCC 22$
	ADD R0,R5
22$:	ASL R0
21$:	ROR R3
	BNE 23$
	BCC 24$
	ADD R0,R5
24$:	MOV R5,R0
	MOV (SP)+,R5
	MOV (SP)+,R3
	; R0=U=(B1>>6)*U, R1=V=(A1>>6)*V, (SP)=A1
	MOV DIJ0,R2
	; WHILE	LOOP
WHLEL:	BISB (R2),(R2)
	BNE HITW
	MOVB FRCNTR,256.(R2)
	CMP R0,R1
	BLO WL1
	ADD #64.,R5
	SUB R1,R0
	MOV (SP),R1
DDJI:	ADD #16.,R2
	SEC
	BR WHLEL
WL1:	ADD #64.,R4
	SUB R0,R1
	MOV R3,R0
DDII:	INC R2
	CLC
	BR WHLEL
HITW:	; PROCESS WALL HIT
	BCC WL2
	; HORZ_WALL
	MOVB (R2),R2	; TAKE MATERIAL
	; HERE WE DON'T	NEED A1,REPLACE	IT
	MOV R2,(SP)	; A1=MATERIAL
	MOV R5,-(SP)
	MOV R3,-(SP)
	CMP DDII,#5202
	BEQ WL4
	NEG R0		; -U
WL4:	SXT R1
	ADD R3,R0
	ADC R1		; U+U1
	SWAB R1
	CLRB R1
	SWAB R0
	BISB R0,R1
	CLRB R0		; 32_BIT*256
	MOV R3,R5
	MOV R1,R4
	MOV R0,R3
	CALL DIV32	; /B1 R3
	MOV R2,R3
	; D=B1/DY
	MOV (SP)+,R2
	MOV (SP)+,R4
	MOV R3,-(SP)
	CALL SPDIV
	BR WL3
WL2:	; VERT_WALL
	MOV (SP),R5	; WE DON'T NEED	DY HERE,R5=A1
	MOVB (R2),R2	; TAKE MATERIAL
	BISB #20,R2	; HOR.&VER.TYPE
	MOV R2,(SP)
	MOV R4,-(SP)
	MOV R5,-(SP)
	TST DDJI
	BPL WL5
	NEG R1		; -V
WL5:	SXT R0
	ADD R5,R1
	ADC R0		; V+V1
	SWAB R0
	CLRB R0
	SWAB R1
	BISB R1,R0
	CLRB R1		; 32_BIT*256
	MOV R0,R4
	MOV R1,R3
	CALL DIV32	; /A1 (SP)
	MOV R2,R3
	; D=A1/DX
	MOV (SP)+,R2
	MOV (SP)+,R4
	MOV R3,-(SP)
	CALL SPDIV
WL3:	; R2=SCALE
	ASR R2
	ASR R2
	MOV (SP)+,R1
	; R1=TEXTURE
	ASR R1
	ASR R1
	ASR R1
	BIC #177740,R1
	MOVB TXOFF(R1),R1
	SWAB R1
	ASL R1
	ASL R1
	BIS R1,R2	; COMBINE SCALE&TEXTURE
	MOV (SP)+,R0
	; R0=MATERIAL
	MOV (SP)+,R5
	MOV (SP)+,R4
	MOV (SP)+,R3
	RET
	;
	; TO MAKE POSSIBLE LINEAR APPROXIMATIONS
TXOFF:	.BYTE 0.,1.,2.,3.,4.,5.,6.,7.,8.,9.,10.
	.BYTE 11.,12.,13.,14.,15.
	.BYTE 15.,14.,13.,12.,11.
	.BYTE 10.,9.,8.,7.,6.,5.,4.,3.,2.,1.,0.
	.EVEN
	;
	; WALLS	RENDER
RENDR:	MOV #DU0,R5		; POINTER TO ALL RENDER	VARS
	MOV PLX,R0
	MOV R0,(R5)		; DU0
	BIC #177700,(R5)+
	MOV PLY,R1
	MOV R1,(R5)		; DV0
	BIC #177700,(R5)+
	BIC #77,R1
	ASR R0
	ASR R0
	ASR R0
	ASR R0
	ADD R1,R0
	ASR R0
	ASR R0
	ADD #MAP,R0
	MOV R0,(R5)+		; DIJ0
	MOV PLA,R0
	CALL GCOS
	MOV R1,-(SP)		; DA
	MOV R1,R2
	NEG R2
	MOV PLA,R0
	CALL GSIN
	SUB R1,(SP)		; DA=DA-R1
	MOV R1,-(SP)		; DB
	SUB R2,(SP)		; DB=DB-R2
	; I0,J0,U0,V0,DA,DB ARE	SET NOW
	; LET SREEN_WIDTH=32
	ASR R1
	ASR R1
	ASR R1
	MOV R1,(R5)+		; DDA
	ASR R1
	MOV R1,(R5)+		; DDA/2
	ASR R1
	MOV R1,(R5)+		; DDA/4
	ASR R2
	ASR R2
	ASR R2
	MOV R2,(R5)+		; DDB
	ASR R2
	MOV R2,(R5)+		; DDB/2
	ASR R2
	MOV R2,(R5)+		; DDB/4
	; DA,DB,A,B ARE	SET NOW
	; RENDER LOOP
	MOV (SP)+,R4		; DB
	MOV (SP)+,R3		; DA
	MOV #128.-8.,R5		; ALL BUFS LEN=+2
	; 1ST RAY
	CALL CORE
	MOV R2,FRBF1+8.(R5)	; PUT
	MOV R0,FRBF2+8.(R5)	; PUT
	; NEXT RAYS
RLP:	ADD DDA,R3
	ADD DDB,R4
	CALL CORE
	CMP R0,FRBF2+8.(R5)	; SAME OR NOT?
	BNE NSM
	; SAME - INTERPOLATE
	ADD #FRBF2,R5
	MOV R0,(R5)+		; FILL MATERIAL
	MOV R0,(R5)+
	MOV R0,(R5)+
	MOV R0,(R5)+
	SUB #130.,R5		; SWITCH TO FRBF1
	MOV (R5),R1		; TAKE PREV.SCALE
	MOV R1,R0		; INTERPOLATE
	ADD R2,R1
	ASR R1
	BIC #1000,R1
	ADD R1,R0
	ASR R0
	BIC #1000,R0
	MOV R0,-(R5)
	MOV R1,-(R5)
	ADD R2,R1
	ASR R1
	BIC #1000,R1
	MOV R1,-(R5)
	MOV R2,-(R5)
	SUB #FRBF1+8.,R5	; BACK TO INDEX
LJMP:	BGE RLP
	RET
NSM:	; NOT SAME - TRACE ADD.	RAY
	MOV R3,-(SP)
	MOV R4,-(SP)
	MOV R2,FRBF1(R5)	; PUT
	MOV R0,FRBF2(R5)	; PUT
	SUB DDA2,R3
	SUB DDB2,R4
	CALL CORE
	MOV R2,FRBF1+4(R5)	; PUT
	MOV R0,FRBF2+4(R5)	; PUT
	CMP R0,FRBF2+8.(R5)
	BNE NT1
	MOV R0,FRBF2+4+2(R5)	; PUT
	MOV FRBF1+8.(R5),R1
	ADD R2,R1
	ASR R1
	BIC #1000,R1
	MOV R1,FRBF1+4+2(R5)	; PUT
	BR NT2
NT1:	SUB DDA4,R3
	SUB DDB4,R4
	CALL CORE
	MOV R2,FRBF1+6(R5)	; PUT
	MOV R0,FRBF2+6(R5)	; PUT
	MOV FRBF1+4(R5),R2	; RESTORE
	MOV FRBF2+4(R5),R0	; RESTORE
NT2:	CMP R0,FRBF2(R5)
	BNE NT3
	MOV R0,FRBF2+2(R5)	; PUT
	MOV R2,R1
	ADD FRBF1(R5),R1
	ASR R1
	BIC #1000,R1
	MOV R1,FRBF1+2(R5)	; PUT
	BR NT4
NT3:	MOV (SP),R4
	MOV 2(SP),R3
	SUB DDA4,R3
	SUB DDB4,R4
	CALL CORE
	MOV R2,FRBF1+2(R5)	; PUT
	MOV R0,FRBF2+2(R5)	; PUT
NT4:	MOV (SP)+,R4
	MOV (SP)+,R3
	SUB #8.,R5
	JMP LJMP
	;
	; RENDER VARS (DO NOT CHANGE ORDER!)
DU0:	.WORD 0
DV0:	.WORD 0
DIJ0:	.WORD 0
DDA:	.WORD 0
DDA2:	.WORD 0			; DDA/2
DDA4:	.WORD 0			; DDA/4
DDB:	.WORD 0
DDB2:	.WORD 0			; DDB/2
DDB4:	.WORD 0			; DDB/4
DDX:	.WORD 0
DDY:	.WORD 0
	;
	.END
 
