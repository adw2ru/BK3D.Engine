	;
	; DRAW FRAME
DRDIFF:	MOV #128.-2.,R5
FF:	CALL @SNDPR
	MOV FRBF1(R5),R2
	MOVB R2,R0		; TEXTURE COORD.
	CLRB R2
	SWAB R2
	MOV R2,R4
	MOV FRBF2(R5),R3	; MATERIAL
	MOV R3,R1
	SWAB R1
	MOVB R1,R1		; PREV.HEIGHT
	BIC #177741,R3
	ASL R0
	ASL R0
	ASL R0
	BIC #177417,R0
	ADD MTRLHV(R3),R0	; TEXTURE OFFSET
	CMP R2,#32.		; CLIP HEIGHT
	BHI FC

	SUB R2,R1

	MOVB R2,FRBF2+1(R5)
	MOV R0,TXTS+2		; SET TXT.OFFS.

	MOV R1,-(SP)

	MOV R5,R4
	ASR R4
	ADD #VSCR+20000,R4
	MOV #128.,R3
	MOV R2,R0
	ASL R0
	MOV WRC-2(R0),R0
DWLS:	SUB R3,R4		; 1
	MOVB (R0)+,R1		; 2
TXTS:	MOVB 0(R1),(R4)		; 3
	SOB R2,DWLS		; 4

	MOV #42021,R2
	BIT #128.,R4
	BEQ FA

	SWAB R2

FA:	MOV (SP)+,R1
FB:	BLE FE
	SUB R3,R4
	MOVB R2,(R4)
	SWAB R2
	DEC R1
	BR FB

FC:	MOV #32.,R2		; CLIP HEIGHT
	MOVB R2,FRBF2+1(R5)
	ASR R2
	MOV R0,TXTB+2		; SET TXT.OFFS.
	MOVB DIVS-33.(R4),R4
	ASL R4
	MOV R5,-(SP)
	ASR R5
	ADD #VSCR+20000,R5
	MOV #256.,R3
	CLR R0
DWLB:	SUB R3,R5		; 1
	MOV R0,R1		; 2
	ADD R4,R0		; 3
	SWAB R1			; 4
	MOVB R1,R1		; 5
TXTB:	MOVB 0(R1),R1		; 6
	MOVB R1,(R5)		; 7
	MOVB R1,128.(R5)	; 8
	SOB R2,DWLB		; 9
	MOV (SP)+,R5
	;
FE:	SUB #2,R5
	BGE FF
	;
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
	; R1=RAW HEIGHT,TEXT.COORD.
CORE:	CALL @SNDPR
	;
	MOV R3,-(SP)		; DA
	MOV R4,-(SP)		; DB
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
	MOVB (R2),R2		; TAKE MATERIAL
	; HERE WE DON'T	NEED A1,REPLACE	IT
	MOV R2,(SP)		; A1=MATERIAL
	; D=B1/DY
	MOV R3,R2
	MOV R5,R4
	CALL SPDIV
	MOV R2,-(SP)		; SAVE D
	; T=PLX+A/D
	MOV R2,R4
	MOV 10(SP),R2		; A
	BPL 1$
	NEG R2
	CALL SPDIV
	NEG R2
	BR 2$
1$:	CALL SPDIV
2$:	ADD PLX,R2		; R2=TEXT.COORD.
	BR WL3
WL2:	; VERT_WALL
	MOV (SP),R5		; WE DON'T NEED	DY HERE,R5=A1
	MOVB (R2),R2		; TAKE MATERIAL
	BISB #20,R2		; HOR.&VER.TYPE
	MOV R2,(SP)		; MATERIAL
	; D=A1/DX
	MOV R5,R2
	CALL SPDIV
	MOV R2,-(SP)		; SAVE D
	; T=PLY+B/D
	MOV R2,R4
	MOV 6(SP),R2		; B
	BPL 1$
	NEG R2
	CALL SPDIV
	NEG R2
	BR 2$
1$:	CALL SPDIV
2$:	ADD PLY,R2		; R2=TEXT.COORD.
WL3:	MOV (SP)+,R1		; R1=SCALE
	ASR R1
	ASR R1
	ASR R1
	SWAB R1
	CLRB R1
	BISB R2,R1		; R1=SCALE,TEXT.COORD.
	MOV (SP)+,R0		; R0=MATERIAL
	MOV (SP)+,R5
	MOV (SP)+,R4		; DB
	MOV (SP)+,R3		; DA
	RET
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
	MOV R1,(R5)+		; DDA0
	ASR R1
	MOV R1,(R5)+		; DDA1
	ASR R1
	MOV R1,(R5)+		; DDA2
	ASR R1
	MOV R1,(R5)+		; DDA4
	ASR R2
	ASR R2
	MOV R2,(R5)+		; DDA0
	ASR R2
	MOV R2,(R5)+		; DDB1
	ASR R2
	MOV R2,(R5)+		; DDB2
	ASR R2
	MOV R2,(R5)+		; DDB4
	; DA,DB,A,B ARE	SET NOW
	; RENDER LOOP
	MOV (SP),R4		; DB
	MOV 2(SP),R3		; DA
	;
	; STAGE	1: DRAFT
	MOV #128.-16.,R5
	CALL CORE
	MOVB R0,FRBF2+16.(R5)	; PUT
	MOV R1,FRBF1+16.(R5)	; PUT
LP0:	ADD DDA0,R3
	ADD DDB0,R4
	CALL CORE
	MOVB R0,FRBF2(R5)	; PUT
	MOV R1,FRBF1(R5)	; PUT
	CMPB R0,FRBF2+16.(R5)
	BNE NS0
	MOVB R0,FRBF2+8.(R5)	; PUT
	ADD FRBF1+16.(R5),R1
	ROR R1
	MOV R1,FRBF1+8.(R5)	; PUT
	SUB #16.,R5
	BGE LP0
	BR EX0
NS0:	SUB DDA1,R3
	SUB DDB1,R4
	CALL CORE
	MOVB R0,FRBF2+8.(R5)	; PUT
	MOV R1,FRBF1+8.(R5)	; PUT
	ADD DDA1,R3
	ADD DDB1,R4
	SUB #16.,R5
	BGE LP0
EX0:	; STAGE	2: FINAL
	MOV (SP)+,R4		; DB
	MOV (SP)+,R3		; DA
	MOV #128.-8.,R5
	; NEXT RAYS
RLP:	ADD DDA1,R3
	ADD DDB1,R4
	MOVB FRBF2(R5),R0
	MOV FRBF1(R5),R1
	CMPB R0,FRBF2+8.(R5)	; SAME OR NOT?
	BNE NSM
	; SAME - INTERPOLATE
	ADD #FRBF2,R5
	MOVB R0,(R5)		; FILL MATERIAL
	MOVB R0,2(R5)
	MOVB R0,4(R5)
	MOVB R0,6(R5)
	;ADD #8.,R5
	MOV R1,R2
	SUB #130.-8.,R5		; SWITCH TO FRBF1
	MOV (R5),R1
	MOV R1,R0
	ADD R2,R1
	ROR R1
	ADD R1,R0
	ROR R0
	MOV R0,-(R5)
	MOV R1,-(R5)
	ADD R2,R1
	ROR R1
	MOV R1,-(R5)
	MOV R2,-(R5)
	SUB #FRBF1+8.,R5	; BACK TO INDEX
	BGE RLP
	RET
NSM:	; NOT SAME - TRACE ADD.	RAY
	MOV R3,-(SP)
	MOV R4,-(SP)
	SUB DDA2,R3
	SUB DDB2,R4
	CALL CORE
	MOVB R0,FRBF2+4(R5)	; PUT
	MOV R1,FRBF1+4(R5)	; PUT
	CMPB R0,FRBF2+8.(R5)
	BNE NT1
	MOVB R0,FRBF2+4+2(R5)	; PUT
	MOV FRBF1+8.(R5),R2
	ADD R1,R2
	ROR R2
	MOV R2,FRBF1+4+2(R5)	; PUT
	BR NT2
NT1:	SUB DDA4,R3
	SUB DDB4,R4
	CALL CORE
	MOVB R0,FRBF2+6(R5)	; PUT
	MOV R1,FRBF1+6(R5)	; PUT
	MOVB FRBF2+4(R5),R0	; RESTORE
	MOV FRBF1+4(R5),R1	; RESTORE
NT2:	CMPB R0,FRBF2(R5)
	BNE NT3
	MOVB R0,FRBF2+2(R5)	; PUT
	MOV R1,R2
	ADD FRBF1(R5),R2
	ROR R2
	MOV R2,FRBF1+2(R5)	; PUT
	BR NT4
NT3:	MOV (SP),R4
	MOV 2(SP),R3
	SUB DDA4,R3
	SUB DDB4,R4
	CALL CORE
	MOVB R0,FRBF2+2(R5)	; PUT
	MOV R1,FRBF1+2(R5)	; PUT
NT4:	MOV (SP)+,R4
	MOV (SP)+,R3
	SUB #8.,R5
	BGE RLP
	RET
	;
	; RENDER VARS (DO NOT CHANGE ORDER!)
DU0:	.WORD 0
DV0:	.WORD 0
DIJ0:	.WORD 0
DDA0:	.WORD 0
DDA1:	.WORD 0
DDA2:	.WORD 0
DDA4:	.WORD 0
DDB0:	.WORD 0
DDB1:	.WORD 0
DDB2:	.WORD 0
DDB4:	.WORD 0
DDX:	.WORD 0
DDY:	.WORD 0
	;
	.END
 
