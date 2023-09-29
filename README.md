# Assembly_Final_Project
大二組合語言期末小組專題

摘要：
  我們主要目的是製作出一個類似google斷線小恐龍的遊戲，名為­­——小方塊。包含初始畫面、遊戲畫面、結束畫面。遊戲內容是小方塊必須跳過在路上遇到的障礙物(樹)，其中樹有不同高度，一旦觸碰到障礙物即遊戲結束，較置結束頁面；而右上角會有計分板，獲得的分數會隨時間增加。
最後測試的結果是小方塊能成功跳過障礙物。

介紹 :
  歡迎來到小方塊遊戲!
  這是一款用組合語言寫出的、模仿Google斷線小恐龍的遊戲。
  首先，程式一執行，我們會先看到起始畫面。
  
  這個頁面包含了遊戲名字 – 小方塊以及遊玩方式 – 按空白鍵控制小方塊。
  按任意鍵繼續後，我們來到了選擇難度的地方。
  
  我們分成了三種難度，主要變化的是障礙物移動速度，由慢到快分別是簡單(Simple)、普通(Normal)及困難(Hard)。
  玩家可以分別按S、N、H選擇難度。選擇好之後，難度會在下個畫面中顯示。
  
  按任意鍵繼續後就會開始遊戲。
  
  玩家的目標就是盡可能的跳過路上的樹，撐越久分數越高，撞到樹則結束遊戲。
  不幸撞到樹的話會停下遊戲進入結束畫面。
  
  在結束畫面可以看到玩家本場的分數以及詢問是否要重完一遍的訊息。
  如果選擇要繼續(Y)，會跳至開始畫面(第一張)。
  如果選擇要結束(N)，遊戲會跟玩家道別後再結束程式。
  
  以上，就是本遊戲的介紹!




項目計劃或測試計劃和測試用例 :
  原先是分成三部分(方塊移動、障礙物移動、分數計算及背景)個別研究，不過因為當時剛好跟其他專題卡在一塊，大家都很忙，所以程式基本上是在約好一起討論的那天才開始動，不過主要還是分成這三個大分類做。
  1 . 分數計算及背景
  這是我們最先動工的地方，因為我們認為這部分是最簡單的。(實際上也是)
  這部分也包括了路看起來有在移動的動畫以及初始畫面，遊戲畫面跟結束畫面的區分及設計。
  2 . 障礙物移動(包含生成)
  首先，我們先把障礙物 – 樹的樣式畫了出來，把它包成了Structure(事後覺得好像沒那麼需要)，然後寫出了樹移動的程式，跟路的移動動畫放在一塊確保他們會一起移動。
  3 . 方塊移動(包含生成)
  在此之前其實我們都還沒想到主角，也就是玩家操控的物件到底要是什麼。會選用方塊只是單純發現"<>"這樣打很可愛。
  我們決定樣式之後，開始處理它的上下移動，接著則是處理跟障礙物的互動(有沒有撞到)。
  上下移動的部份我們決定讓使用者按空白鍵來移動所以做了判定，只有空白鍵才能使方塊跳躍。

  以上都處理好之後，我們開始優化遊戲及增加功能，包括讓障礙物隨機生成會太常造成死局所以增加間隔判定以及加了難度(速度)的變化。
  難度選擇分成S(Simple)、N(Normal)、H(Hard)。這裡簡單的做了防呆機制。如果輸入非以上三者不會繼續遊戲
  這裡我們也增加了結束是否要繼續遊玩的選擇(Y/N)，也簡單的做了防呆，非Y/N輸入就不會繼續動作。其實一開始設計是按Y繼續，按其它鍵退出，但因為在遊玩遊戲時很常有狂按空白鍵還是跳不過障礙物，結果在結束畫面來不及停止按導致程式直接退出所以做了只有N才會跳出遊戲。

討論或分析：
	主要連串方式：
		> main 
		> rule（介紹遊戲規則的畫面）
		> selectDefc（選擇遊戲難度）
		> game（主要遊戲）
  
	- 由 gamecontinue 判斷遊戲是否要持續進行
	- 使用 appearTreeA、appearTreeB 來判斷畫面上有何種樹生成
	- 使用 readkey 來接收鍵盤按鍵，並判斷是否是空格
	- 若是空格的話那小方塊先往上一次，並進入 loopprint 繼續其他動作
	- loopprint 主要是重複印出地板以做出動畫效果，另有其他功能在下面的註解
	- 將 eax 設成 0 是為了重製，接著判斷遊戲是否要結束（小方塊有沒有撞到
	- 呼叫分數設定，並再一次判斷是不是需要回去
	- endgame（遊戲結束後的畫面，以及是否繼續遊戲的按鍵監聽（部分在 main 內）
		- 先將除了分數以外的其他設定全部重製
		- 將分數印出來後再將分數重製為 0
	- 印出結束的畫面，並詢問是否需要再次遊戲
程式碼:
**main : 在此呼叫所有需要的程式 及 遊戲結束，是否繼續的判定也在這裡**

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

--------------------------------------------------------------
**rule : 最開始顯示的畫面，包含了遊戲名字、遊玩說明**

rule PROC
	call printBackground 	;印出邊框以及下方的道路
	call printTreeA		 	;印出大樹，這裡只是拿來裝飾
	call printTreeB		 	;印出小樹，這裡也只是拿來裝飾
	mGotoXY 35, 3			;定位游標
	mwrite ">--------------------------<" ;印出雙引號內的字串
	mGotoXY 35, 4			;以下同上
	mwrite ">    The Little diamond    <"
	mGotoXY 35, 5
	mwrite ">--------------------------<"
	mGotoXY 22, 10
	mwrite "Press 'space' To Control the little diamond, enjoy!"
	mGotoXY 32, 12
	call WaitMsg			;等待使用者輸入任意鍵繼續
	mGotoXY 0, 17
	ret
rule ENDP
  
--------------------------------------------------------------
**selectDefc : 選擇難度**

selectDefc PROC
    call printBackground
    call printTreeA
    call printTreeB				;這三行就跟rule的前三行做用一樣
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
 	;這裡是做輸入判定，只接受輸入S、N、H及其小寫，分別是簡單、普通、困難難度
        call readchar
        mov ecx, eax				;將輸入內容暫存到 ecx，eax 後續會用來放置遊戲進行速度
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
            jmp C1		;如果非以上三者輸入會跳回一開始重新做一次
        .ENDIF
    ;選完難度後會印出使用者選擇的難度
    mGotoXY 20, 5
    mwrite ">                                                   <"
    mGotoXY 20, 6
    mwrite ">          Your choice is:                          <"
    mGotoXY 50, 6
    ;判定輸入印出相對的難度
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

--------------------------------------------------------------
**game : 遊戲開始的主要函式**

game PROC
	call printBackground			;印出邊框及下方地板
	mGotoXY 73 , 1
	mwrite "score:"
	mGotoXY diamondX, diamondY    ; print diamond
	mov edx, OFFSET diamond    ; print diamond
	call WriteString    ; print diamond


     ;這裡用了gamecontinue判斷遊戲是否還繼續
	.WHILE gamecontinue    ; begin game
		;這裡用了appearTreeA/B判定樹的存在與否
		;distanceCheck的用意是確保生成的間隔，如果沒有會很常發生大小樹黏在一起的必死情況
		.IF (appearTreeA==0 || appearTreeB==0) && distanceCheck > 4   ; if there have no tree in screen
			mov eax, 6
			call randomRange    ; print tree in randomRange
			.IF eax==1
				mov appearTreeA, 1  ;設定為1代表生成
			.ENDIF
			.IF eax==3 || eax==4 || eax==5
				mov appearTreeB, 1
			.ENDIF
			mov distanceCheck, 0	  ;有生成才會把distanceCheck歸零
		.ENDIF


		;這裡是監聽使用者有沒有按下空白鍵(跳躍)
		call readkey    ; read keyboard input if available
		.IF al==20h    ; if equal to space
			mov al, 1
			mov ifmovdiamond, al ;同樣設定了一個變數確認是否跳躍
			call movdiamond    ; move the diamond
		.ENDIF


		;這裡是做路及樹的移動動畫
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
			dec delayTime		;delayTime越小速度越快所以是減
		.ENDIF
	Ladd: 
		pop ebx
		pop edx
		pop eax
		call ifTouch				;呼叫判斷是否撞到樹
		.IF gamecontinue==0
			ret
		.ENDIF
		inc distanceCheck
	.ENDW
	ret
game ENDP

--------------------------------------------------------------
**endgame : 遊戲結束的結算畫面**

endgame PROC
	call clearRet	;把所有變數都初始化一遍以便之後重新開始不會出問題
	mGotoXY 35, 3
	mwrite ">-------------------<"
	mGotoXY 35, 4
	mwrite ">     GAME OVER     <"
	mGotoXY 35, 5
	mwrite ">   Your score:     <"
	mGotoXY 51, 5
	mov eax, score
	dec eax		;這裡分數減一是因為在結束判定之前還會加到一次分數
	call WriteDec
	mov eax, 0
	mov score, eax    ;分數在這裡清零
	mGotoXY 35, 6
	mwrite ">-------------------<"
	mGotoXY 27, 8
	mwrite " <-------------------------------->"
	mGotoXY 27, 9
	mwrite " < Do You Want To Try Again?(Y/N) >"
	mGotoXY 27, 10
	mwrite " <-------------------------------->"
	call readchar		;這裡讀入輸入，判斷會回main裡
	ret
endgame ENDP

--------------------------------------------------------------
**clearRet : 初始化所有有用到的變數**
clearRet PROC    ; reset
	mov al, 0
	mov appearTreeA, al
	mov appearTreeB, al
	mov diamondD, al
;這個變數是為了要讓方塊正常跳躍設的，詳細解釋放在主要用到的地方
	mov ifmovdiamond, al
	mov movcount, al
	mov al, 1
	mov gamecontinue, al
	mov diamondU, al 
	mov al, 22				;初始化方塊的位置(X、Y)
	mov diamondX, al		
	mov al, 14
	mov diamondY, al
	mov al, 75				;這裡是初始化大樹的生成點(X座標)	
	mov treeA.linex, al
	mov al, 83				;這裡是初始化小樹的生成點
	mov treeB.linex, al
	ret
clearRet ENDP

--------------------------------------------------------------
**ifTouch : 判斷方塊是否有撞到樹**

ifTouch PROC    ; 判斷是否有跟出現的樹撞在一起
	.IF appearTreeA    	;如果是 treeA 出現的話
		mov al, treeA.linex
		mov tmp, al
		add tmp, 8		;tmp為大樹右側的X座標暫存(大樹寬度為8)
		mov al, diamondX
		;判斷方塊在樹X座標範圍裡時，Y座標有沒有大於10(較低) 
		;有就是撞到了，gamecontinue設定為0 
		.IF al>=treeA.linex && al<=tmp
			.IF diamondY>10
				mov gamecontinue, 0
				ret
			.ENDIF
		.ENDIF
	.ENDIF
	.IF appearTreeB     ;如果是 treeB 出現的話
		mov al, treeB.linex 
		mov tmp, al
		add tmp, 4		;tmp為小樹右側的X座標暫存(小樹寬度為4)
		mov al, diamondX
		;小樹判斷同理大樹 
		.IF al>treeB.linex && al<tmp
			.IF diamondY>12
				mov gamecontinue, 0
				ret
			.ENDIF
		.ENDIF
	.ENDIF
	ret
ifTouch ENDP

--------------------------------------------------------------
**movDiamond : 方塊的跳躍動作**
movdiamond PROC    ; 小方塊的移動
	;因為一開始動作不如預期，我們決定直接讓方塊跳固定高度(到Y=5) 
	;20的原因是從方塊跳起來到最高點在落下會經過20次畫面更新 
	.IF movcount==20
		mov al, 0
		mov ifmovdiamond, al
		mov movcount, al
		ret
	.ENDIF
	;這裡是判斷方塊當前是要向上還向下移動 
	.IF diamondU
		mGotoXY diamondX, diamondY
		mWrite "  "    ; 將原本的蓋掉
		dec diamondY
		mGotoXY diamondX, diamondY
		mov edx, OFFSET diamond
		call WriteString
		inc movcount
	.ENDIF
	.IF diamondY==5    ; 在最高點就改往下了，D設定為1
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
	.IF diamondY==15   ;回到Y=15就會停，設定U=1是為了下次移動做準備
		mov diamondD, 0
		mov diamondU, 1
	.ENDIF
	ret
movdiamond ENDP

--------------------------------------------------------------
**printTreeA : 印出大樹**
printTreeA PROC    ; 將 treeA 印出
	mGotoXY treea.linex, 10
	mov edx, OFFSET treeA.line1
	call WriteString		;最頂層
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
	call WriteString		;最底層
	ret
printTreeA ENDP

--------------------------------------------------------------
**printTreeB : 同理大樹印出小樹**
printTreeB PROC    ; 將 treeB 印出
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

--------------------------------------------------------------

clearTree : 在樹移動到最左邊時把樹清掉
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

--------------------------------------------------------------
**printBackground : 印出邊框及地板(不會動)**

printBackground PROC    ; 印出背景的框框
	mov ecx, 13
	mov edx, offset beginbackground1	;頂層(上面邊框)
	call writestring
	mov edx, offset beginbackground2
	L1:
		call writestring		;兩側邊框，一行為兩側*印13次
		Loop L1
	mov edx, offset underground1
	call writestring			
	mov edx, offset underground2_5
	call writestring			;路的初始狀態
	mov edx,offset beginbackground1
	call writestring			;底層(下面邊框)
	ret
printBackground ENDP

--------------------------------------------------------------
**loopPrint : 路及樹的移動，方塊移動也有在這裡呼叫**

loopprint PROC
; 地板移動效果
; 順便將 樹移動效果 以及 小方塊移動判斷 寫在這裡
; 隨著地板移動一次，樹以及小方塊（若是有要移動的話）也移動一次
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
		cmp treeA.linex, 1  ;這裡是判定有無抵達最左側 
		jb L2
		call printTreeA
		dec treeA.linex
		jmp L3
		L2:
			mov treeA.linex, 76		;初始化為下一顆樹做準備
			call clearTree
			mov appearTreeA, 0
		L3:
	.ENDIF
	.IF appearTreeB		;小樹同理
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
	call ifTouch    ;每移動一次，都要判斷一次是否有碰撞到
	.IF gamecontinue==0	
		ret		 ;判斷一次有無撞到後要接著判斷有息有沒有結束
	.ENDIF
	;以下同理，因為路的動畫設計為5次一循環所以做了5次 
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

--------------------------------------------------------------
**scoreCount : 計算分數及同步印出在遊玩畫面右上方，隨路的移動增加**
;路完整移動一次分數+1，所以速度慢分數加的比較慢
scoreCount PROC    ; 做計分的動作
	mGotoXY 80 , 1
	mov eax, score
	call WriteDec
	inc score
	ret
scoreCount ENDP

結論 : 
	做出一個實時互動的小遊戲比預期中的要更加複雜一點。一開始預期是分工完成細節的函式，最後再用 main 一起結合起來，但在實作中發現，若是在撰寫函式的過程中沒有頻繁的討論的話，要進行整合是一件有點花時間的事情，因為每個人的考慮方向不一樣，計算儲存某一樣變數的方式也不同，更好的一個方法應該是在分工前就寫好虛擬碼，然後再個別詳細撰寫程式碼。
	撰寫期間的討論也是重要的，大部分的邏輯上的 bug 都是在討論過程中解決。
