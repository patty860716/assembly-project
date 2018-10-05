TITLE quiz two
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Assembly Programming
;
; Student Name: ´^¯\´@
; Student ID:0416043
; Student Email Address: peitingpeng860716@gmail.com
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
include Irvine32.inc
include Macros.inc
foo proto,a:sdword,b:sdword
.data
myname BYTE "PeiTing Peng",0
id BYTE "0416043",0
email BYTE "peitingpeng860716@gmail.com",0
opt_w BYTE 119
opt_s BYTE 115
opt_a BYTE 97
opt_d BYTE 100
opt_space BYTE 32
opt_q BYTE 113
RobotX_Old byte 0
RobotY_Old byte 0
quitgame byte 0
ifdelay byte 0
robotX byte 0
robotY byte 10
wid DWORD 61
height DWORD 20
framecolor BYTE 0
sound dword 7
i byte 0
bitflag byte 0
bluex byte 2
bluey byte 2
bluex_old byte ?
bluey_old byte ?
whiteflag byte 0
move_flag byte 0
flag_q byte 0
mymap			BYTE		1, 1, 1, 1, 1			
				BYTE		1, 0, 0, 0, 1			
				BYTE		1, 0, 0, 0, 1
				BYTE		1, 0, 0, 0, 1			
				BYTE		1, 1, 1, 1, 1 

b_flag byte 0
dir byte 0
.code
main PROC
L:
	call printmenu
	call handlekey
	jmp L
	call readint
	exit
main ENDP
printmenu proc
	mov eax,white+black*16
	call settextcolor
	call clrscr
	mov dl,0
	mov dh,0
	call gotoxy
	mov eax,yellow+yellow*16
	mov framecolor,al
	call frame
	mov dl,1
	mov dh,2
	call gotoxy
	mov eax,white+black*16
	call settextcolor
	mwrite"Menu"
	inc dh
	call gotoxy
	mwrite"1)Recursive function"
	inc dh
	call gotoxy
	mwrite"2)Animation"
	inc dh
	call gotoxy
	mwrite"3)show credit"
	inc dh
	call gotoxy
	mwrite"4)Quit"
	inc dh
	call gotoxy
	ret
printmenu endp
printyellow proc
	cmp whiteflag,0
	jne L
	mov eax,white+yellow*16
	jmp L1
		L:
		mov eax,white+white*16
		L1:
			call settextcolor
			mov al,' '
			call writechar
			ret
printyellow endp
printblack proc
	mov eax,white+gray*16
			call settextcolor
			mov al,' '
			call writechar
			ret
printblack endp
handlekey PROC
L0:
call Readkey
jz L0
cmp al, '1'
je L1
cmp al, '2'
je L2
cmp al, '3'
je L3
cmp al, '4'
je L4
;call Clrscr
jmp L0
;ret
L1:
call option1
ret
L2:
call option2
ret
L3:
call printinfo
ret
L4:
call quitevent
ret
handlekey ENDP
quitevent proc
	mov eax,blue+blue*16
	call settextcolor
	mov dh,0
	mov dl,0
	mov ecx,62
	L:
	push ecx
	mov ecx,21
	LL:
	call gotoxy
	mwrite " "
	inc dh
	loop LL
	mov dh,0
	inc dl
	pop ecx
	mov eax,50
	call delay
	loop L
	mov eax,black+black*16
	call settextcolor
	call clrscr
	call delay
	exit
	ret
quitevent endp
updateblue proc
	mov eax,5 
	movzx ebx,bluey
	sub bl,robotY
	imul ebx
	movzx ebx,bluex
	sub bl,robotX
	add eax,ebx
	mov edi,offset mymap
	add edi,eax
	cmp dir,2
	jne L1
	cmp byte ptr [edi+1],1
	je L_b
	jmp L_q1
	L1:
	cmp dir,3
	jne L2
	cmp byte ptr [edi-1],1
	je L_b
	jmp L_q1
	L2:
	cmp dir,1
	jne L3
	cmp byte ptr [edi-5],1
	je L_b
	jmp L_q1
	L3:
	cmp dir,0
	cmp byte ptr [edi+5],1
	je L_b
	jmp L_q1
	L_b:
	mov move_flag,1
	jmp L_q
	L_q1:
	mov move_flag,0 
	L_q:
	ret 
updateblue endp
option2 proc
	mov flag_q,0
	mov whiteflag,0
	mov move_flag,0
	mov eax,gray+gray*16
	call settextcolor
	call clrscr
	mov robotX,0
	mov robotY,0
	mov bluex,2
	mov bluey,2
	call showrobot
	L:
	cmp flag_q,1
	je L_r
	call SaveRobotPosition
	call handlekey2
	;call updateblue
	call clearrobot
	call showrobot
	jmp L
	L_r:
	ret
option2 endp
option1 proc
	call clrscr
	L_a:
	mwrite"Please input a inside [-20,20]:"
	call readint
	push eax
	cmp eax,20
	jle L_a1
	mwrite"out of bound"
	call crlf
	jmp L_a
	L_a1:
	cmp eax,0
	jge L_b1
	neg eax
	cmp eax,20
	jle L_b1
	mwrite"out of bound"
	call crlf
	jmp L_a
	L_b1:
	pop eax
	mov ebx,eax
	L_b:
	mwrite"Please input b inside [-20,20]:"
	call readint
	push eax
	cmp eax,20
	jle L_b2
	mwrite"out of bound"
	call crlf
	jmp L_b
	L_b2:
	cmp eax,0
	jge L_st
	neg eax
	cmp eax,20
	jle L_st
	mwrite"out of bound"
	call crlf
	jmp L_b
	L_st:
	pop eax
	mwrite "The result of foo(a,b) is as follows"
	call crlf
	invoke foo,ebx,eax
	call crlf
	mwrite "The value of foo(a,b) = "
	call writeint
	call crlf
	mwrite "Press ¡¥r¡¦ to repeat and ¡¥q¡¦ to return to the main menu."
	call crlf
	L_q:
	call readkey
	cmp al,'r'
	je L_a
	cmp al,'q'
	jne L_q
	ret
option1 endp
foo proc ,a:sdword ,b:sdword
	mov ebx,a
	cmp b,0
	je L_0
	cmp ebx,b
	jle L_0
	push ebx
	mov eax,ebx
	mov edx,0
	cmp eax,0
	jge L_kc
	neg eax
	L_kc:
	mov ebx,b
	cmp ebx,0
	jge L_k
	neg ebx
	L_k:
	idiv ebx
	mov edx,eax
	pop ebx
	test edx,00000001b
	jz L2
	inc b
	invoke foo,ebx,b
	mwrite"O"
	jmp L_r
	L_0:
	mov eax,0
	jmp L_r
	L2:
	mwrite"E"
	dec ebx
	invoke foo,ebx,b
	add eax,a
	add eax,b
	jmp L_r
	L_r:
ret
foo endp
printinfo proc
	mov eax,white+black*16
	call settextcolor
	call clrscr
	mwrite "This program is written by "
	call crlf
	mwrite "Name :"
	mov edx,offset myname
	call writestring
	call crlf
	mwrite "ID : "
	mov edx,offset id
	call writestring
	call crlf
	mwrite "Email Address :"
	mov edx,offset email
	call writestring
	call crlf
	mwrite "Thanks for playing. "
	call crlf
	mwrite "Press a key to go back to the main menu."
	L_q:
	call readkey
	jz L_q
	ret
printinfo endp

SaveRobotPosition PROC
	mov al, robotX
    mov RobotX_Old, al
    mov al, robotY
    mov RobotY_Old, al
	mov al, bluex
    mov bluex_old, al
    mov al, bluey
    mov bluex_old, al
    ret
SaveRobotPosition ENDP
frame PROC
	mov ecx, height
	call verticalline
	mov ecx, wid
	call Drawaline
	mov ecx, height
	call verticalline1
	mov ecx, wid
	call Drawaline1
	inc dl
	inc dh
	ret
frame ENDP
Drawaline PROC
	mov al, framecolor
	call SetTextcolor
	L0:
		call GotoXY
		mov al," "
		call WriteChar
		cmp ifdelay,1
		jne LL1
		call delay
		LL1:
		inc dl
	loop L0
	ret
Drawaline ENDP
Drawaline1 PROC
	;mov al, framecolor
	;call SetTextcolor
	L0:
		call GotoXY
		mov al," "
		call WriteChar
		cmp ifdelay,1
		jne LL1
		call delay
		LL1:
		dec dl
	loop L0
	ret
Drawaline1 ENDP
verticalline PROC
	mov eax, 0
	;mov ecx, height
	;call Crlf
	mov al, framecolor
	call SetTextcolor
	L4:
		call GotoXY
		mov al," "
		call WriteChar
		cmp ifdelay,1
		jne LL1
		call delay
		LL1:
		inc dh
	loop L4
	ret
verticalline ENDP
verticalline1 PROC
	;mov eax, blue+white*16
	mov al, framecolor
	call SetTextcolor
	L1:
		call GotoXY
		mov al," "
		call WriteChar
		cmp ifdelay,1
		jne LL1
		call delay
		LL1:
		dec dh
	loop L1
	ret
verticalline1 ENDP
showrobot proc
	mov dl,robotX
	mov dh,robotY
	call gotoXY
	call printmap
	mov dl,bluex
	mov dh,bluey
	call gotoxy
	mov eax,blue+blue*16
	call settextcolor
	mwrite " "
	ret
showrobot endp
printmap proc
	mov ecx,5
	mov esi,offset mymap
	LL:
	push ecx
	mov ecx,5
	L:call gotoxy
	lodsb
	cmp eax,1
	je L_y
	cmp eax,0
	je L_b
	L_y:
	call printyellow
	jmp LLL
	L_b:
	call printblack
	jmp LLL
	LLL:
	inc dl
	loop L
	inc dh
	mov dl,robotX
	pop ecx
	loop LL
	ret
printmap endp
clearrobot proc
	mov dl,RobotX_Old
	mov dh,RobotY_Old
	call gotoxy
	mov eax, white+gray*16
	call setTextcolor
	mov ecx,5
	L:
	mwrite "     "
	inc dh
	call gotoxy
	loop L
	mov dl,bluex_Old
	mov dh,bluey_Old
	call gotoxy
	mwrite " "
	ret
clearrobot endp

move_up proc
	cmp robotY,0
	je L_k
	dec robotY
	cmp move_flag,1
	jne L_k
	dec blueY
	L_k:
	ret
move_up endp
move_down proc

	cmp robotY,7
	je L_bottom
	inc robotY
	cmp move_flag,1
	jne L_bottom
	inc blueY
	L_bottom:
	ret
move_down endp
move_left proc

	cmp robotX,0
	je L_k
	dec robotX
	cmp move_flag,1
	jne L_k
	dec blueX
	L_k:
	ret
move_left endp
move_right proc
	cmp robotX,11
	je L_k
	inc robotX
	cmp move_flag,1
	jne L_k
	inc blueX
	L_k:
	ret
move_right endp
handlekey2 PROC
L0:
call Readkey
jz L0
cmp al, opt_w
je L1
cmp al, opt_s
je L2
cmp al, opt_a
je L3
cmp al, opt_d
je L4
cmp al, 27
je L6
cmp al, 'r'
je L7
jmp L0
L1:
mov dir,0
call updateblue
call move_up
ret
L2:
mov dir,1
call updateblue
call move_down
ret
L3:
mov dir,2
call updateblue
call move_left
ret
L4:
mov dir,3
call updateblue
call move_right
ret
L6:
	mov flag_q,1
	ret
L7:
	mov whiteflag,1
	ret
handlekey2 ENDP
END main