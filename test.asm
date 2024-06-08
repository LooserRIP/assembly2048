IDEAL
MODEL small
STACK 100h

DATASEG
    mask_four dq 30d140500141818h,90505040e040509h,0e12050304090404h,20a01070d020402h,809040106070302h,80a0301030a0103h,130c03010b040301h,5080101010d0102h,80b010108060101h,101501010c030101h,11030101h,2 dup(0h)
CODESEG


start:
	mov ax, @data
	mov ds, ax
    
    mov ax, [word ptr ds:0]
	mov cl, [byte ptr ds:0]
	mov cl, [byte ptr ds:1]
    mov bx, [word ptr ds:2]

exit:
	mov ax, 4c00h
	int 21h
	mov ax, 5
	xor bx, bx



END start
