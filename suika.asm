IDEAL
MODEL small
STACK 100h
SEGMENT ScreenBuffer PUBLIC
	buffer db (320*200) dup(0)
ENDS ScreenBuffer

DATASEG
; --------------------------
; Your variables here
; --------------------------	
	tempElement db 50 dup(0)
    listsAlloc db 5000 dup(0ffh)
	listsInfo db 300 dup (00h)
	listsAmount dw 0
	listsOffset dw 0
	mov ax, ScreenBuffer
	mov es, ax
	
	sprite_1 db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1,1,1,2,2,2,2,1,1,1,1,0,0,0,0,1,1,1,1,2,2,2,2,1,1,1,1,0,0,0,0,1,1,1,1,2,2,2,2,1,1,1,1,0,0,0,0,1,1,1,1,2,2,2,2,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

CODESEG



proc Delay
	; parameters:
	; - wait time (roughly in seconds)
	; returns nothing.
	push bp
	mov bp, sp
	push ax bx cx
	waitTime equ [word ptr bp + 4]
	mov cx, waitTime
	xor ax, ax
	Delay_Loop:
		inc ax
		cmp ax, 0ffffh
		jb skipdont
			mov ax, 0
			loop Delay_Loop
		skipdont:
		inc cx
	loop Delay_Loop
	pop cx bx ax bp
	ret 2
endp Delay

proc ClampNumber ;takes a number and a max number and caps it off a minimum and maximum.
	; parameters:
	; - VALUE: input number
	; - VALUE: minimum number
    ; - VALUE: maximum number
	; returns:
	; - VALUE: capped number
	push bp
	mov bp, sp
	push ax bx cx dx di

	inputNumber equ [word ptr bp + 8]
	minimumNumber equ [word ptr bp + 6]
	maximumNumber equ [word ptr bp + 4]

    mov ax, inputNumber
    cmp ax, maximumNumber
    jb ClampNumber_DontClamp1
        mov ax, maximumNumber
    ClampNumber_DontClamp1:
    cmp ax, minimumNumber
    ja ClampNumber_DontClamp2
        mov ax, minimumNumber
    ClampNumber_DontClamp2:
    mov inputNumber, ax

	pop di dx cx bx ax
	pop bp
	ret 4
endp ClampNumber

proc ModNumber ;takes a number and a divisor and returns the modulo.
    ; formula: ((n - min) % max) + min
	; parameters:
	; - VALUE: input number
	; - VALUE: divisor
	; returns:
	; - VALUE: modulo'd number
	push bp
	mov bp, sp
	push ax dx di

	inputNumber equ [word ptr bp + 6]
	divisor equ [word ptr bp + 4]

    mov ax, inputNumber
    mov dx, 0
    idiv divisor
    mov inputNumber, dx

	pop di dx ax
	pop bp
	ret 2
endp ModNumber

proc ListCreate ;Creates a list to the allocation
	; Parameters:
	; - Element Length
	; - Element Allocation Length
	; Returns:
	; - List ID
	push bp
	mov bp, sp
	push ax bx cx dx di

	elementLength equ [word ptr bp + 6]
	elementAllocationLength equ [word ptr bp + 4]

	; Get list memory length
	mov ax, elementLength
	mul elementAllocationLength
	add listsOffset, ax ;we do this little double thing so that listsOffsets gets permanently added to.
	mov ax, listsOffset

	; Get lists amount
	mov bx, listsAmount
	shl bx, 3 ;every list info is 8 bytes exactly
	add bx, offset listsInfo ;this is now the list's info offset
	mov [word ptr bx], ax ;move the allocation offset first things first
	mov cx, elementLength
	mov [word ptr bx + 2], cx ;move the element length
	mov cx, elementAllocationLength
	mov [word ptr bx + 4], cx ;move the element allocation length
	mov [word ptr bx + 6], 0 ;move the count, which is a 0

	; We do this little trickery to return the ID of the newly created list.
	mov ax, listsAmount
	mov elementLength, ax
	inc listsAmount

	pop di dx cx bx ax
	pop bp
	ret 2
endp ListCreate

proc ListCount ;Returns the count of the list.
	; Parameters:
	; - List ID
	; Returns:
	; - Count
	push bp
	mov bp, sp
	push ax bx

	listID equ [word ptr bp + 4]

	; Get list info offset
	mov bx, listID
	shl bx, 3 ;every list info is 8 bytes exactly
	add bx, offset listsInfo ;this is now the list's info offset

	; Move the count to it
	mov ax, [word ptr bx + 6]
	mov listID, ax

	pop bx ax
	pop bp
	ret
endp ListCount

proc ListSet ;Sets an element in a list with an index and a reference.
	; Parameters:
	; - List ID
	; - Element Reference
	; - Index
	push bp
	mov bp, sp
	push ax bx cx dx di si

	listID equ [word ptr bp + 8]
	elementReference equ [word ptr bp + 6]
	index equ [word ptr bp + 4]

	; Get list info offset
	mov bx, listID
	shl bx, 3 ;every list info is 8 bytes exactly
	add bx, offset listsInfo ;this is now the list's info offset

	; Move the offset of the list
	mov di, [word ptr bx]
	; Get the element length
	mov ax, [word ptr bx+2]
	mov cx, ax ;Save it in cx before multiplying

	mul index ;Multiply it by the index
	add di, ax ;DI = ListOffset + (ElementLength * Index)
	mov si, elementReference ;SI = ElementReferenceOffset

	ListSet_Loop: ;Setting byte by byte, because i'm an idiot and terribly scared of movsb
		mov dl, [byte ptr si]
		mov [byte ptr di], dl
		inc di
		inc si
	loop ListSet_Loop


	pop si di dx cx bx ax
	pop bp
	ret
endp ListSet

proc ListClear ;Clears a list
	; Parameters:
	; - List ID
	push bp
	mov bp, sp
	push ax bx cx dx di

	listID equ [word ptr bp + 4]

	; Get list info offset
	mov bx, listID
	shl bx, 3 ;every list info is 8 bytes exactly
	add bx, offset listsInfo ;this is now the list's info offset

	; Move the offset of the list
	mov di, [word ptr bx]
	; Get the element length
	mov ax, [word ptr bx+2]
	mov dx, [word ptr bx+6] ;Save the element count, this'll serve as the index
	mul dx ;Multiply it by the index
	mov cx, ax ; CX = ElementLength * Count

	ListClear_Loop: ;Setting byte by byte, because i'm an idiot and terribly scared of movsb
		mov [byte ptr di], 0ffh
		inc di
	loop ListClear_Loop


	pop di dx cx bx ax
	pop bp
	ret
endp ListClear

proc ListAdd ;Adds something to the list, wrapped around ListSet
	; Parameters:
	; - List ID
	; - Element Reference
	push bp
	mov bp, sp
	push bx cx

	listID equ [word ptr bp + 6]
	elementReference equ [word ptr bp + 4]

	; Get list info offset
	mov bx, listID
	shl bx, 3 ;every list info is 8 bytes exactly
	add bx, offset listsInfo ;this is now the list's info offset

	; Get the list count, this'll serve as an index.
	mov cx, [word ptr bx+6]
	inc [word ptr bx+6] ;Increase the index
	push listID
	push elementReference
	push cx ;Index
	call ListSet

	pop cx bx
	pop bp
	ret
endp ListAdd

proc ListGet ;Returns 
	; Parameters:
	; - List ID
	; - Element Reference
	; - Index
	push bp
	mov bp, sp
	push ax bx cx dx di si

	listID equ [word ptr bp + 8]
	elementReference equ [word ptr bp + 6]
	index equ [word ptr bp + 4]

	; Get list info offset
	mov bx, listID
	shl bx, 3 ;every list info is 8 bytes exactly
	add bx, offset listsInfo ;this is now the list's info offset

	; Move the offset of the list
	mov di, [word ptr bx]
	; Get the element length
	mov ax, [word ptr bx+2]
	mov cx, ax ;Save it in cx before multiplying

	mul index ;Multiply it by the index
	add di, ax ;DI = ListOffset + (ElementLength * Index) = ListElementReferenceOffset
	mov si, elementReference ;SI = ElementReferenceOffset

	ListGet_Loop: ;Setting byte by byte, because i'm an idiot and terribly scared of movsb
		mov dl, [byte ptr di]
		mov [byte ptr si], dl
		inc di
		inc si
	loop ListGet_Loop


	pop si di dx cx bx ax
	pop bp
	ret
endp ListGet

proc ExampleProcedure ;a perfect template of a good procedure :)
	; parameters:
    ; - VALUE1: Some value
    ; - VALUE2: Another value
	; returns:
    ; - VALUE3: More value
	push bp
	mov bp, sp
	push ax bx cx dx di

	value1 equ [word ptr bp + 6]
	value2 equ [word ptr bp + 4]

    ; Simple Value3 = Value1 + Value2
    mov bx, value2
    add value1, bx

	pop di dx cx bx ax
	pop bp
	ret 2
endp ExampleProcedure


proc ClearBuffer ;clears the screen buffer
	push ax bx cx di es
	mov ax, ScreenBuffer
	mov es, ax ;ES is now at the screen buffer
	mov di, 0
	mov cx, 32000
	ClearBuffer_Loop:
		mov [word ptr es:di], 0002h
		add di, 2
	loop ClearBuffer_Loop
	pop es di cx bx ax
	ret
endp ClearBuffer

proc RenderFrame ;renders the screenbuffer over to the video memory
	push ax bx cx di ds si es

	mov ax, ScreenBuffer
	mov ds, ax ; DS is now at the screen buffer
	mov di, 0

	mov ax, 0A000h
	mov es, ax ; ES is now at the video memory
	mov si, 0

	mov cx, (320*200) ;We wanna iterate 64k times for every pixel

	rep movsb ;This does that shit
	
	pop es si ds di cx bx ax
	ret
endp RenderFrame

start:
	mov ax, @data
	mov ds, ax

	; Graphics Mode
	mov ax, 13h
	int 10h
    
	push 4 ;Element Length
	push 6 ;List Length
    call ListCreate
	pop ax ; List ID

	mov bx, offset tempElement
	mov [word ptr bx], 1234h
	mov [word ptr bx + 2], 7575h
	push ax ; List ID
	push bx ; Element Offset
	call ListAdd

	mov bx, offset tempElement
	mov [word ptr bx], 5505h
	mov [word ptr bx + 2], 2020h
	push ax ; List ID
	push bx ; Element Offset
	call ListAdd

	call ClearBuffer
	render:
	call RenderFrame
	jmp render

exit:
	mov ax, 4c00h
	int 21h
END start