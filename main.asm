; 小方塊
; 主要連串方式：
; main -> rule（介紹遊戲規則的畫面， line78~line94）
;      -> selectDefc（選擇遊戲難度
;      -> game（主要遊戲）
;			-> 由 gamecontinue 判斷遊戲是否要持續進行
;			-> 使用 appearTreeA、appearTreeB 來判斷畫面上有何種樹生成
;			-> 使用 readkey 來接收鍵盤按鍵，並判斷是否是空格
;			-> 若是空格的話那小方塊先往上一次，並進入 loopprint 繼續其他動作
;			-> loopprint 主要是重複印出地板以做出動畫效果，另有其他功能在下面的註解
;			-> 將 eax 設成 0 是為了重製，接著判斷遊戲是否要結束（小方塊有沒有撞到
;			-> 呼叫分數設定，並再一次判斷是不是需要回去
;      -> endgame（遊戲結束後的畫面，以及是否繼續遊戲的按鍵監聽（部分在 main 內）
;			-> 先將除了分數以外的其他設定全部重製
;			-> 將分數印出來後再將分數重製為 0
;			-> 印出結束的畫面，並詢問是否需要再次遊戲

INCLUDE Irvine32.inc
INCLUDE Macros.inc

Tree1 STRUCT
	line1 BYTE "   /\  ", 0
	line2 BYTE "  /  \  ", 0
	line3 BYTE " /    \  ", 0
	line4 BYTE "/______\  ", 0
	line5 BYTE "___||___", 0
	linex BYTE 75
Tree1 ENDS
Tree2 STRUCT
	line1 BYTE "  /\ ", 0
	line2 BYTE " /__\ ", 0
	line3 BYTE "__||__", 0
	linex BYTE 83
Tree2 ENDS

.data
beginbackground1 BYTE "******************************************************************************************",0DH,0AH,0
beginbackground2 BYTE "*                                                                                        *",0DH,0AH,0
underground1 BYTE "* ______________________________________________________________________________________ *",0DH,0AH,0
underground2_1 BYTE "*      ---     ---     ---     ----     ---     --     ----     ---     --     ---    -- *",0DH,0AH,0
underground2_2 BYTE "*    ---     ---     ---     ----     ---     --     ----     ---     --     ---    --   *",0DH,0AH,0
underground2_3 BYTE "*  ---     ---     ---     ----     ---     --     ----     ---     --     ---    --   - *",0DH,0AH,0
underground2_4 BYTE "* --     ---     ---     ----     ---     --     ----     ---     --     ---    --    -- *",0DH,0AH,0
underground2_5 BYTE "* -     ---     ---     ----     ---     --     ----     ---     --     ---    --    --- *",0DH,0AH,0
beginmessenge1 BYTE "Press ",34,"space",34," To Control the little diamond, enjoy!",0
gamecontinue BYTE 1
treeA Tree1 <>
treeB Tree2 <>
appearTreeA BYTE 0    ; TreeA appear if set
appearTreeB BYTE 0    ; TreeB appear if set
diamondX BYTE 22    ; diamond x cood
diamondY BYTE 14    ; diamond y cood
diamondD BYTE 0    ;diamond come down if set
diamondU BYTE 1    ;diamond come up if set
ifmovdiamond BYTE 0
diamond BYTE "<>", 0
tmp BYTE ?    ; just temp
score DWORD 0    ; your score
movcount BYTE 0
delayTime DWORD ?
distanceCheck BYTE 0

.code
main PROC
	g:
	call rule
	call Clrscr
	call selectDefc
	call Clrscr
	call game 
	call endgame
	.WHILE 1
		.IF al=="Y" || al=="y"
			call Clrscr
			jmp g
		.ELSE
			.IF al=="N" || al=="n"
				mGotoXY 27, 9
				mwrite " <  OK, byebye, have a nice day~  >"
				mGotoXY 0, 17
				mov eax, 2000
				call delay
				exit
				.ELSE
					call readkey    
					; 強制他們要輸入 y 或是 n 來結束
					;也算是避免遊戲中途按太多鍵到 buffer 導致遊戲錯誤未依照使用者意願停下
			.ENDIF
		.ENDIF
	.ENDW
	exit
main ENDP

rule PROC
	call printBackground
	call printTreeA
	call printTreeB
	mGotoXY 35, 3
	mwrite ">--------------------------<"
	mGotoXY 35, 4
	mwrite ">    The Little diamond    <"
	mGotoXY 35, 5
	mwrite ">--------------------------<"
	mGotoXY 22, 10
	mwrite "Press 'space' To Control the little diamond, enjoy!"
	mGotoXY 32, 12
	call WaitMsg
	mGotoXY 0, 17
	ret
rule ENDP

selectDefc PROC
    call printBackground
    call printTreeA
    call printTreeB
    mGotoXY 20, 3
    mwrite ">---------------------------------------------------<"
    mGotoXY 20, 4
    mwrite "> Choose from three different levels of difficulty: <"
    mGotoXY 20, 6
    mwrite ">               Simple mode: press 'S'              <"
    mGotoXY 20, 7
    mwrite ">               Normal mode: press 'N'              <"
    mGotoXY 20, 8
    mwrite ">                Hard mode: press 'H'               <"
    mGotoXY 20, 9
    mwrite ">---------------------------------------------------<"
    C1:
        call readchar
        mov ecx, eax
        .IF al=="S" || al=="s"
            mov eax, 100
            mov delayTime, eax
            mov eax, ecx
        .ELSEIF al=="N" || al=="n"
            mov eax, 50
            mov delayTime, eax
            mov eax, ecx
        .ELSEIF al=="H" || al=="h"
            mov eax, 20
            mov delayTime, eax
            mov eax, ecx
        .ELSE
            jmp C1
        .ENDIF

    mGotoXY 20, 5
    mwrite ">                                                   <"
    mGotoXY 20, 6
    mwrite ">          Your choice is:                          <"
    mGotoXY 50, 6

    .IF al=="N" || al=="n"
        mwrite "Normal mode"
    .ELSEIF al=="S" || al=="s"
        mwrite "Simple mode"
    .ELSEIF al=="H" || al=="h"
        mwrite "Hard mode"
    .ENDIF
        

    mGotoXY 20, 7
    mwrite ">                                                   <"
    mGotoXY 20, 8
    mwrite ">---------------------------------------------------<"
    mGotoXY 20, 9
	mwrite "                                                     "
	mGotoXY 20, 9
    call WaitMsg
    ret
selectDefc ENDP


game PROC
	call printBackground
	mGotoXY 73 , 1
	mwrite "score:"
	mGotoXY diamondX, diamondY    ; print diamond
	mov edx, OFFSET diamond    ; print diamond
	call WriteString    ; print diamond
	.WHILE gamecontinue    ; begin game
		.IF (appearTreeA==0 || appearTreeB==0) && distanceCheck > 4   ; if there have no tree in screen
			mov eax, 6
			call randomRange    ; print tree in randomRange
			.IF eax==1
				mov appearTreeA, 1
			.ENDIF
			.IF eax==3 || eax==4 || eax==5
				mov appearTreeB, 1
			.ENDIF
			mov distanceCheck, 0
		.ENDIF
		call readkey    ; read keyboard input if available
		.IF al==20h    ; if equal to space
			mov al, 1
			mov ifmovdiamond, al
			call movdiamond    ; move the diamond
		.ENDIF
		call loopprint    ; continue print underground
		mov eax, 0
		.IF gamecontinue==0    ; game over
			ret
		.ENDIF
		call scoreCount
		push eax
		push edx
		push ebx
		mov ebx, 50
		mov edx, 0
		mov eax, score
		div ebx
		cmp edx, 0
		jnz Ladd
		.IF delayTime>10
			dec delayTime
		.ENDIF
	Ladd: 
		pop ebx
		pop edx
		pop eax
		call ifTouch
		.IF gamecontinue==0
			ret
		.ENDIF
		inc distanceCheck
	.ENDW
	ret
game ENDP

endgame PROC
	call clearRet
	mGotoXY 35, 3
	mwrite ">-------------------<"
	mGotoXY 35, 4
	mwrite ">     GAME OVER     <"
	mGotoXY 35, 5
	mwrite ">   Your score:     <"
	mGotoXY 51, 5
	mov eax, score
	dec eax
	call WriteDec
	mov eax, 0
	mov score, eax
	mGotoXY 35, 6
	mwrite ">-------------------<"
	mGotoXY 27, 8
	mwrite " <-------------------------------->"
	mGotoXY 27, 9
	mwrite " < Do You Want To Try Again?(Y/N) >"
	mGotoXY 27, 10
	mwrite " <-------------------------------->"
	call readchar
	ret
endgame ENDP

clearRet PROC    ; reset
	mov al, 0
	mov appearTreeA, al
	mov appearTreeB, al
	mov diamondD, al
	mov ifmovdiamond, al
	mov movcount, al
	mov al, 1
	mov gamecontinue, al
	mov diamondU, al
	mov al, 22
	mov diamondX, al
	mov al, 14
	mov diamondY, al
	mov al, 75
	mov treeA.linex, al
	mov al, 83
	mov treeB.linex, al
	ret
clearRet ENDP

ifTouch PROC    ; 判斷是否有跟出現的樹撞在一起
	.IF appearTreeA    ; 如果是 treeA 出現的話
		mov al, treeA.linex
		mov tmp, al
		add tmp, 8
		mov al, diamondX
		.IF al>=treeA.linex && al<=tmp
			.IF diamondY>10
				mov gamecontinue, 0
				ret
			.ENDIF
		.ENDIF
	.ENDIF
	.IF appearTreeB    ; 如果是 treeB 出現的話
		mov al, treeB.linex 
		mov tmp, al
		add tmp, 4
		mov al, diamondX
		.IF al>treeB.linex && al<tmp
			.IF diamondY>12
				mov gamecontinue, 0
				ret
			.ENDIF
		.ENDIF
	.ENDIF
	ret
ifTouch ENDP

movdiamond PROC    ; 小恐龍的移動
	.IF movcount==20
		mov al, 0
		mov ifmovdiamond, al
		mov movcount, al
		ret
	.ENDIF
	.IF diamondU
		mGotoXY diamondX, diamondY
		mWrite "  "    ; 將原本的蓋掉
		dec diamondY
		mGotoXY diamondX, diamondY
		mov edx, OFFSET diamond
		call WriteString
		inc movcount
	.ENDIF
	.IF diamondY==5    ; 在最高點就改往下了
		mov diamondD, 1
		mov diamondU, 0
	.ENDIF
	.IF diamondD
		mGotoXY diamondX, diamondY
		mWrite "  "
		inc diamondY
		mGotoXY diamondX, diamondY
		mov edx, OFFSET diamond
		call WriteString
		inc movcount
	.ENDIF
	.IF diamondY==15
		mov diamondD, 0
		mov diamondU, 1
	.ENDIF
	ret
movdiamond ENDP

printTreeA PROC    ; 將 treeA 印出
	mGotoXY treea.linex, 10
	mov edx, OFFSET treeA.line1
	call WriteString
	mGotoXY treea.linex, 11
	mov edx, OFFSET treeA.line2
	call WriteString
	mGotoXY treea.linex, 12
	mov edx, OFFSET treeA.line3
	call WriteString
	mGotoXY treea.linex, 13
	mov edx, OFFSET treeA.line4
	call WriteString
	mGotoXY treea.linex, 14
	mov edx, OFFSET treeA.line5
	call WriteString
	ret
printTreeA ENDP

clearTree PROC    ; 當樹移動到畫面最左邊後，清除樹的動作
	mGotoXY 1, 10
	mWrite "        "
	mGotoXY 1, 11
	mWrite "        "
	mGotoXY 1, 12
	mWrite "        "
	mGotoXY 1, 13
	mWrite "        "
	mGotoXY 1, 14
	mWrite "________"
	ret
clearTree ENDP

printTreeB PROC    ; 將 treeA 印出
	mGotoXY treeB.linex, 12
	mov edx, OFFSET treeB.line1
	call WriteString
	mGotoXY treeB.linex, 13
	mov edx, OFFSET treeB.line2
	call WriteString
	mGotoXY treeB.linex, 14
	mov edx, OFFSET treeB.line3
	call WriteString
	ret
printTreeB ENDP

printBackground PROC    ; 印出背景的框框
	mov ecx, 13
	mov edx, offset beginbackground1
	call writestring
	mov edx, offset beginbackground2
	L1:
		call writestring
		Loop L1
	mov edx, offset underground1
	call writestring
	mov edx, offset underground2_5
	call writestring
	mov edx,offset beginbackground1
	call writestring
	ret
printBackground ENDP

loopprint PROC
; 地板移動效果
; 順便將 樹移動效果 以及 小恐龍移動判斷 寫在這裡
; 隨著地板移動一次，樹以及小恐龍（若是有要移動的話）也移動一次
; 最後還有加上是否有碰撞到一起的判斷
; 因懶所以重複的程式碼沒有使用 marco 而是選擇複製黏貼
; 總體來講相似的程式碼在做的事情是一樣的

	mGotoXY 0, 15    ; 此類為地板移動效果
	mov eax, delayTime
	mov edx, offset underground2_1
	call writestring
	mGotoXY 0, 17
	call delay

	.IF appearTreeA    ;此類為樹移動效果
		cmp treeA.linex, 1
		jb L2
		call printTreeA
		dec treeA.linex
		jmp L3
		L2:
			mov treeA.linex, 76
			call clearTree
			mov appearTreeA, 0
		L3:
	.ENDIF
	.IF appearTreeB
		cmp treeB.linex, 1
		jb L12
		call printTreeB
		dec treeB.linex
		jmp L13
		L12:
			mov treeB.linex, 76
			call clearTree
			mov appearTreeB, 0
		L13:
	.ENDIF
	.IF ifmovdiamond    ;此類為小恐龍移動效果
		call movdiamond
	.ENDIF
	call ifTouch    ; 每移動一次，都要判斷一次是否有碰撞到
	.IF gamecontinue==0
		ret
	.ENDIF

	mGotoXY 0, 15
	mov eax, delayTime
	mov edx, offset underground2_2
	call writestring
	mGotoXY 0, 17
	call delay

	.IF appearTreeA
		cmp treeA.linex, 1
		jb L4
		call printTreeA
		dec treeA.linex
		jmp L5
		L4:
			mov treeA.linex, 76
			call clearTree
			mov appearTreeA, 0
		L5:
	.ENDIF
	.IF appearTreeB
		cmp treeB.linex, 1
		jb L14
		call printTreeB
		dec treeB.linex
		jmp L15
		L14:
			mov treeB.linex, 76
			call clearTree
			mov appearTreeB, 0
		L15:
	.ENDIF
	.IF ifmovdiamond
		call movdiamond
	.ENDIF
	call ifTouch
	.IF gamecontinue==0
		ret
	.ENDIF

	mGotoXY 0, 15
	mov eax, delayTime
	mov edx, offset underground2_3
	call writestring
	mGotoXY 0, 17
	call delay

	.IF appearTreeA
		cmp treeA.linex, 1
		jb L6
		call printTreeA
		dec treeA.linex
		jmp L7
		L6:
			mov treeA.linex, 76
			call clearTree
			mov appearTreeA, 0
		L7:
	.ENDIF
	.IF appearTreeB
		cmp treeB.linex, 1
		jb L16
		call printTreeB
		dec treeB.linex
		jmp L17
		L16:
			mov treeB.linex, 76
			call clearTree
			mov appearTreeB, 0
		L17:
	.ENDIF
	.IF ifmovdiamond
		call movdiamond
	.ENDIF
	call ifTouch
	.IF gamecontinue==0
		ret
	.ENDIF

	mGotoXY 0, 15
	mov eax, delayTime
	mov edx, offset underground2_4
	call writestring
	mGotoXY 0, 17
	call delay

	.IF appearTreeA
		cmp treeA.linex, 1
		jb L8
		call printTreeA
		dec treeA.linex
		jmp L9
		L8:
			mov treeA.linex, 76
			call clearTree
			mov appearTreeA, 0
		L9:
	.ENDIF
	.IF appearTreeB
		cmp treeB.linex, 1
		jb L18
		call printTreeB
		dec treeB.linex
		jmp L19
		L18:
			mov treeB.linex, 76
			call clearTree
			mov appearTreeB, 0
		L19:
	.ENDIF
	.IF ifmovdiamond
		call movdiamond
	.ENDIF
	call ifTouch
	.IF gamecontinue==0
		ret
	.ENDIF

	mGotoXY 0, 15
	mov eax, delayTime
	mov edx, offset underground2_5
	call writestring
	mGotoXY 0, 17
	call delay

	.IF appearTreeA
		cmp treeA.linex, 1
		jb L10
		call printTreeA
		dec treeA.linex
		jmp L11
		L10:
			mov treeA.linex, 76
			call clearTree
			mov appearTreeA, 0
		L11:
	.ENDIF
	.IF appearTreeB
		cmp treeB.linex, 1
		jb L20
		call printTreeB
		dec treeB.linex
		jmp L21
		L20:
			mov treeB.linex, 76
			call clearTree
			mov appearTreeB, 0
		L21:
	.ENDIF
	.IF ifmovdiamond
		call movdiamond
	.ENDIF
	call ifTouch
	.IF gamecontinue==0
		ret
	.ENDIF

	ret
loopprint ENDP

scoreCount PROC    ; 做計分的動作
	mGotoXY 80 , 1
	mov eax, score
	call WriteDec
	inc score
	ret
scoreCount ENDP

END main