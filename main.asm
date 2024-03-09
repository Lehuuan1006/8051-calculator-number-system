khoi_dong:
org 00h
	;ro dung de gan data va lenh
mov A,#0ffh
mov P0,#000h
RS BIT P2.5
RW BIT P2.6
E BIT P2.7
DBUS EQU P0
new_digit bit P2.1
new_ans	bit P2.2
mov r0, #00h
mov r1, #00h
mov r2, #00h
mov r3, #00h
mov r4, #00h
mov r5, #00h
mov r6, #00h
mov r7, #00h
;==========================
/*KHOI DONG LCD ? */
MOV r0, #38H /*CHON HIEN THI 8 BIT 2 DONG*/
ACALL lcd_command
mov r0, #0fh /* KHOI TAO HIEN THI LCD */
acall lcd_command
mov r0, #80h /* DICH TRO SANG trai */
acall lcd_command
mov r0, #01h /* clear man hinh */
acall lcd_command
mov r5,#0ah ;mac dinh chon Dec
checkkeypad:
	mov P1,#0ffh
	mov P3, #0ffh
	clr P1.0
	jb  P3.3,next_1
	mov r0,#'7'
	acall savedigit
	acall disp_000
next_1: 
	jb P3.4,next_2
	mov r0,#'8'
	acall savedigit
	acall disp_000
next_2:
	jb P3.5,next_3
	mov r0,#'9'
	acall savedigit
	acall disp_000
next_3:
	jb P3.6, next_4
	mov r0,#'A'
	acall savedigit
	acall disp_000
next_4: setb P1.0
	clr P1.1
	jb  P3.3,next_5
	mov r0,#'4'
	acall savedigit
	acall disp_000
next_5: 
	jb P3.4,next_6
	mov r0,#'5'
	acall savedigit
	acall disp_000
next_6:
	jb P3.5,next_7
	mov r0,#'6'
	acall savedigit
	acall disp_000
next_7:
	jb P3.6, next_8
	mov r0,#'B'
	acall savedigit
	acall disp_000
next_8: setb P1.1
	clr P1.2
	jb  P3.3,next_9
	mov r0,#'1'
	acall savedigit
	acall disp_000
next_9: 
	jb P3.4,next_10
	mov r0,#'2'
	acall savedigit
	acall disp_000
next_10:
	jb P3.5,next_11
	mov r0,#'3'
	acall savedigit
	acall disp_000
next_11:
	jb P3.6, next_12
	mov r0,#'C'
	acall savedigit
	acall disp_000
next_12: setb P1.2
	clr P1.3
	jb  P3.3,next_13
	mov r5,#08h			;PHIM OTC
	jmp checkkeypad
next_13: 
	jb P3.4,next_14
	mov r5,#10h				;PHIM HEX
	jmp checkkeypad
next_14:
	jb P3.5,next_15
	mov r0,#'0'
	acall savedigit
	acall disp_000
next_15:
	jb P3.6, next_16
	mov r0,#'D'
	acall savedigit
	acall disp_000 
next_16:
	jb P3.7, next_17
	mov r0,#'='  				; dau =
	acall line2
	acall checkans
next_17:
	setb P1.3
	clr P1.4
	jb P3.3, next_18
	mov r5,#02h					;PHIM BIN
	jmp checkkeypad
next_18:
	jb P3.4, next_19
	mov r5,#0ah		; PHIM DEX
	jmp checkkeypad
next_19:
	jb P3.5, next_20
	mov r0,#'F'
	acall savedigit
	acall disp_000
next_20:
	jb P3.6, next_21
	mov r0,#'E'
	acall savedigit
	acall disp_000
next_21:
	jb P3.7, long_checkkeypad				;PHIM AC
	LJMP khoi_dong
long_checkkeypad: ljmp checkkeypad

checkans:
jb new_ans, trans
setb new_ans
ret

savedigit:
jb new_digit,checkdigit
mov a,r0
acall xuly
mov r1,a
setb new_digit
ret

checkdigit:
mov a,r0
mov b,r5
acall xuly
mov r7,a
mov a,r1
mul ab
add a,r7
mov r1,a
setb new_digit
ret
xuly:
CJNE A,#'0',KT1
	jmp so
	KT1:
	CJNE A,#'1',KT2
	jmp so
	KT2:
	CJNE A,#'2',KT3
	jmp so
	KT3:
	CJNE A,#'3',KT4
	jmp so
	KT4:
	CJNE A,#'4',KT5
	jmp so
	KT5:
	CJNE A,#'5',KT6
	jmp so
	KT6:
	CJNE A,#'6',KT7
	jmp so
	KT7:
	CJNE A,#'7',KT8
	jmp so
	KT8:
	CJNE A,#'8',KT9
	jmp so
	KT9:
	CJNE A,#'9',chu
	jmp so
	ret
so: subb a,#30h
ret
chu: subb a,#37h
ret
trans:
	MOV A,r1
	MOV B,r5
	MOV r3, #00h
	acall oncode
	ret
oncode:
	div ab
    xch a,b
	acall xuly_out
    mov r0, a
	push 0
    xch a,b
    mov b, r5
    inc r3
    cjne r3,#08h,oncode
	pop 0
	acall disp_ans
	pop 0
	acall disp_ans
	pop 0
	acall disp_ans
	pop 0
	acall disp_ans
	pop 0
	acall disp_ans
	pop 0
	acall disp_ans
	pop 0
	acall disp_ans
	pop 0
	acall disp_ans
	ret
xuly_out:
	CJNE A,#00h,KTo1
	jmp so_o
	KTo1:
	CJNE A,#01h,KTo2
	jmp so_o
	KTo2:
	CJNE A,#02h,KTo3
	jmp so_o
	KTo3:
	CJNE A,#03h,KTo4
	jmp so_o
	KTo4:
	CJNE A,#04h,KTo5
	jmp so_o
	KTo5:
	CJNE A,#05h,KTo6
	jmp so_o
	KTo6:
	CJNE A,#06h,KTo7
	jmp so_o
	KTo7:
	CJNE A,#07h,KTo8
	jmp so_o
	KTo8:
	CJNE A,#08h,KTo9
	jmp so_o
	KTo9:
	CJNE A,#09h,chu_o
	jmp so_o
	ret
so_o: add a,#30h
ret
chu_o: add a,#37h
ret
disp_ans:
	mov  p0,r0
	setb RS
	setb e
	clr e
	acall wait_lcd
	Ret
disp_000:
	Mov P0 ,r0
	setb RS
	setb e
	clr e
	acall wait_lcd
	sjmp finish
	Ret
line2:
mov r0,#0c0H
acall lcd_command
ret
lcd_command:
clr rs
mov dbus, r0 /* NHAN DU LIEU VA LENH */
setb e
clr e
acall wait_lcd /* CHO LCD LAM VIEC */
ret

WAIT_LCD:
mov r6, #10 
lap:mov r7, #250 
djnz r7,$ 
djnz r6, lap 
ret

Delay:
	mov r7,#0ffh
	delay1:
	mov r6,#0ffh
	djnz r6,$
	djnz r7,delay1
ret
finish:
	jnb P3.3,finish
	jnb P3.4,finish
	jnb P3.5,finish
	jnb P3.6,finish
	jnb P3.7,finish
	ljmp Checkkeypad
end
