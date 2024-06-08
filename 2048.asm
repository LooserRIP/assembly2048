;  _   _ ___   ____  _   _ __  __ _   _ _     ___ _  __
; | | | |_ _| / ___|| | | |  \/  | | | | |   |_ _| |/ /
; | |_| || |  \___ \| |_| | |\/| | | | | |    | || ' / 
; |  _  || |   ___) |  _  | |  | | |_| | |___ | || . \ 
; |_| |_|___| |____/|_| |_|_|  |_|\___/|_____|___|_|\_\
IDEAL
MODEL small
STACK 100h
SEGMENT ScreenBuffer PUBLIC
	buffer db (320*200) dup(0)
ENDS ScreenBuffer

DATASEG
	;   ____                _              _       
	;  / ___|___  _ __  ___| |_ __ _ _ __ | |_ ___ 
	; | |   / _ \| '_ \/ __| __/ _` | '_ \| __/ __|
	; | |__| (_) | | | \__ \ || (_| | | | | |_\__ \
	;  \____\___/|_| |_|___/\__\__,_|_| |_|\__|___/
	constant_framesToShowGameOver equ 60

	nullbyte equ 0ffh
	nullword equ 0ffffh
	boolFalse equ 0
	boolTrue equ 1

	gamemodeMainMenu equ 0
	gamemodePlaying equ 1
	gamemodeDead equ 2
	gamemodePause equ 3
	;  ___       _                        _ 
	; |_ _|_ __ | |_ ___ _ __ _ __   __ _| |
	;  | || '_ \| __/ _ \ '__| '_ \ / _` | |
	;  | || | | | ||  __/ |  | | | | (_| | |
	; |___|_| |_|\__\___|_|  |_| |_|\__,_|_|
	;
	internal_tempElement db 50 dup(0)
	internal_testCounter dw 0

	internal_primes dw 6e81h,78adh,2b27h,0a535h,266fh,88cfh,9e47h,241h,0c86bh,5e57h,7051h,0d3dh,0a457h,0e969h,0a5c5h,0fc41h,0c461h,0e6c5h
		   dw 5fbdh,59f3h,5dfdh,2da9h,9debh,0d187h,3d1fh,8143h,2e37h,6011h,8f2dh,0db31h,50c9h,155fh,933dh,0c5fbh,0dac3h,0c3e9h,5b49h
		   dw 6d2bh,417bh,2149h,4d81h,5e39h,3fbfh,0df69h,103dh,9287h,1c55h,0e183h,4badh,0a0f1h,0a5ddh,588dh,0bbdbh,905h,76f1h,0adf5h
		   dw 19cfh,73bdh,4e9bh,0b82dh,3275h,6557h,7211h,2cffh,0dc9fh,8e01h,0f503h,0cdf1h,0fc29h,2f83h,0fbf3h,0a64bh,9da9h,2063h,329fh
		   dw 9a61h,0d081h,6421h,6c59h,4f2dh,793fh,21d7h,773h,2813h,70f9h,238fh,0dd39h,0d343h,0e95h,22e5h,0dc61h,0f269h,9127h,3f1h,0d159h
		   dw 0b3h,26bh,65e3h,0bd8fh,276dh,2e7fh,0cfc5h,0e171h,74e1h,0d42fh,1343h,55f3h,0c1e7h,0e98fh,0b9ddh,7bebh,97b7h,48efh,2aebh,98f9h
		   dw 4f63h,7673h,410bh,80cbh,2a9dh,239h,6f79h,2e3h,949fh,143bh,0fdf3h,8021h,0dd7dh,77b3h,8eabh,52e5h,0afa3h,27efh,230bh,0b3a5h,3173h
		   dw 1da5h,8d0dh,0f93bh,2029h,2419h,66cdh,2135h,40fh,0ac1h,5f77h,0f485h,0baa3h,0d315h,0f0d3h,4043h,0fb93h,0bcb9h,0f8ddh,0d945h,0e59h
		   dw 2c5h,0a67h,3a1h,7703h,5c6fh,4d8dh,1b83h,110bh,8231h,135dh,616fh,40f9h,0bb9h,9f7h,259fh,0f79dh,8bd5h,599h,86c5h,0fa3fh,9fc1h,9733h
		   dw 0f7bdh,4be9h,0abf5h,8d41h,0ca7fh,0b5h,0a597h,0e1bfh,0f257h,0efh,96fdh,47b1h,0a1a5h,0aba7h,93efh,6a91h,0eacbh,2351h,1e95h,2287h,0e5h,0d661h
    internal_primeCounter dw 0

    lists_alloc db 5000 dup(nullbyte)
	lists_info db 300 dup (00h)
	lists_amount dw 0
	lists_offset dw 0

	listID_particles dw nullword
	listID_animation dw nullword
	animation_speed dw 0

	internal_blockSpriteOffsets dw offset sprite_2, offset sprite_4, offset sprite_8, offset sprite_16, offset sprite_32, offset sprite_64, offset sprite_128, offset sprite_256, offset sprite_512, offset sprite_1024, offset sprite_2048
	internal_backgroundMaskOffsets dw 3 dup(offset mask_background_two), 3 dup(offset mask_background_four), 3 dup(offset mask_background_eight), 3 dup(offset mask_background_exponent), offset mask_background_plus, offset mask_background_smiley, offset mask_background_wtf, offset mask_background_shmulik
	
	internal_keyActions dw 256 dup(nullword)

	;  ____                _           _             
	; |  _ \ ___ _ __   __| | ___ _ __(_)_ __   __ _ 
	; |  _ <  __/ | | | (_| |  __/ |  | | | | | (_| |
	; |_| \_\___|_| |_|\__,_|\___|_|  |_|_| |_|\__, |
	;                                          |___/ 
	
	; Palettes
    rendering_palette dq 2c2b47394f3f2b38h,3d262553333247h,8f8a0b655e0b554eh,195fb9e1309baf0eh,0e8572cbb4c217e46h,22195f8787f07c57h,7de82c4bbb21267eh,8e394e7287bdf057h,65d4f641a7cf3f6bh,89503d6e4f91faf8h,0c66eedba4ac69a44h,748944556e3da6fch,0fca690ed6e66c64ah,0fc3b3be83423aed0h,69deff51b4ff4f8ch,75bbd1648aa85085h,0b4ffb5f6f48bdcf4h,72b4f9e9d497959ah,9b87fcf4a2f9f9deh,0c4b7aca8adadad9eh,97bd2eaeaeac4c4h,0cef80aaaf5009ddbh,0ff00d4ff50e1fd60h,7477ce6f3bc2aaffh,45d08166cf7256ceh,0eb3d5ada858cd847h,0c7bfeeafcbebc5ach,65d8474cd36d53c9h,0bed3ed4fh,68 dup(0h)
	
    sprite_2 dw 2 dup(20h),1h,9ffh,14 dup(909h),0ff09h,15 dup(909h),708h,909h,809h,13 dup(808h),707h,909h,14 dup(808h),707h,909h,5 dup(808h),3 dup(505h),805h,5 dup(808h),707h,909h,4 dup(808h),505h,605h,3 dup(606h),805h,4 dup(808h),707h,909h,3 dup(808h),508h,605h,5 dup(606h),4 dup(808h),707h,909h,3 dup(808h),505h,2 dup(606h),2 dup(808h),2 dup(606h),806h,3 dup(808h),707h,909h,3 dup(808h),605h,606h,4 dup(808h),606h,806h,3 dup(808h),707h,909h,3 dup(808h),608h,806h,4 dup(808h),605h,606h,3 dup(808h),707h,909h,9 dup(808h),605h,606h,3 dup(808h),707h,909h,9 dup(808h),605h,606h,3 dup(808h),707h,909h,9 dup(808h),605h,606h,3 dup(808h),707h,909h,9 dup(808h),605h,606h,3 dup(808h),707h,909h,8 dup(808h),508h,605h,806h,3 dup(808h),707h,909h,8 dup(808h),505h,606h,806h,3 dup(808h),707h,909h,7 dup(808h),508h,605h,606h,4 dup(808h),707h,909h,7 dup(808h),505h,606h,806h,4 dup(808h),707h,909h,6 dup(808h),508h,605h,606h,5 dup(808h),707h,909h
             dw 6 dup(808h),505h,606h,806h,5 dup(808h),707h,909h,5 dup(808h),508h,605h,606h,6 dup(808h),707h,909h,5 dup(808h),505h,606h,806h,6 dup(808h),707h,909h,4 dup(808h),508h,605h,606h,7 dup(808h),707h,909h,4 dup(808h),505h,606h,806h,7 dup(808h),707h,909h,3 dup(808h),508h,605h,606h,8 dup(808h),707h,909h,3 dup(808h),505h,2 dup(606h),4 dup(505h),805h,3 dup(808h),707h,909h,3 dup(808h),605h,7 dup(606h),3 dup(808h),707h,909h,3 dup(808h),608h,7 dup(606h),3 dup(808h),707h,909h,14 dup(808h),707h,909h,13 dup(808h),708h,707h,809h,15 dup(707h),7ffh,14 dup(707h),0ff07h,4 dup(0h)
    sprite_4 dw 2 dup(20h),1h,0effh,14 dup(0e0eh),0ff0eh,15 dup(0e0eh),0c0dh,0e0eh,0d0eh,13 dup(0d0dh),0c0ch,0e0eh,14 dup(0d0dh),0c0ch,0e0eh,7 dup(0d0dh),0a0dh,0a0ah,5 dup(0d0dh),0c0ch,0e0eh,7 dup(0d0dh),0a0ah,0b0bh,0d0bh,4 dup(0d0dh),0c0ch,0e0eh,6 dup(0d0dh),0a0dh,0b0ah,0b0bh,0d0bh,4 dup(0d0dh),0c0ch,0e0eh,6 dup(0d0dh),0a0dh,3 dup(0b0bh),4 dup(0d0dh),0c0ch,0e0eh,6 dup(0d0dh),0a0ah,3 dup(0b0bh),4 dup(0d0dh),0c0ch,0e0eh,5 dup(0d0dh),0a0dh,0b0ah,0b0bh,0b0ah,0b0bh,4 dup(0d0dh),0c0ch,0e0eh,5 dup(0d0dh),0a0ah,0b0bh,0d0bh,0b0ah,0b0bh,4 dup(0d0dh),0c0ch,0e0eh,5 dup(0d0dh),0b0ah,0b0bh,0d0dh,0b0ah,0b0bh,4 dup(0d0dh),0c0ch,0e0eh,4 dup(0d0dh),0a0dh,0b0ah,0b0bh,0d0dh,0b0ah,0b0bh,4 dup(0d0dh),0c0ch,0e0eh,4 dup(0d0dh),0a0ah,0b0bh,0d0bh,0d0dh,0b0ah,0b0bh,4 dup(0d0dh),0c0ch,0e0eh,3 dup(0d0dh),0a0dh,0b0ah,0b0bh,2 dup(0d0dh),0b0ah,0b0bh,4 dup(0d0dh),0c0ch,0e0eh,3 dup(0d0dh),0a0dh,2 dup(0b0bh),2 dup(0d0dh),0b0ah,0b0bh,4 dup(0d0dh)
             dw 0c0ch,0e0eh,3 dup(0d0dh),0a0ah,0b0bh,0d0bh,2 dup(0d0dh),0b0ah,0b0bh,4 dup(0d0dh),0c0ch,0e0eh,2 dup(0d0dh),0a0dh,0b0ah,0b0bh,3 dup(0d0dh),0b0ah,0b0bh,4 dup(0d0dh),0c0ch,0e0eh,2 dup(0d0dh),0a0ah,2 dup(0b0bh),3 dup(0d0dh),0b0ah,0b0bh,4 dup(0d0dh),0c0ch,0e0eh,2 dup(0d0dh),0b0ah,2 dup(0b0bh),3 dup(0a0ah),0b0ah,0b0bh,0a0ah,0d0ah,2 dup(0d0dh),0c0ch,0e0eh,2 dup(0d0dh),0b0ah,8 dup(0b0bh),0d0bh,2 dup(0d0dh),0c0ch,0e0eh,2 dup(0d0dh),0b0dh,9 dup(0b0bh),2 dup(0d0dh),0c0ch,0e0eh,3 dup(0d0dh),8 dup(0b0bh),0d0bh,2 dup(0d0dh),0c0ch,0e0eh,8 dup(0d0dh),0b0ah,0b0bh,4 dup(0d0dh),0c0ch,0e0eh,8 dup(0d0dh),0b0ah,0b0bh,4 dup(0d0dh),0c0ch,0e0eh,8 dup(0d0dh),0b0ah,0b0bh,4 dup(0d0dh),0c0ch,0e0eh,8 dup(0d0dh),0b0ah,0b0bh,4 dup(0d0dh),0c0ch,0e0eh,8 dup(0d0dh),0b0ah,0b0bh,4 dup(0d0dh),0c0ch,0e0eh,14 dup(0d0dh),0c0ch,0e0eh,13 dup(0d0dh),0c0dh,0c0ch,0d0eh,15 dup(0c0ch),0cffh,14 dup(0c0ch),0ff0ch,4 dup(0h)
    sprite_8 db 32,0,32,0,1,0,255,30 dup(19),255,30 dup(19),18,17,3 dup(19),27 dup(18),2 dup(17),2 dup(19),28 dup(18),2 dup(17),2 dup(19),10 dup(18),7 dup(15),11 dup(18),2 dup(17),2 dup(19),8 dup(18),3 dup(15),7 dup(16),15,9 dup(18),2 dup(17),2 dup(19),7 dup(18),2 dup(15),11 dup(16),8 dup(18),2 dup(17),2 dup(19),6 dup(18),2 dup(15),13 dup(16),7 dup(18),2 dup(17),2 dup(19),6 dup(18),15,4 dup(16),7 dup(18),4 dup(16),6 dup(18),2 dup(17),2 dup(19),6 dup(18),15,3 dup(16),8 dup(18),15,3 dup(16),6 dup(18),2 dup(17),2 dup(19),6 dup(18),15,3 dup(16),8 dup(18),15,3 dup(16),6 dup(18),2 dup(17),2 dup(19),6 dup(18),15,3 dup(16),8 dup(18),15,3 dup(16),6 dup(18),2 dup(17),2 dup(19),6 dup(18),15,3 dup(16),8 dup(18),15,3 dup(16),6 dup(18),2 dup(17),2 dup(19),7 dup(18),4 dup(16),5 dup(18),3 dup(15),3 dup(16),6 dup(18),2 dup(17),2 dup(19),8 dup(18),4 dup(16),5 dup(15),4 dup(16),7 dup(18),2 dup(17),2 dup(19),9 dup(18)
             db 11 dup(16),8 dup(18),2 dup(17),2 dup(19),7 dup(18),3 dup(15),9 dup(16),15,8 dup(18),2 dup(17),2 dup(19),6 dup(18),2 dup(15),5 dup(16),3 dup(18),5 dup(16),7 dup(18),2 dup(17),2 dup(19),6 dup(18),15,4 dup(16),7 dup(18),4 dup(16),6 dup(18),2 dup(17),2 dup(19),5 dup(18),2 dup(15),3 dup(16),9 dup(18),3 dup(16),6 dup(18),2 dup(17),2 dup(19),5 dup(18),15,3 dup(16),10 dup(18),15,3 dup(16),5 dup(18),2 dup(17),2 dup(19),5 dup(18),15,3 dup(16),10 dup(18),15,3 dup(16),5 dup(18),2 dup(17),2 dup(19),5 dup(18),15,3 dup(16),10 dup(18),15,3 dup(16),5 dup(18),2 dup(17),2 dup(19),6 dup(18),3 dup(16),9 dup(18),2 dup(15),3 dup(16),5 dup(18),2 dup(17),2 dup(19),6 dup(18),15,3 dup(16),15,5 dup(18),3 dup(15),3 dup(16),6 dup(18),2 dup(17),2 dup(19),7 dup(18),5 dup(16),5 dup(15),5 dup(16),6 dup(18),2 dup(17),2 dup(19),8 dup(18),13 dup(16),7 dup(18),2 dup(17),2 dup(19),10 dup(18),9 dup(16),9 dup(18),2 dup(17)
             db 2 dup(19),28 dup(18),2 dup(17),2 dup(19),27 dup(18),3 dup(17),19,18,30 dup(17),255,30 dup(17),255,8 dup(0)
    sprite_16 dd 200020h,18ff0001h,7 dup(18181818h),1818ff18h,7 dup(18181818h),18181617h,17171718h,6 dup(17171717h),18181616h,7 dup(17171717h),18181616h,7 dup(17171717h),18181616h,7 dup(17171717h),18181616h,7 dup(17171717h),18181616h,17171717h,14171717h,17171714h,17171717h,14141717h,17141414h,17171717h,18181616h,17171717h,14141414h,17171515h,17171717h,15141414h,15151515h,17171717h,18181616h,14171717h,15151514h,17171515h,14171717h,15151514h,15151515h,17171715h,18181616h,14141717h,15151515h,17171515h,14141717h,17151515h,17171717h,17171715h,18181616h,15171717h,14171515h,17171515h,15141417h,17171515h,2 dup(17171717h),18181616h,17171717h,14171717h,17171515h,15151417h,17171715h,2 dup(17171717h),18181616h,17171717h,14171717h,17171515h,15151417h,3 dup(17171717h),18181616h,17171717h,14171717h,17171515h,15151417h,14141417h,17141414h,17171717h,18181616h,17171717h,14171717h,17171515h,15151417h
              dd 15151414h,15151515h,17171717h,18181616h,17171717h,14171717h,17171515h,15151417h,2 dup(15151515h),17171715h,18181616h,17171717h,14171717h,17171515h,15151417h,17171515h,15171717h,17171515h,18181616h,17171717h,14171717h,17171515h,15151417h,17171717h,14171717h,17171515h,18181616h,17171717h,14171717h,17171515h,15151417h,17171717h,14171717h,17171515h,18181616h,17171717h,14171717h,17171515h,15151417h,17171717h,14171717h,17171515h,18181616h,17171717h,14171717h,17171515h,15151417h,17171717h,14171717h,17171515h,18181616h,17171717h,14171717h,17171515h,15151717h,17171715h,14141717h,17171515h,18181616h,17171717h,14171717h,17171515h,15171717h,14141515h,15141414h,17171515h,18181616h,17171717h,14171717h,17171515h,17171717h,2 dup(15151515h),17171715h,18181616h,2 dup(17171717h),17171515h,17171717h,15151517h,15151515h,17171717h,18181616h,7 dup(17171717h),18181616h,7 dup(17171717h),18181616h
              dd 7 dup(17171717h),18181616h,6 dup(17171717h),16171717h,17181616h,7 dup(16161616h),16ff1616h,7 dup(16161616h),0ff16h,2 dup(0h)
    sprite_32 dw 2 dup(20h),1h,1dffh,14 dup(1d1dh),0ff1dh,15 dup(1d1dh),1b1ch,1d1dh,1c1dh,13 dup(1c1ch),1b1bh,1d1dh,14 dup(1c1ch),1b1bh,1d1dh,14 dup(1c1ch),1b1bh,1d1dh,14 dup(1c1ch),1b1bh,1d1dh,14 dup(1c1ch),1b1bh,1d1dh,1c1ch,191ch,2 dup(1919h),1c19h,3 dup(1c1ch),191ch,2 dup(1919h),3 dup(1c1ch),1b1bh,1d1dh,1c1ch,1919h,3 dup(1a1ah),1c19h,1c1ch,191ch,1919h,2 dup(1a1ah),191ah,2 dup(1c1ch),1b1bh,1d1dh,191ch,1a19h,4 dup(1a1ah),1c1ch,191ch,4 dup(1a1ah),1c1ah,1c1ch,1b1bh,1d1dh,1c1ch,1a1ah,1c1ah,2 dup(1c1ch),1a1ah,1c1ah,1c1ch,1a1ah,2 dup(1c1ch),1a1ch,1a1ah,1c1ch,1b1bh,1d1dh,5 dup(1c1ch),1a19h,1c1ah,4 dup(1c1ch),191ch,1a1ah,1c1ch,1b1bh,1d1dh,5 dup(1c1ch),1a19h,1c1ah,4 dup(1c1ch),191ch,1a1ah,1c1ah,1b1bh,1d1dh,5 dup(1c1ch),1a19h,1c1ah,4 dup(1c1ch),191ch,1a1ah,1c1ah,1b1bh,1d1dh,4 dup(1c1ch),1919h,1a19h,1c1ah,4 dup(1c1ch),1919h,1a1ah,1c1ch,1b1bh,1d1dh,2 dup(1c1ch),2 dup(1919h),1a19h,1a1ah,5 dup(1c1ch),1a19h,1a1ah,1c1ch,1b1bh,1d1dh
              dw 2 dup(1c1ch),1a19h,2 dup(1a1ah),1c1ah,4 dup(1c1ch),191ch,1a19h,1c1ah,1c1ch,1b1bh,1d1dh,2 dup(1c1ch),1a1ch,3 dup(1a1ah),4 dup(1c1ch),1919h,1a1ah,1c1ah,1c1ch,1b1bh,1d1dh,5 dup(1c1ch),1a1ah,1c1ah,2 dup(1c1ch),191ch,1a19h,1a1ah,2 dup(1c1ch),1b1bh,1d1dh,5 dup(1c1ch),1a1ch,1a1ah,2 dup(1c1ch),1919h,1a1ah,1c1ah,2 dup(1c1ch),1b1bh,1d1dh,5 dup(1c1ch),191ch,1a1ah,1c1ch,191ch,1a19h,1a1ah,3 dup(1c1ch),1b1bh,1d1dh,5 dup(1c1ch),1919h,1a1ah,1c1ch,1919h,1a1ah,1c1ah,3 dup(1c1ch),1b1bh,1d1dh,191ch,1c19h,3 dup(1c1ch),1a19h,1a1ah,191ch,1a19h,1a1ah,4 dup(1c1ch),1b1bh,1d1dh,191ch,1a1ah,3 dup(1919h),1a19h,1c1ah,1919h,1a1ah,191ah,3 dup(1919h),1c1ch,1b1bh,1d1dh,1c1ch,5 dup(1a1ah),1c1ah,1a19h,5 dup(1a1ah),1c1ah,1b1bh,1d1dh,1c1ch,1a1ch,3 dup(1a1ah),1c1ah,1c1ch,1a1ch,5 dup(1a1ah),1c1ah,1b1bh,1d1dh,14 dup(1c1ch),1b1bh,1d1dh,14 dup(1c1ch),1b1bh,1d1dh,14 dup(1c1ch),1b1bh,1d1dh,13 dup(1c1ch),1b1ch,1b1bh,1c1dh,15 dup(1b1bh),1bffh
              dw 14 dup(1b1bh),0ff1bh,4 dup(0h)
    sprite_64 dd 200020h,22ff0001h,7 dup(22222222h),2222ff22h,7 dup(22222222h),22222021h,21212122h,6 dup(21212121h),22222020h,7 dup(21212121h),22222020h,7 dup(21212121h),22222020h,7 dup(21212121h),22222020h,21212121h,1e1e2121h,211e1e1eh,2 dup(21212121h),1e1e2121h,2121211eh,22222020h,21212121h,1f1e1e1eh,1f1f1f1fh,2 dup(21212121h),1f1e1e21h,21211f1fh,22222020h,1e212121h,1f1f1f1eh,1f1f1f1fh,2121211fh,21212121h,1f1f1e21h,21211f1fh,22222020h,1e1e2121h,211f1f1fh,21212121h,2121211fh,21212121h,1f1f1e1eh,21211f1fh,22222020h,1f1e1e21h,21211f1fh,2 dup(21212121h),1e212121h,1e1f1f1eh,21211f1fh,22222020h,1f1f1e21h,2121211fh,2 dup(21212121h),1e1e2121h,1e1f1f1fh,21211f1fh,22222020h,1f1f1e21h,3 dup(21212121h),1f1e2121h,1e211f1fh,21211f1fh,22222020h,1f1f1e21h,1e1e1e21h,211e1e1eh,21212121h,1f1e1e21h,1e21211fh,21211f1fh,22222020h,1f1f1e21h,1f1f1e1eh,1f1f1f1fh,21212121h,1f1f1e1eh,1e212121h,21211f1fh
              dd 22222020h,1f1f1e21h,2 dup(1f1f1f1fh),1e21211fh,1f1f1f1eh,1e212121h,21211f1fh,22222020h,1f1f1e21h,21211f1fh,1f212121h,1e211f1fh,211f1f1fh,1e212121h,21211f1fh,22222020h,1f1f1e21h,21212121h,1e212121h,1e1e1f1fh,21211f1fh,1e212121h,21211f1fh,22222020h,1f1f1e21h,21212121h,1e212121h,1f1e1f1fh,1e1e1f1fh,1e1e1e1eh,211e1f1fh,22222020h,1f1f1e21h,21212121h,1e212121h,1f1e1f1fh,3 dup(1f1f1f1fh),22222020h,1f1f1e21h,21212121h,1e212121h,1f211f1fh,3 dup(1f1f1f1fh),22222020h,1f1f2121h,2121211fh,1e1e2121h,21211f1fh,21212121h,1e212121h,21211f1fh,22222020h,1f212121h,1e1e1f1fh,1f1e1e1eh,21211f1fh,21212121h,1e212121h,21211f1fh,22222020h,21212121h,2 dup(1f1f1f1fh),2121211fh,21212121h,1e212121h,21211f1fh,22222020h,21212121h,1f1f1f21h,1f1f1f1fh,3 dup(21212121h),21211f1fh,22222020h,7 dup(21212121h),22222020h,7 dup(21212121h),22222020h,7 dup(21212121h),22222020h,7 dup(21212121h),22222020h
              dd 6 dup(21212121h),20212121h,21222020h,7 dup(20202020h),20ff2020h,7 dup(20202020h),0ff20h,2 dup(0h)
    sprite_128 dd 200020h,27ff0001h,7 dup(27272727h),2727ff27h,7 dup(27272727h),27272526h,26262627h,6 dup(26262626h),27272525h,7 dup(26262626h),27272525h,7 dup(26262626h),27272525h,7 dup(26262626h),27272525h,7 dup(26262626h),27272525h,7 dup(26262626h),27272525h,7 dup(26262626h),27272525h,7 dup(26262626h),27272525h,23262626h,26262623h,23232326h,26262623h,26262626h,23232323h,26262626h,27272525h,23232326h,26262424h,24242323h,26232424h,23262626h,24242423h,26262324h,27272525h,24242323h,26262424h,24242423h,24242424h,23232626h,24242424h,26242424h,27272525h,24242426h,26262424h,26262426h,24242326h,24232626h,26262424h,26242426h,27272525h,23262626h,26262424h,26262626h,24242326h,24232626h,26262624h,26242323h,27272525h,23262626h,26262424h,26262626h,24242326h,24262626h,23232424h,26242423h,27272525h,23262626h,26262424h,26262626h,24242323h,23262626h,24242424h,26262424h,27272525h,23262626h,26262424h
               dd 23262626h,26242423h,23232626h,24242424h,26242424h,27272525h,23262626h,26262424h,23232626h,26262424h,24232626h,26262624h,26242426h,27272525h,23262626h,26262424h,24232326h,26262624h,24232626h,26262624h,26242326h,27272525h,23262626h,26262424h,24242323h,26232323h,24232626h,26262624h,26242323h,27272525h,23262626h,26262424h,24242423h,24242424h,24262626h,23232424h,26242423h,27272525h,26262626h,26262424h,24242426h,24242424h,26262624h,24242424h,26262424h,27272525h,7 dup(26262626h),27272525h,7 dup(26262626h),27272525h,7 dup(26262626h),27272525h,7 dup(26262626h),27272525h,7 dup(26262626h),27272525h,7 dup(26262626h),27272525h,6 dup(26262626h),25262626h,26272525h,7 dup(25252525h),25ff2525h,7 dup(25252525h),0ff25h,2 dup(0h)
    sprite_256 dd 200020h,2cff0001h,7 dup(2c2c2c2ch),2c2cff2ch,7 dup(2c2c2c2ch),2c2c2a2bh,2b2b2b2ch,6 dup(2b2b2b2bh),2c2c2a2ah,7 dup(2b2b2b2bh),2c2c2a2ah,7 dup(2b2b2b2bh),2c2c2a2ah,7 dup(2b2b2b2bh),2c2c2a2ah,7 dup(2b2b2b2bh),2c2c2a2ah,7 dup(2b2b2b2bh),2c2c2a2ah,7 dup(2b2b2b2bh),2c2c2a2ah,7 dup(2b2b2b2bh),2c2c2a2ah,28282b2bh,2b2b2828h,282b2b2bh,28282828h,2b2b2b28h,2828282bh,2b2b2b28h,2c2c2a2ah,2928282bh,28292929h,28282b2bh,29292929h,2b2b2929h,29292828h,2b2b2929h,2c2c2a2ah,2929282bh,29292929h,29282b29h,29292929h,282b2929h,29292928h,2b292929h,2c2c2a2ah,2b292b2bh,29282b2bh,29282b29h,2b2b2b29h,28282b2bh,2b2b2929h,2b2b2b2bh,2c2c2a2ah,2b2b2b2bh,29282b2bh,29282b29h,2b2b2b29h,29282b2bh,2b2b2b29h,2b2b2b2bh,2c2c2a2ah,2b2b2b2bh,29282b2bh,29282b29h,28282829h,29282b2bh,28282829h,2b2b2828h,2c2c2a2ah,2b2b2b2bh,2928282bh,29282b29h,29292929h,29282b29h,29292929h,2b292929h,2c2c2a2ah,2b2b2b2bh,29292828h
               dd 292b2b2bh,29292929h,29282929h,2b2b2929h,2b29292bh,2c2c2a2ah,282b2b2bh,2b292928h,2b2b2b2bh,282b2b2bh,29282929h,2b2b2b29h,2929282bh,2c2c2a2ah,28282b2bh,2b2b2929h,2b2b2b2bh,282b2b2bh,29282929h,2b2b2b29h,29292828h,2c2c2a2ah,2928282bh,28282829h,2 dup(28282b2bh),292b2929h,28282829h,29292928h,2c2c2a2ah,2929282bh,29292929h,29282b29h,29282829h,2b2b2929h,29292929h,2b292929h,2c2c2a2ah,29292b2bh,29292929h,292b2929h,29292929h,2b2b2b29h,2929292bh,2b2b2929h,2c2c2a2ah,7 dup(2b2b2b2bh),2c2c2a2ah,7 dup(2b2b2b2bh),2c2c2a2ah,7 dup(2b2b2b2bh),2c2c2a2ah,7 dup(2b2b2b2bh),2c2c2a2ah,7 dup(2b2b2b2bh),2c2c2a2ah,7 dup(2b2b2b2bh),2c2c2a2ah,6 dup(2b2b2b2bh),2a2b2b2bh,2b2c2a2ah,7 dup(2a2a2a2ah),2aff2a2ah,7 dup(2a2a2a2ah),0ff2ah,2 dup(0h)
    sprite_512 dd 200020h,30ff0001h,7 dup(30303030h),3030ff30h,7 dup(30303030h),30302e31h,31313130h,6 dup(31313131h),30302e2eh,7 dup(31313131h),30302e2eh,7 dup(31313131h),30302e2eh,7 dup(31313131h),30302e2eh,7 dup(31313131h),30302e2eh,7 dup(31313131h),30302e2eh,7 dup(31313131h),30302e2eh,2d313131h,2d2d2d2dh,3131312dh,312d2d31h,2d313131h,312d2d2dh,31313131h,30302e2eh,2d2d3131h,2f2f2f2fh,31312f2fh,2f2f2d2dh,2d2d3131h,2f2f2f2fh,3131312dh,30302e2eh,2f2d3131h,2f2f2f2fh,2d302f2fh,2f2f2f2dh,2f2d3130h,2f2f2f2fh,31312f2fh,30302e2eh,2f2d3131h,3030302fh,31303030h,2f2f2f2fh,2f313130h,2d303030h,31302f2fh,30302e2eh,2f2d3131h,31313030h,31313131h,2f2f2d31h,31313130h,2d313130h,31302f2fh,30302e2eh,2f2d3131h,2d2d2d2dh,31313131h,2f2f2d31h,31313130h,2d313131h,31302f2fh,30302e2eh,2f2d3131h,2f2f2f2fh,3131312fh,2f2f2d31h,31313130h,2d2d3131h,31302f2fh,30302e2eh,2f313131h,2f2f2f2fh,31312f2fh,2f2f2d31h,31313130h
               dd 2f2d2d31h,3130302fh,30302e2eh,31313131h,2d303030h,31302f2fh,2f2f2d31h,31313130h,2f2f2d2dh,31313030h,30302e2eh,31313131h,2d313131h,31302f2fh,2f2f2d31h,2d313130h,302f2f2dh,31313130h,30302e2eh,2 dup(2d2d3131h),31302f2fh,2f2f2d31h,2d2d3130h,2d2d2f2fh,3131312dh,30302e2eh,2f2d3131h,2f2d2d2fh,31302f2fh,2f2f2d31h,2f2d3130h,2f2f2f2fh,31312f2fh,30302e2eh,2f313131h,2f2f2f2fh,3130302fh,2f2f3131h,2f313130h,2f2f2f2fh,312f2f2fh,30302e2eh,31313131h,30303030h,31313030h,30313131h,31313130h,2 dup(30303030h),30302e2eh,7 dup(31313131h),30302e2eh,7 dup(31313131h),30302e2eh,7 dup(31313131h),30302e2eh,7 dup(31313131h),30302e2eh,7 dup(31313131h),30302e2eh,7 dup(31313131h),30302e2eh,6 dup(31313131h),2e313131h,31302e2eh,7 dup(2e2e2e2eh),2eff2e2eh,7 dup(2e2e2e2eh),0ff2eh,2 dup(0h)
    sprite_1024 dq 36ff000100200020h,3 dup(3636363636363636h),3636ff3636363636h,3 dup(3636363636363636h),3636333536363636h,3435353535353536h,3435353535353534h,3535353535343434h,3636333335353535h,3434343535353535h,3434353535353232h,3535353432323232h,3636333335353535h,3232343435353535h,3234343535323232h,3535323232323232h,3636333335353535h,3232323535353535h,3232343536323234h,3536323236363632h,3636333335353535h,3636353535353535h,3232343536323234h,3532323435353636h,3636333335353535h,3535353535353535h,3232343536323234h,3632323435353536h,3636333335353535h,3535353535353535h,3232343536323234h,3632323435353536h,3636333335353535h,3535353535353535h,3232343536323234h,3632323435353536h,3636333335353535h,3535353535353535h,3232343536323234h,3632323435353536h,3636333335353535h,3535353535353535h,3232343536323234h,3632323435353536h,3636333335353535h,3535353535353535h
                dq 3232343536323234h,3632323434353536h,3636333335353535h,3535353535353535h,3232353536323234h,3632323234343432h,3636333335353535h,3535353535353535h,3235353536323234h,3636323232323232h,3636333335353535h,3535353535353535h,3535353536323235h,3536363232323232h,3636333335353535h,3434343535353535h,3535353536363434h,3535363636363635h,3636333335353535h,3232343435353535h,3535353534323232h,3535323232343535h,3636333335353535h,3232323435353535h,3535353232323232h,3536323232343435h,3636333335353535h,3636323535353535h,3535363232343636h,3536323232323434h,3636333335353535h,3536353535353535h,3435363232343535h,3536323234323234h,3636333335353535h,3535353535353535h,3435363232343535h,3536323234323232h,3636333335353535h,3535353535353535h,3434363232343435h,3536323234363232h,3636333335353535h,3535353535353535h,3234343632323434h,3536323234363632h,3636333335353535h
                dq 3435353535353535h,3232343636323234h,3534323234343432h,3636333335353535h,3434353535353535h,3232343536363232h,3232323232323232h,3636333335353535h,3234343435353535h,3232353535363632h,3232323232323232h,3636333335353536h,3232323435353535h,3635353534343434h,3636323234363636h,3636333335353536h,3232323435353535h,3535353232323232h,3536323234353535h,3636333335353535h,3232323535353535h,3535323232323232h,3536323235353535h,3536333333353535h,3 dup(3333333333333333h),33ff333333333333h,3 dup(3333333333333333h),0ff3333333333h,2 dup(0h)
    sprite_2048 dq 3dff000100200020h,3 dup(3d3d3d3d3d3d3d3dh),3d3dff3d3d3d3d3dh,3 dup(3d3d3d3d3d3d3d3dh),3d3d383c3d3d3d3dh,3737373c3c3c3c3dh,3c3c3c3c3c3c3737h,3c3c3c3c37373737h,3d3d38383c3c3c3ch,3a3a37373c3c3c3ch,373c3c3c373a3a3ah,3c3c373a3a3a3a37h,3d3d38383c3c3c3ch,39393a373c3c3c3ch,37373c3939393939h,3c3939393939393ah,3d3d38383c3c3c3ch,3b3b393c3c3c3c3ch,3a373b393a373b3bh,3b39393b3b3b3939h,3d3d38383c3c3c3ch,3c3b3c3c3c3c3c3ch,3a373b393a373c3ch,393a373c3c3b3b39h,3d3d38383c3c3c3ch,3c3c3c3c3c3c3c3ch,3a373b393a373c3ch,393a373c3c3c3b39h,3d3d38383c3c3c3bh,3c3c3c3c3c3c3c3ch,3a373b393a37373ch,393a373c3c3c3b39h,3d3d38383c3c3c3bh,3c3c3c3c3c3c3c3ch,3a373b3b393a3737h,393a373c3c3c3b39h,3d3d38383c3c3c3bh,373c3c3c3c3c3c3ch,3a373c3b3b393a37h,393a373c3c3c3b39h,3d3d38383c3c3c3bh,37373c3c3c3c3c3ch,3a373c3c3b3b393ah,393a373c3c3c3b39h,3d3d38383c3c3c3bh,3a3737373c3c3c3ch
                dq 3a373c3c3c3b3b39h,393a37373c3c3b39h,3d3d38383c3c3c3bh,393a3a373c3c3c3ch,3a3c3c3c37373737h,39393a3737373939h,3d3d38383c3c3c3bh,39393a373c3c3c3ch,3c3c3c3939393939h,3b39393a3a3a3939h,3d3d38383c3c3c3bh,39393a3c3c3c3c3ch,3c3c393939393939h,3b3b39393939393ch,3d3d38383c3c3c3ch,3b3b3c3c3c3c3c3ch,3c3b3b3b3737373bh,3c3b373737373737h,3d3d38383c3c3c3ch,3c3c3c3c3c3c3c3ch,373c3c3a3a3a373ch,3c3a3a3a3a3a3a37h,3d3d38383c3c3c3ch,3c3c3c3c3c3c3c3ch,373c3b39393a3737h,393939393939393ah,3d3d38383c3c3c3ch,373c3c3c3c3c3c3ch,373c3b3939393a37h,393a373b3b3b393ah,3d3d38383c3c3c3bh,37373c3c3c3c3c3ch,373c3b393a37393ah,393a373c3c3b393ah,3d3d38383c3c3c3bh,3a373c3c3c3c3c3ch,373c3b393a373939h,393a37373737393ah,3d3d38383c3c3c3bh,3a37373c3c3c3c3ch,3c3c3b393a373b39h,39393a3a3a3a393ah,3d3d38383c3c3c3bh,393a37373c3c3c3ch,373c3b393a373b3bh,3b39393939393937h,3d3d38383c3c3c3bh
                dq 39393a373c3c3c3ch,37373b393a373737h,3939393b3b3b393ah,3d3d38383c3c3c3ch,39393a373c3c3c3ch,3a3739393a3a3a3ah,39393c3c3c3b3b39h,3d3d38383c3c3c3bh,39393a3c3c3c3c3ch,3a37393939393939h,3937373c3c3c3b39h,3d3d38383c3c3c3bh,3b3b3c3c3c3c3c3ch,3a3b3b393a373b3bh,393a373737373939h,3d3d38383c3c3c3ch,3c3c3c3c3c3c3c3ch,3c3c3b3939373c3ch,39393a3a3a3a3939h,3d3d38383c3c3c3bh,3c3c3c3c3c3c3c3ch,3c3c3b39393c3c3ch,3b3939393939393ch,3c3d3838383c3c3bh,3 dup(3838383838383838h),38ff383838383838h,3 dup(3838383838383838h),0ff3838383838h,2 dup(0h)
	
	; Masks
	mask_board dd 38080h,1807eh,1007e01h,17f7e01h,3 dup(0h)
	mask_boardstripes dq 1f800200108080h,5f8002003f8002h,1f61021f1f00021fh,5f00021f3f00021fh,1f21021e5f61021fh,3f21021e1f41021eh,3f61021e3f41021eh,5f41021e5f21021eh,407f0101h,2 dup(0h)
	mask_boardborder dq 5047d00148888h,6007d0405847d04h,18203038406047dh,8284030302020303h,385020283020303h,301030183830401h,103010284050301h,502010204830102h,8584010283010201h,285010186030102h,86840101h,2 dup(0h)
	
	mask_background_two dq 1205050e00191818h,60e04060206040bh,0b0b03060e080404h,10801060a0c0107h,0e0c010404110202h,1213040110060202h,0f0c010303050301h,606010212040301h,0c0a02010b110102h,60d010103110101h,0c110101090d0101h,0f0701010d090101h,11050101100c0101h,2 dup(0h)
	mask_background_four dq 30d140500141818h,90505040e040509h,0e12050304090404h,20a01070d020402h,809040106070302h,80a0301030a0103h,130c03010b040301h,5080101010d0102h,80b010108060101h,101501010c030101h,11030101h,2 dup(0h)
	mask_background_eight dq 206140300181818h,9090505020e1402h,10905040d100703h,310080212090405h,40406020e030503h,5120501020d0501h,160a01030f130301h,0c1001020c050201h,1410010213040102h,80d010103050101h,0d0401010a050101h,140501010e0d0101h,15100101h,2 dup(0h)
	mask_background_exponent dq 6090506000f1818h,0c0606040a0f0803h,0b0701050b0d0302h,80f02020d120501h,80803010c0a0401h,0f0502010e0e0201h,0a070101070f0101h,101301010c0b0101h,2 dup(0h)
	mask_background_plus dd 30c0ch,40c04h,4000404h,4080404h,3 dup(0h)
	mask_background_wtf dq 310090500171818h,708040503020409h,0a04040411100405h,0c11030311040404h,40104010b080302h,0b030401050b0202h,1011010310040103h,0b0a010211030301h,0e0401020c100201h,9070101040b0101h,120801010c0a0101h,1512010115050101h,2 dup(0h)
	mask_background_shmulik dq 70f0d0400351850h,7450d0407390d04h,0a3f0a040a210a04h,0a2d08040b1b0904h,0a3409030c270804h,110403070b160903h,0a03030407050306h,0d0602060c4a0602h,122f02050a250205h,0f09020405400402h,0a130203124b0204h,0a1c01050a4b0203h,60f01030d490401h,645010306390103h,0c070103080b0301h,63f020110030301h,804020106420201h,0b1f01020a160102h,0d0401020c4c0102h,110b0102104c0201h,903010113340102h,91f010109140101h,0b4e010109260101h,0d4c01010c150101h,113101010e0c0101h,114d010111330101h,122e0101120b0101h,2 dup(0h)
	mask_background_smiley dq 10080208000e1818h,70f040207080402h,0e1103020d050302h,0e0703010d130202h,0f0f01020c040102h,0f0801010d040101h,100601010f130101h,10100101h,2 dup(0h)


	;   ____                        _                _      
	;  / ___| __ _ _ __ ___   ___  | |    ___   __ _(_) ___ 
	; | |  _ / _` | '_ ` _ \ / _ \ | |   / _ \ / _` | |/ __|
	; | |_| | (_| | | | | | |  __/ | |__| (_) | (_| | | (__ 
	;  \____|\__,_|_| |_| |_|\___| |_____\___/ \__, |_|\___|
	;                                          |___/        
	
	listID_board dw nullword
	listID_boardAvailable dw nullword
	listID_boardMerged dw nullword
	listOffset_board dw nullword
	listOffset_boardMerged dw nullword

	game_boardOffset dw nullword
	game_rendercycles dw 0
	game_mode dw gamemodePlaying
	game_loseTimer dw nullword
	game_score dw 0
	

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

proc NumberClamp ;takes a number and a max number and caps it off a minimum and maximum.
	; parameters:
	; - VALUE: input number
	; - VALUE: minimum number
    ; - VALUE: maximum number
	; returns:
	; - VALUE: capped number
	push bp
	mov bp, sp
	push ax

	inputNumber equ [word ptr bp + 8]
	minimumNumber equ [word ptr bp + 6]
	maximumNumber equ [word ptr bp + 4]

    mov ax, inputNumber
    cmp ax, maximumNumber
    jb NumberClamp_DontClamp1
        mov ax, maximumNumber
    NumberClamp_DontClamp1:
    cmp ax, minimumNumber
    ja NumberClamp_DontClamp2
        mov ax, minimumNumber
    NumberClamp_DontClamp2:
    mov inputNumber, ax

	pop ax
	pop bp
	ret 4
endp NumberClamp

proc NumberMin ;returns the lower value between 2 values
	; parameters:
	; - VALUE: Value1
	; - VALUE: Value2
	; returns:
	; - VALUE: Minimum
	push bp
	mov bp, sp
	push ax
	value1 equ [word ptr bp + 6]
	value2 equ [word ptr bp + 4]
    mov ax, value2
	cmp ax, value1
	ja NumberMin_Skip
    	mov value1, ax
	NumberMin_Skip:
	pop ax
	pop bp
	ret 2
endp NumberMin

proc NumberMax ;returns the larger value between 2 values
	; parameters:
	; - VALUE: Value1
	; - VALUE: Value2
	; returns:
	; - VALUE: Maximum
	push bp
	mov bp, sp
	push ax
	value1 equ [word ptr bp + 6]
	value2 equ [word ptr bp + 4]
    mov ax, value2
	cmp ax, value1
	jb NumberMax_Skip
    	mov value1, ax
	NumberMax_Skip:
	pop ax
	pop bp
	ret 2
endp NumberMax

proc NumberMod ;takes a number and a divisor and returns the modulo.
    ; formula: ((n - min) % max) + min
	; parameters:
	; - VALUE: input number
	; - VALUE: divisor
	; returns:
	; - VALUE: modulo'd number
	push bp
	mov bp, sp
	push ax dx

	inputNumber equ [word ptr bp + 6]
	divisor equ [word ptr bp + 4]

    mov ax, inputNumber
    mov dx, 0
    idiv divisor
    mov inputNumber, dx

	pop dx ax
	pop bp
	ret 2
endp NumberMod

proc NumberRandom ;takes a min & max, returns a random number
    ; formula: ((clock * internal_primes[internal_primeCounter])%(max-min))+min
	; parameters:
	; - VALUE: min
	; - VALUE: max
	; returns:
	; - VALUE: random number
	push bp
	mov bp, sp
	push ax bx cx dx es

	min equ [word ptr bp + 6]
	max equ [word ptr bp + 4]

	mov ax, 40h
	mov es, ax
	mov ax, [word ptr es:6Ch]
	mov bx, offset internal_primes
	add bx, [word ptr internal_primeCounter]
	mul [word ptr bx]
	add ax, dx
	mov dx, 0
	mov bx, max
	sub bx, min
	div bx
	add min, dx
	
	inc [word ptr internal_primeCounter]
	cmp [word ptr internal_primeCounter], 200
	jb NumberRandom_DontResetinternal_primeCounter
		mov [word ptr internal_primeCounter], 0
	NumberRandom_DontResetinternal_primeCounter:

	pop es dx cx bx ax
	pop bp
	ret 2
endp NumberRandom

proc ListCreate ;Creates a list to the allocation
	; Parameters:
	; - Element Length
	; - Element Allocation Length
	; Returns:
	; - List ID
	push bp
	mov bp, sp
	push ax bx cx dx di si

	elementLength equ [word ptr bp + 6]
	elementAllocationLength equ [word ptr bp + 4]

	; Get list memory length
	mov ax, elementLength
	mov dx, 0
	mul elementAllocationLength
	mov si, [word ptr lists_offset]
	add [word ptr lists_offset], ax ;we do this little double thing so that lists_offsets gets permanently added to.


	; Get lists amount
	mov bx, [word ptr lists_amount]
	shl bx, 3 ;every list info is 8 bytes exactly
	add bx, offset lists_info ;this is now the list's info offset
	mov [word ptr bx], si ;move the allocation offset first things first
	mov cx, elementLength
	mov [word ptr bx + 2], cx ;move the element length
	mov cx, elementAllocationLength
	mov [word ptr bx + 4], cx ;move the element allocation length
	mov [word ptr bx + 6], 0 ;move the count, which is a 0

	; We do this little trickery to return the ID of the newly created list.
	mov ax, [word ptr lists_amount]
	mov elementLength, ax
	inc [word ptr lists_amount]

	pop si di dx cx bx ax
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
	add bx, offset lists_info ;this is now the list's info offset

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
	add bx, offset lists_info ;this is now the list's info offset

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
	ret 6
endp ListSet

proc ListClear ;Clears a list
	; Parameters:
	; - List ID
	push bp
	mov bp, sp
	push ax
	xor ah, ah
	mov al, nullbyte
	push [word ptr bp + 4]
	push ax
	call ListSetAll

	pop ax bp
	ret 2
endp ListClear

proc ListSetAll ;Sets all the list values to a given byte.
	; Parameters: List ID, Byte to set (lower half)
	push bp
	mov bp, sp
	push ax bx cx dx di si es

	mov ax, ds
	mov es, ax

	listID equ [word ptr bp + 6]
	setByte equ [word ptr bp + 4]

	; Get list info offset
	mov bx, listID
	shl bx, 3 ;every list info is 8 bytes exactly
	add bx, offset lists_info ;this is now the list's info offset

	mov [word ptr bx+6], 0 ; Set the count of the list to 0
	; Move the offset of the list
	mov di, [word ptr bx]
	; Get the element length
	mov ax, [word ptr bx+2]
	mov dx, 0
	mov si, [word ptr bx+4] ;Save the element *length*, this'll serve as the index
	mul si ;Multiply it by the index
	mov cx, ax ; CX = ElementLength * Count
	mov ax, setByte
	cmp cx, 0
	jz ListSetAll_NoLoop
	rep stosb ;mov es:[di], al
	ListSetAll_NoLoop:

	pop es si di dx cx bx ax
	pop bp
	ret 4
endp ListSetAll

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
	add bx, offset lists_info ;this is now the list's info offset

	; Get the list count, this'll serve as an index.
	mov cx, [word ptr bx+6]
	inc [word ptr bx+6] ;Increase the index
	push listID
	push elementReference
	push cx ;Index
	call ListSet

	pop cx bx
	pop bp
	ret 4
endp ListAdd

proc ListGetAdd ;Gets the offset of the first null element in a list
	; Parameters:
	; - List ID
	; Returns:
	; - Element Offset
	push bp
	mov bp, sp
	push bx cx

	listID equ [word ptr bp + 4]

	; Get list info offset
	mov bx, listID
	shl bx, 3 ;every list info is 8 bytes exactly
	add bx, offset lists_info ;this is now the list's info offset

	; Get the list count, this'll serve as an index.
	mov cx, [word ptr bx+6]
	inc [word ptr bx+6] ;Increase the index
	push listID
	push cx ;Index
	call ListGet
	pop listID

	pop cx bx
	pop bp
	ret
endp ListGetAdd

proc ListRetrieve ;Returns an element from a list via an index
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
	add bx, offset lists_info ;this is now the list's info offset

	; Move the offset of the list
	mov di, [word ptr bx]
	; Get the element length
	mov ax, [word ptr bx+2]
	mov cx, ax ;Save it in cx before multiplying

	mul index ;Multiply it by the index
	add di, ax ;DI = ListOffset + (ElementLength * Index) = ListElementReferenceOffset
	mov si, elementReference ;SI = ElementReferenceOffset

	ListRetrieve_Loop: ;Setting byte by byte, because i'm an idiot and terribly scared of movsb
		mov dl, [byte ptr di]
		mov [byte ptr si], dl
		inc di
		inc si
	loop ListRetrieve_Loop


	pop si di dx cx bx ax
	pop bp
	ret 6
endp ListRetrieve

proc ListGet ;Returns the offset of a list's element via an index
	; Parameters:
	; - List ID
	; - Index
	; Returns:
	; - Element Offset
	push bp
	mov bp, sp
	push ax bx dx di

	listID equ [word ptr bp + 6]
	index equ [word ptr bp + 4]

	; Get list info offset
	mov bx, listID
	shl bx, 3 ;every list info is 8 bytes exactly
	add bx, offset lists_info ;this is now the list's info offset
	
	; Move the offset of the list
	mov di, [word ptr bx]
	cmp index, 0
	je ListGet_JustListOffset
	; Get the element length
	mov ax, [word ptr bx+2]
	mul index ;Multiply it by the index
	add di, ax ;DI = ListOffset + (ElementLength * Index) = ListElementReferenceOffset

	ListGet_JustListOffset:
	mov listID, di

	pop di dx bx ax
	pop bp
	ret 2
endp ListGet

proc ListForeach ;Runs through every element in a list, with a callback functin
	; Info:
	; The callback offset should be a label, make sure to ret at the end of it and push used registers.
	; DI register is set to the offset of the list element.
	; CX register is set to the loop iterations left.
	; AX register is set to the list's element length.
	; ---
	; Parameters: List ID, Callback Offset, ?Run Through Nulls
	push bp
	mov bp, sp
	push ax bx cx dx di si

	listID equ [word ptr bp + 8]
	callbackOffset equ [word ptr bp + 6]
	runThroughLength equ [word ptr bp + 4]

	; Get list info offset
	mov bx, listID
	shl bx, 3 ;every list info is 8 bytes exactly
	add bx, offset lists_info ;this is now the list's info offset

	; Move the offset of the list
	mov di, [word ptr bx]
	; Get the element length
	mov ax, [word ptr bx+2]
	; Get the list count
	mov cx, [word ptr bx+6]
	cmp runThroughLength, boolTrue
	jnz ListForeach_LengthCheck
		; Get the list length instead
		mov cx, [word ptr bx+4]
	ListForeach_LengthCheck:
		cmp cx, 0
		jz ListForeach_Empty
	ListForeach_Loop:
		call callbackOffset
		add di, ax
		loop ListForeach_Loop
	ListForeach_Empty:
	pop si di dx cx bx ax
	pop bp
	ret 6
endp ListForeach

proc ListRemove ;Removes an element from a list via index, and collapses it.
	; Parameters:
	; - List ID
	; - Index
	push bp
	mov bp, sp
	push ax bx cx dx di si

	listID equ [word ptr bp + 6]
	index equ [word ptr bp + 4]
	
	; Get list info offset
	mov bx, listID
	shl bx, 3 ;every list info is 8 bytes exactly
	add bx, offset lists_info ;this is now the list's info offset

	mov cx, [word ptr bx+6]

	cmp index, cx ;Make sure index is within list bounds, this also makes sure list count has to be >0
	jae ListRemove_Fail

	; Move the offset of the list
	mov di, [word ptr bx]
	; Get the element length
	mov ax, [word ptr bx+2]

	; Decrease the element count, then get it
	dec [word ptr bx+6]
	dec cx

	mov bx, ax ;Save element length in bx

	mul index ;Multiply it by the index
	add di, ax ;DI = ListOffset + (ElementLength * Index) = ListElementReferenceOffset
	mov si, di
	add si, bx ;SI = ListGet(Index+1)

	sub cx, index ;cx = element count - index - 1
	ListRemove_Loop:
		push cx ;nested loop
		mov cx, bx ; cx = element length
		ListRemove_LoopCopyByte:
			mov al, [byte ptr si]
			mov [byte ptr di], al ;Copy the index+1 element to index
			inc di
			inc si
			loop ListRemove_LoopCopyByte
		pop cx
		loop ListRemove_Loop
		
	mov cx, bx
	ListRemove_LoopDeleteByte:
		mov [byte ptr di], nullbyte ;Copy the index+1 element to index
		inc di
		loop ListRemove_LoopDeleteByte

	ListRemove_Fail:
	pop si di dx cx bx ax
	pop bp
	ret 4
endp ListRemove

proc ListSetCount
	; Info: Sets the list's count, doesn't clear null elements. if 'Count' is null, will set list's count to max.
	; Parameters: List ID, Count

    push bp
    mov bp, sp
    push ax bx cx dx di si
    listID equ [word ptr bp + 6]
    count equ [word ptr bp + 4]
	
	mov bx, listID
	shl bx, 3 ;every list info is 8 bytes exactly
	add bx, offset lists_info ;this is now the list's info offset

	mov cx, count ;cx is the intended count.
	cmp cx, nullword ;if cx is null, set it to list length
	jne ListSetCount_NormalLength
		mov cx, [word ptr bx+4] ;set the count to the list's length, aka its max
	ListSetCount_NormalLength:

	push cx
	push 0
	push count
	call NumberClamp ;clamp count to normal numbers.
	pop [word ptr bx+6] ;finally, set the list's count to cx.

    
    pop si di dx cx bx ax
    pop bp
	ret 4
endp ListSetCount



proc BufferClear ;clears the screen buffer
	push ax bx cx di es
	mov ax, ScreenBuffer
	mov es, ax ;ES is now at the screen buffer
	xor di, di
	mov cx, 32000
	xor ax, ax
	rep stosw
	pop es di cx bx ax
	ret
endp BufferClear

proc BufferRender
	; Info: Renders the Screen Buffer onto the video memory.
	push ax cx di ds si es

	mov ax, ScreenBuffer
	mov ds, ax ; DS is now at the screen buffer
	mov di, 0

	mov ax, 0A000h
	mov es, ax ; ES is now at the video memory
	mov si, 0

	mov cx, (320*200) ;We wanna iterate 64k times for every pixel

	rep movsb ;This does that shit

	pop es si ds di cx ax
	ret
endp BufferRender

proc RenderScreen
	; Info: Renders the game's objects onto the screen.
	push ax bx cx dx si
	call BufferClear
	
	call RenderParticles
	call RenderBoard
	call RenderBlocks

	inc [word ptr game_rendercycles]
	pop si dx cx bx ax
	ret
endp RenderScreen

proc RenderBoard
	; Info: Renders the board onto the buffer. Not including blocks.
	push ax bx
	
	push offset mask_board
	push 3
	push 0
	push 0
	push boolTrue
	call BufferMaskCenter
	
	push offset mask_boardstripes
	push 2
	push 0
	push 0
	push boolTrue
	call BufferMaskCenter
	
	push offset mask_boardborder
	push 4
	push 0
	push 0
	push boolTrue
	call BufferMaskCenter

	pop bx ax
	ret
endp RenderBoard

proc RenderBlocks
	; Info: Renders the game blocks onto the buffer.
	push ax bx cx dx di si
	mov cx, 16 ;Iterations
	mov ax, 96 ;X
	mov dx, 36 ;Y
	xor bx, bx ;Row Counter
	
	
	push [word ptr listID_board] ;board list
	push bx ;we want just the offset, bx is already 0.
	call ListGet
	pop di ; List offset is here

	RenderBlocks_Loop:

		cmp [word ptr di], nullword
		je RenderBlocks_DontRender
			mov si, [word ptr di]
			shl si, 1 ;Multiply the type by 2, because each offset is a word.
			add si, offset internal_blockSpriteOffsets
			push [word ptr si]
			push ax
			push dx
			call BufferSprite
		RenderBlocks_DontRender:

		inc bl
		add ax, 32
		add di, 2
		cmp bl, 4
		jnz RenderBlocks_SkipNewRow
			sub ax, (32*4) ;Subtract the previous 4, to go back to the start of the row
			add dx, 32 ;Go to the new row
			xor bl, bl
		RenderBlocks_SkipNewRow:
		loop RenderBlocks_Loop
	
	

	pop si di dx cx bx ax
	ret
endp RenderBlocks


proc RenderParticles
	; Info: Renders the particles to the screen buffer.
	push dx di si bx
	
	push [word ptr listID_particles] ; List ID
	push offset RenderParticles_Foreach
	push boolFalse
	call ListForeach
	jmp RenderParticles_ForeachExit
	RenderParticles_Foreach:
		push [word ptr game_rendercycles]
		push [word ptr di+6] ;checking the divisor
		call NumberMod
		pop si
		cmp si, 0
		jne RenderParticles_ForeachContinue
			cmp [word ptr game_mode], gamemodePlaying
			jne RenderParticles_DontMove
				inc [word ptr di]
				inc [word ptr di+2]
			RenderParticles_DontMove:
			cmp [word ptr di], 320 ;X border detection
			jl RenderParticles_DontWrapX
				sub [word ptr di], (320+100)
				jmp RenderParticles_NewStats
			RenderParticles_DontWrapX:
			cmp [word ptr di+2], 200 ;Y border detection
			jl RenderParticles_ForeachContinue
				sub [word ptr di+2], (200+100)
			RenderParticles_NewStats: ;New stats for the particle when it gets teleported
				push 0
				push 16
				call NumberRandom
				pop si
				mov [word ptr di + 4], si ; Type (0-2)
				push 30
				push 80
				call NumberRandom
				pop si
				mov [word ptr di + 6], si ; Render Cycles per Move (5-20)
		RenderParticles_ForeachContinue:
		mov bx, [word ptr di+4]
		shl bx, 1
		push [word ptr internal_backgroundMaskOffsets+bx] ;mask
		push 1 ;color
		push [word ptr di] ;x
		push [word ptr di+2] ;y
		call BufferMask
		ret
	RenderParticles_ForeachExit:

	pop bx si di dx
	ret
endp RenderParticles


proc BufferRect
	; Info: Renders a rectangle with a color (byte, lower half) onto the buffer.
	; Parameters: Color, Width, Height, Top Left X, Top Left Y
    push bp
    mov bp, sp
    push ax bx cx dx di si es
    color equ [word ptr bp + 12]
    rectWidth equ [word ptr bp + 10]
    rectHeight equ [word ptr bp + 8]
    topLeftX equ [word ptr bp + 6]
    topLeftY equ [word ptr bp + 4]

	mov ax, ScreenBuffer 
	mov es, ax ;Switch ES to the screen buffer.
    
	; Wrap Case - Fix Negative Top Left Coordinates
	mov ax, topLeftX
	cmp ax, 0
	jge BufferRect_WrapCaseX
		add rectWidth, ax
		mov topLeftX, 0
	BufferRect_WrapCaseX:

	mov ax, topLeftY
	cmp ax, 0
	jge BufferRect_WrapCaseY
		add rectHeight, ax
		mov topLeftY, 0
	BufferRect_WrapCaseY:

	; Clamp Case - Fix Width/Height Overflowing
	mov ax, 320
	sub ax, topLeftX
	cmp rectWidth, ax
	jle BufferRect_ClampCaseX
		mov rectWidth, ax
	BufferRect_ClampCaseX:
	
	mov ax, 200
	sub ax, topLeftY
	cmp rectHeight, ax
	jle BufferRect_ClampCaseY
		mov rectHeight, ax
	BufferRect_ClampCaseY:
    
	; Dead Case: Negative / Zero Width/Height
	cmp rectWidth, 0
	jle BufferRect_DeadCase
	cmp rectHeight, 0
	jle BufferRect_DeadCase

	; Full Case - Drawing the rect in its entirety.
	mov ax, 320
	imul topLeftY
	add ax, topLeftX
	mov di, ax ; DI = (320*y) + x
	mov bx, 320
	sub bx, rectWidth ; BX = 320 - Width
	
	mov ax, color ;we'll be using AL from now on
	mov cx, rectHeight

	BufferRect_RowLoop:
		push cx
		mov cx, rectWidth
		rep stosb
		add di, bx ;DI = DI + 320 - Width
		pop cx
		loop BufferRect_RowLoop

	BufferRect_DeadCase:
    pop es si di dx cx bx ax
    pop bp
	ret 10
endp BufferRect


proc BufferMask
	; Info: Renders a mask, which is a collection of rects.
	; Parameters: Mask Offset, Color, TopLeftX, TopLeftY
    push bp
    mov bp, sp
    push ax bx cx dx di si
    maskOffset equ [word ptr bp + 10]
    color equ [word ptr bp + 8]
    topLeftX equ [word ptr bp + 6]
    topLeftY equ [word ptr bp + 4]
	mov di, maskOffset
	xor bx, bx
	mov bl, [byte ptr di] ;width
	add bx, topLeftX ; BX = X + Width
	cmp bx, 0
	jl BufferMask_SkipRender
	
	xor bh, bh
	mov bl, [byte ptr di + 1] ;height
	add bx, topLeftY ; BX = X + Width

	cmp bx, 0
	jl BufferMask_SkipRender

	cmp topLeftX, 320
	jge BufferMask_SkipRender
	
	cmp topLeftY, 200
	jge BufferMask_SkipRender

	mov cx, [word ptr di+2] ;Total Rects
	add di, 4
	xor ax, ax
	BufferMask_RectLoop:
		push color ;Rect Color

		mov al, [byte ptr di] ; Rect Width
		push ax
		mov al, [byte ptr di+1] ; Rect Height
		push ax

		mov al, [byte ptr di+2] ; X Offset
		add ax, topLeftX
		push ax
		xor ah, ah ; Reset the top part of AX

		mov al, [byte ptr di+3] ; Y Offset
		add ax, topLeftY
		push ax
		xor ah, ah ; Reset the top part of AX

		call BufferRect

		add di, 4
		loop BufferMask_RectLoop
	BufferMask_SkipRender:
    
    pop si di dx cx bx ax
    pop bp
	ret 8
endp BufferMask


proc BufferMaskCenter
	; Info: Renders a mask from its center. RelativeScreenPoint will make the coordinates 0,0 the screen's center.
	; Parameters: Mask Offset, Color, X Position, Y Position, ?RelativeToScreenCenter
	push bp
	mov bp, sp
	push ax bx cx dx di si
	maskOffset equ [word ptr bp + 12]
	color equ [word ptr bp + 10]
	xPosition equ [word ptr bp + 8]
	yPosition equ [word ptr bp + 6]
	relativeToScreenCenter equ [word ptr bp + 4]
	
	mov bx, maskOffset
	xor ax, ax
	; Calculate the top left X
	mov al, [byte ptr bx] ;AX = Mask Width
	shr al, 1 ;Divide AX by 2
	sub xPosition, ax ; xPosition -= (MaskWidth/2)
	mov al, [byte ptr bx+1] ;AX = Mask Height
	shr al, 1 ;Divide AX by 2
	sub yPosition, ax ; yPosition -= (MaskHeight/2)
	cmp relativeToScreenCenter, boolTrue
	jne BufferMaskCenter_RelativeToTopLeft
		add xPosition, 160
		add yPosition, 100
	BufferMaskCenter_RelativeToTopLeft:

	push maskOffset
	push color
	push xPosition
	push yPosition
	call BufferMask

	pop si di dx cx bx ax
	pop bp
	ret 10
endp BufferMaskCenter

proc BufferSprite
	; Info: Renders a sprite onto the buffer.
	; Parameters: Sprite Offset, Top Left X, Top Left Y
	push bp
	mov bp, sp
	sub sp, 4 ;Allocate some space for temporary variables
	push ax bx cx dx di es si

	spriteOffset equ [word ptr bp + 8]
	topLeftX equ [word ptr bp + 6]
	topLeftY equ [word ptr bp + 4]
	spriteWidth equ [word ptr bp - 2]
	spriteHeight equ [word ptr bp - 4]

	mov ax, topLeftY
	mov dx, 320
	imul dx
	add ax, topLeftX
	mov si, ax ;SI = (topLeftY * 320) + topLeftX

	mov ax, ScreenBuffer
	mov es, ax ; ES is now at the screen buffer

	mov di, spriteOffset

	mov cx, [word ptr di]
	mov spriteWidth, cx
	mov cx, [word ptr di+2]
	mov spriteHeight, cx
	mov cx, [word ptr di+4] ; CX = Sprite Type (Default, Transparency)

	add di, 6
	cmp cx, 1
	je BufferSprite_SafeVersion

	cmp topLeftX, 0
	jl BufferSprite_SafeVersion ;Safe buffer if X < 0
	
	mov ax, spriteWidth
	add ax, topLeftX
	cmp ax, 320
	jge BufferSprite_SafeVersion ;Safe buffer if Width < 320-x

	cmp topLeftY, 0
	jl BufferSprite_SafeVersion ;Safe buffer if Y < 0
	
	mov ax, spriteHeight
	add ax, topLeftY
	cmp ax, 200
	jge BufferSprite_SafeVersion ;Safe buffer if Height < 200-x
		; Unsafe Buffer, Faster but only works when full sprite is in frame.
		xor si, di
		xor di, si
		xor si, di ;XOR swapping SI and DI, since they work weirdly in movsb (DS:SI to ES:DI)
		mov bx, 320
		sub bx, spriteWidth ; BX = 320 - Width
		mov cx, spriteHeight
		BufferSprite_UnsafeRowLoop:
			push cx
			mov cx, spriteWidth
			rep movsb
			add di, bx ;DI = DI + 320 - Width
			pop cx
			loop BufferSprite_UnsafeRowLoop
		jmp BufferSprite_Exit ;quit early as to not buffer the safe way too

	BufferSprite_SafeVersion:


	mov cx, 0
	mov bx, 0
	BufferSprite_SetLoop:
		
		mov al, [byte ptr di]
		cmp al, nullbyte
		jz BufferSprite_SkipDraw
		
		mov dx, cx ;Whole DX part is for detecting if this sprite's width is overflowing
		add dx, topLeftX
		cmp dx, 320
		jge BufferSprite_SkipDraw
		cmp dx, 0
		jl BufferSprite_SkipDraw

		mov dx, bx ;Whole DX part is for detecting if this sprite's height is overflowing
		add dx, topLeftY
		cmp dx, 200
		jge BufferSprite_SkipDraw
		cmp dx, 0
		jl BufferSprite_SkipDraw

			mov [byte ptr es:si], al
			;dec [byte ptr es:si]
		BufferSprite_SkipDraw:

		inc si ;increase the screen offset
		inc di ;increase the sprite offset pointer
		inc cx ;just some row detection, cx being width and dx being height


		cmp cx, spriteWidth
		jl BufferSprite_AddWidth
			sub si, cx ;Take away the X si travelled, which is cx or spritewidth doesn't matter they're equal here
			add si, 320 ;Add a row to si
			mov cx, 0
			inc bx
			;cmp dx, 0
			;jl BufferSprite_Exit

			cmp bx, spriteHeight
			jl BufferSprite_SetLoop
			jmp BufferSprite_Exit
		BufferSprite_AddWidth:
		jmp BufferSprite_SetLoop
	BufferSprite_Exit:

	pop si es di dx cx bx ax
	add sp, 4
	pop bp
	ret 6
endp BufferSprite

proc BufferSpriteCenter
	; Info: Renders a sprite to the buffer, anchored from its middle point. RelativeToScreenCenter will make the coordinates 0,0 the center of the screen.
	; Parameters: Sprite Offset, X Position, Y Position, ?RelativeToScreenCenter
	push bp
	mov bp, sp
	push ax bx cx dx di si
	spriteOffset equ [word ptr bp + 10]
	xPosition equ [word ptr bp + 8]
	yPosition equ [word ptr bp + 6]
	relativeToScreenCenter equ [word ptr bp + 4]
	
	mov bx, spriteOffset
	; Calculate the top left X
	mov ax, [bx] ;AX = Sprite Width
	shr ax, 1 ;Divide AX by 2
	sub xPosition, ax ; xPosition -= (SpriteWidth/2)
	mov ax, [bx+2] ;AX = Sprite Height
	shr ax, 1 ;Divide AX by 2
	sub yPosition, ax ; yPosition -= (SpriteHeight/2)
	cmp relativeToScreenCenter, boolTrue
	jne BufferSpriteCenter_RelativeToTopLeft
		add xPosition, 160
		add yPosition, 100
	BufferSpriteCenter_RelativeToTopLeft:

	push spriteOffset
	push xPosition
	push yPosition
	call BufferSprite

	pop si di dx cx bx ax
	pop bp
	ret 8
endp BufferSpriteCenter

proc GameUpdateLoop
	; Info: Called every frame render.
	push ax bx cx dx di si
	cmp [word ptr game_mode], gamemodeDead ; are we dead boys
	jne GameUpdateLoop_NotDead ;naah
		inc [word ptr game_loseTimer]
		cmp [word ptr game_loseTimer], constant_framesToShowGameOver
		jne GameUpdateLoop_DontShowGameOver
			; show the game over screen here
			mov [word ptr game_loseTimer], nullword
		GameUpdateLoop_DontShowGameOver:
	GameUpdateLoop_NotDead:
	pop si di dx cx bx ax
	ret
endp GameUpdateLoop

proc GameSpawnBlock
	; Info: Spawns a game tile into the board list at a random null position.
	; Parameters: Tile Type
	push bp
	mov bp, sp
	push ax bx cx dx di si
	tileType equ [word ptr bp + 4]
	
	push [word ptr listID_boardAvailable]
	call ListClear

	push [word ptr listID_board]
	push offset GameSpawnBlock_boardForeach
	push boolTrue
	call ListForeach ;Foreach on list 'board'
	jmp GameSpawnBlock_boardForeachExit
	GameSpawnBlock_boardForeach:
		;DI = offset, CX = iterations left, AX = list element's length
		cmp [word ptr di], nullword
		jne GameSpawnBlock_NotNullSkip
			push [word ptr listID_boardAvailable] ; List ID
			call ListGetAdd ;Like list add but returns the offset
			pop bx ;We now got the add position
			mov [word ptr bx], 16
			sub [word ptr bx], cx ; Element = listIndex
		GameSpawnBlock_NotNullSkip:
		ret
	GameSpawnBlock_boardForeachExit:
	;jmp skiptest
	FinallyDecide:
	push [word ptr listID_boardAvailable]
	call ListCount
	pop bx
	; If bx = 0, no available spots, this would mean check for lose.
	; this also means i can't spawn any block, so i'll have to skip that.
	cmp bx, 0
	je GameSpawnBlock_CantSpawn

	push 0
	push bx ; List Count
	call NumberRandom
	pop si ; si = index

	push [word ptr listID_boardAvailable]
	push si
	call ListGet
	pop si
	

	push [word ptr listID_board]
	push [word ptr si]
	call ListGet
	pop bx

	mov ax, tileType
	mov [word ptr bx], ax

	GameSpawnBlock_CantSpawn:
	pop si di dx cx bx ax
	pop bp
	ret 2
endp GameSpawnBlock

proc GameSetBlock
	; Info: Spawns a game tile into the board list.
	; Parameters: Tile Type, Tile Index
	push bp
	mov bp, sp
	push ax bx
	tileType equ [word ptr bp + 6]
	tileIndex equ [word ptr bp + 4]
	
	push [word ptr listID_board]
	push tileIndex
	call ListGet
	pop bx
	mov ax, tileType
	mov [word ptr bx], ax


	pop bx ax
	pop bp
	ret 4
endp GameSetBlock

proc GameMove
	; Info: Moves the game board in a direction, and when two of the same type hit, calls the merging function.
	; Parameters: Direction (0-3)
    push bp
    mov bp, sp
    push ax bx cx dx di si
    direction equ [word ptr bp + 4]

	push [word ptr listID_boardMerged]
	push boolFalse
	call ListSetAll

	xor ax, ax
	mov cx, 4
	GameMove_LinesLoop:
		push direction
		push ax ; ax is the line index, X
		call GameCollapseLine
		inc ax
		loop GameMove_LinesLoop
	
	push 0
	call GameSpawnBlock
	call GameCheckLose


    pop si di dx cx bx ax
    pop bp
	ret 2
endp GameMove

proc GameCollapseLine
	; Info: Collapses a line of blocks in the game board.
	; Parameters: Direction, Line Index
    push bp
    mov bp, sp
	sub sp, 2
    push ax bx cx dx di si
    direction equ [word ptr bp + 6]
    lineIndex equ [word ptr bp + 4]
	originalBlockOffset equ [word ptr bp - 2]

    
	; LineIndex = X = AX
	mov ax, lineIndex
	xor bx, bx ;Y = 0

	mov cx, 4
	GameCollapseLine_CheckBlockLoop: ;run through the column
		push direction
		call GameCalculateBoardOffset ; sets index to si
		mov dx, [word ptr si] ; DX is now the block type
		cmp dx, nullword
		je GameCollapseLine_CheckBlockSkip
			; Actual block
			mov originalBlockOffset, si ; originalBlockOffset is now set to BlockIndex+BoardListOffset
			push bx
			GameCollapseLine_CollapseBlock:
				; Looping through to collapse the block
				cmp bx, 0
				je GameCollapseLine_BlockSettle ; If block reaches the top wall, settle.
				dec bx
				push direction
				call GameCalculateBoardIndex
				mov di, si ;Save DI as a copy of the index
				add di, [word ptr listOffset_boardMerged]
				shl si, 1 ; Every block is 2 bytes
				add si, [word ptr listOffset_board] ; SI is now the offset of the soon-to-be block
				cmp [word ptr si], nullword ; Compare newblock tp air, if so, jump
				je GameCollapseLine_CollapseBlock ; If it's air, go back to collapsing
				cmp [byte ptr di], boolTrue ; Check if it's already merged, using the merged board hash
				je GameCollapseLine_BlockHitSettle ; Hit a block that was already merged.
				cmp [si], dx ; Compare newblock to old block
				je GameCollapseLine_BlockMerge ; If newblock type = oldblock type, merge
				; Naturally go to BlockHitSettle, because newblock hit a block that doesn't share the same type

			GameCollapseLine_BlockHitSettle: ; When a block hits another block, but doesn't merge. activates before BlockSettle.
				inc bx ; Increase the Y, so it doesn't collapse ON the block it hit.
			GameCollapseLine_BlockSettle: ;When a block settles.
				mov si, originalBlockOffset
				mov [word ptr si], nullword ;Delete the old block
				push direction
				call GameCalculateBoardIndex ; SI = Index, per (AX,BX)
				shl si, 1 ; Every block is 2 bytes
				add si, [word ptr listOffset_board] ; SI is now the offset of the soon-to-be block
				mov [word ptr si], dx ; Set the new block to the type of the old block.
				jmp GameCollapseLine_CollapseFinished ; Make sure we don't accidentally merge
			GameCollapseLine_BlockMerge:  ;When a block merges with another block.
				mov si, originalBlockOffset
				mov [word ptr si], nullword ; Delete the old block
				push direction
				call GameCalculateBoardIndex ; SI = Index, per (AX,BX)
				mov di, si
				add di, [word ptr listOffset_boardMerged]
				mov [byte ptr di], boolTrue ;Set the merge hash at this index to true.
				shl si, 1 ; Every block is 2 bytes
				add si, [word ptr listOffset_board] ; SI = New Block Offset
				inc dx ; Increase the type, since we're going up a level.
				mov [word ptr si], dx ;Set the merged block to the increased type.

			GameCollapseLine_CollapseFinished: ;When it's finished, we need to pop BX back out.
				pop bx
		GameCollapseLine_CheckBlockSkip:
		inc bx
		loop GameCollapseLine_CheckBlockLoop

    pop si di dx cx bx ax
	add sp, 2
    pop bp
	ret 4
endp GameCollapseLine

proc GameCheckLose
	; Info: Checks if the current board has no moves left. If so, sets the game mode accordingly.
    push ax bx cx dx di si
	mov cx, 16
	mov di, [word ptr listOffset_board]
	jmp GameCheckLose_RunLoop

	GameCheckLose_NotLose:
		jmp GameCheckLose_Return
	GameCheckLose_RunLoop:
		mov bx, 16
		sub bx, cx ; bx = iteration
		mov dx, [di] ; DX = tile type
		cmp dx, nullword ;If there's an empty block, there are available moves.
		je GameCheckLose_NotLose

		cmp bx, 4 ; if I<4, you can't subtract 4
		jb GameCheckLose_CantSub4
			cmp dx, [di-(4*2)] ; Checking if the block type matches an adjacent block type
			je GameCheckLose_NotLose
		GameCheckLose_CantSub4:
		
		cmp bx, 12 ; if I>=12, you can't add 4
		jae GameCheckLose_CantAdd4
			cmp dx, [di+(4*2)] ; Checking if the block type matches an adjacent block type
			je GameCheckLose_NotLose
		GameCheckLose_CantAdd4:
		
		and bx, 3 ;3 is 11b, meaning it'll mask only the first two bits.
		cmp bx, 0 ;If the first 2 bits are 00, this block is in the first column, so it can't go left.
		je GameCheckLose_CantSub1
			cmp dx, [di-(1*2)] ; Checking if the block type matches an adjacent block type
			je GameCheckLose_NotLose
		GameCheckLose_CantSub1:
		cmp bx, 3 ;If the first 2 bits are 11, this block is in the last column, so it can't go right.
		je GameCheckLose_CantAdd1
			cmp dx, [di+(1*2)] ; Checking if the block type matches an adjacent block type
			je GameCheckLose_NotLose
		GameCheckLose_CantAdd1:

		add di, 2 ;every block is 2 bytes
		loop GameCheckLose_RunLoop
	; Lose
	push gamemodeDead
	call GameSetMode


	GameCheckLose_Return:
    pop si di dx cx bx ax
	ret
endp GameCheckLose

proc GameSetMode
	; Info: Sets the game's mode, along with the proper initialization it requires.
	; Parameters: New Gamemode
    push bp
    mov bp, sp
    push ax bx cx dx di si
    newGamemode equ [word ptr bp + 4]
    mov ax, newGamemode
	cmp [word ptr game_mode], ax
	je GameSetMode_Ignore

	cmp newGamemode, gamemodePlaying
	jne GameSetMode_NotPlaying
		; Set to playing
		mov [word ptr game_score], 0
		call InitializeBoard
	GameSetMode_NotPlaying:

	cmp newGamemode, gamemodeMainMenu
	jne GameSetMode_NotMainMenu
		; Set to main menu
	GameSetMode_NotMainMenu:

	cmp newGamemode, gamemodeDead
	jne GameSetMode_NotDead
		; Set to dead
		mov [word ptr game_loseTimer], 0
	GameSetMode_NotDead:

	cmp newGamemode, gamemodePause
	jne GameSetMode_NotPause
		; Set to pause.
	GameSetMode_NotPause:

	mov [word ptr game_mode], ax

	GameSetMode_Ignore:
    pop si di dx cx bx ax
    pop bp
	ret 2
endp GameSetMode

proc GameCalculateBoardIndex
	; Info: Calculates an index for the board via direction.
	; Registers: AX, BX, SI
	; Parameters: Direction, X (AX), Y (BX)
	; Returns: List Index (SI)
    push bp
    mov bp, sp
	push dx ax bx
    direction equ [word ptr bp + 4]
	mov dx, direction
	and dx, 1
	jz GameMove_NotDownRight
		; Down Code - Y=(Y-3)
		neg bx
		add bx, 3
	GameMove_NotDownRight:

	cmp direction, 2
	jb GameMove_NotLeftRight
		; Left Right Code - Swap around the registers.
		xor ax, bx
		xor bx, ax
		xor ax, bx
	GameMove_NotLeftRight:



	mov si, bx
	shl si, 2
	add si, ax

	pop bx ax dx
    pop bp
	ret 2
endp GameCalculateBoardIndex

proc GameCalculateBoardOffset
	; Info: Calculates an element offset for the board.
	; Registers: AX, BX, SI
	; Parameters: Direction, X (AX), Y (BX)
	; Returns: List Index (SI)
    push bp
    mov bp, sp
	push [word ptr bp + 4]
	call GameCalculateBoardIndex
	shl si, 1
	add si, [word ptr listOffset_board]
    pop bp
	ret 2
endp GameCalculateBoardOffset


proc InitializePalette
	; Info: Initializes the palette
	mov si, offset rendering_palette
	mov cx, 256
	mov dx, 3C8h
	mov al, 0
	out dx, al
	inc dx
	InitializePalette_PalLoop:
		mov al, [byte ptr si] ; Red
		shr al, 2
		out dx, al ; Send Red
		mov al, [byte ptr si + 1] ; Green
		shr al, 2
		out dx, al ; Send Green
		mov al, [byte ptr si + 2] ; Blue
		shr al, 2
		out dx, al ; Send Blue
		add si, 3
		loop InitializePalette_PalLoop
	ret
endp InitializePalette

proc InitializeParticles
	; Info: Initializes particles
	push ax bx cx dx di si

	cmp [word ptr listID_particles], nullword ;If the particles list is null
	jnz InitializeParticles_DontCreateList
		;Creating the list here
		push 8 ;Particles need PX, PY, VX, VY
		push 20 ;Particle Amount, I only need 20 particles at once
		call ListCreate
		pop [word ptr listID_particles] ; List ID
	InitializeParticles_DontCreateList:

	push [word ptr listID_particles]
	push offset InitializeParticles_particlesForeach
	push boolTrue
	call ListForeach ;Foreach On List 'particles'
	jmp InitializeParticles_particlesForeachExit
	InitializeParticles_particlesForeach:
	;DI = offset, CX = iterations left, AX = list element's length
		push ax
		push 0
		push (320+100)
		call NumberRandom
		pop ax
		sub ax, 100
		mov [word ptr di], ax ; Position X
		push 0
		push (200+100)
		call NumberRandom
		pop ax
		sub ax, 100
		mov [word ptr di + 2], ax ; Position Y
		push 0
		push 16
		call NumberRandom
		pop ax
		mov [word ptr di + 4], ax ; Type
		push 30
		push 80
		call NumberRandom
		pop ax
		mov [word ptr di + 6], ax ; Render Cycles per Move (5-20)
		pop ax
		ret
	InitializeParticles_particlesForeachExit:
	
	push [word ptr listID_particles]
	push nullword
	call ListSetCount
	
	pop si di dx cx bx ax
	ret
endp InitializeParticles

proc InitializeBoard
	; Info: Initializes the board variables
	push ax bx cx dx di si
	cmp [word ptr listID_board], nullword ;If the board list is null
	jnz InitializeBoard_DontCreateListBoard
		;Creating the list here
		push 2 ;Every board tile needs a type, that's it, only 2.
		push 16 ;Board is 4x4 - 16 tiles.
		call ListCreate
		pop [word ptr listID_board] ; List ID

		push [word ptr listID_board]
		push 0
		call ListGet
		pop [word ptr listOffset_board] ;board offset

		push 2 
		push 16 	
		call ListCreate ;Creating the same list as board, that hosts the indices that are available to spawn on
		pop [word ptr listID_boardAvailable] ; List ID
		
		push 1 
		push 16 	
		call ListCreate ;Creating a 16 byte list, that hosts a hash of the board indices that were merged on
		pop [word ptr listID_boardMerged] ; List ID

		push [word ptr listID_boardMerged]
		push 0
		call ListGet
		pop [word ptr listOffset_boardMerged] ;board offset
	InitializeBoard_DontCreateListBoard:
	
	push [word ptr listID_board]
	call ListClear
	push [word ptr listID_boardAvailable]
	call ListClear

	; Start with 2 blocks.
	push ax
	call GameSpawnBlock
	push ax
	call GameSpawnBlock

	pop si di dx cx bx ax
	ret
endp InitializeBoard

proc InitializeInternal
	; Info: Initializes all the necessary internal variables.
	push ax bx cx dx di si
	mov ax, offset lists_alloc
	mov [word ptr lists_offset], ax
	pop si di dx cx bx ax
	ret
endp InitializeInternal

proc InitializeKeyActions
	; Info: Initializes all the key actions.
	push bx si
	mov si, offset internal_keyActions
	mov bl, 0 ;Game Move
		mov bh, 0 ;Direction Up
		 mov [(11h * 2) + si], bx ; 'W'
		 mov [(48h * 2) + si], bx ; Up Arrow
		mov bh, 1 ;Direction Down
		 mov [(1fh * 2) + si], bx ; 'S'
		 mov [(50h * 2) + si], bx ; Down Arrow
		mov bh, 2 ;Direction Left
		 mov [(1eh * 2) + si], bx ; 'A'
		 mov [(4bh * 2) + si], bx ; Left Arrow
		mov bh, 3 ;Direction Left
		 mov [(20h * 2) + si], bx ; 'D'
		 mov [(4dh * 2) + si], bx ; Right Arrow
	mov bl, 1 ;Cheat
		mov bh, 3 ;Spawn '16' Block
		 mov [(2eh * 2) + si], bx ; 'C'
	mov bx, 2 ;Break
		 mov [(30h * 2) + si], bx ; 'B'
	mov bx, 3 ;Restart
		 mov [(13h * 2) + si], bx ; 'R'
		 
	pop si bx
	ret
endp InitializeKeyActions

proc MainProcessKey
	; Info: Processes a key pressed by the player.
	; Parameters: ScanCode
    push bp
    mov bp, sp
    push ax bx cx dx di si
    scanCode equ [word ptr bp + 4]
	xor ax, ax
	xor cx, cx
	xor dx, dx
	xor di, di
	xor si, si ;reset all my registers just for fun :)
	mov bx, scanCode
	shl bx, 1
	mov bx, [word ptr bx + internal_keyActions] ; bx is now the key action
	cmp bx, nullword
	je MainProcessKey_Finish
		; Mode-Specific Actions
		cmp [word ptr game_mode], gamemodeMainMenu
		je MainProcessKey_MainMenu
		cmp [word ptr game_mode], gamemodePlaying
		je MainProcessKey_Playing
		cmp [word ptr game_mode], gamemodeDead
		je MainProcessKey_Dead
		cmp [word ptr game_mode], gamemodePause
		je MainProcessKey_Pause
		MainProcessKey_FinishModeActions:

		; Universal Actions
		cmp bl, 1
		je MainProcessKey_Cheat
		cmp bl, 2
		je MainProcessKey_Break
    MainProcessKey_Finish:
    pop si di dx cx bx ax
    pop bp
	ret 2
	MainProcessKey_Cheat: ; BL=1, BH=Block Type
		mov cl, bh ; Block Type
		push cx
		call GameSpawnBlock
		jmp MainProcessKey_Finish
	MainProcessKey_Break: ; BL=2, BH=
		mov di, offset listOffset_board
		call Break
		jmp MainProcessKey_Finish

endp MainProcessKey

proc MainProcessKey_MainMenu
	; Info: Processes a key pressed by the player, in the main menu.
	; BL = Action Type, BH = Parameter, Any other registers are free to use.

	jmp MainProcessKey_FinishModeActions ; Return
endp MainProcessKey_MainMenu

proc MainProcessKey_Playing
	; Info: Processes a key pressed by the player, while in-game.
	; BL = Action Type, BH = Parameter, Any other registers are free to use.
	cmp bl, 0
	je MainProcessKey_GameMove

	jmp MainProcessKey_FinishModeActions ; Return

	MainProcessKey_GameMove: ; BL=0, BH=Move Direction
		mov cl, bh ; Move Direction
		push cx
		call GameMove
		jmp MainProcessKey_Finish
endp MainProcessKey_Playing

proc MainProcessKey_Pause
	; Info: Processes a key pressed by the player, in the pause menu.
	; BL = Action Type, BH = Parameter, Any other registers are free to use.

	jmp MainProcessKey_FinishModeActions ; Return
endp MainProcessKey_Pause

proc MainProcessKey_Dead
	; Info: Processes a key pressed by the player, while dead.
	; BL = Action Type, BH = Parameter, Any other registers are free to use.
	cmp bl, 3
	je MainProcessKey_Restart

	jmp MainProcessKey_FinishModeActions ; Return
	
	MainProcessKey_Restart: ; BL=3, BH=None
		push gamemodePlaying
		call GameSetMode
		jmp MainProcessKey_Finish
endp MainProcessKey_Dead

proc Break
	ret
endp Break


start:
	mov ax, @data
	mov ds, ax

	
	; Initialization

	call InitializeInternal

	mov ax, 13h
	int 10h

	call InitializeKeyActions
	call InitializePalette
	call InitializeParticles
	call InitializeBoard

	xor ax, ax
	xor bx, bx

	GameLoop:
	mov ah, 1h
	int 16h
	jz GameLoopRender ;skip if key isn't pressed
		mov ah, 0h
		int 16h
		cmp al, 'q'
		je exit
		mov bl, ah ;move the scancode over to bx's lower half
		push bx
		call MainProcessKey
		jmp GameLoop
	GameLoopRender:
		call RenderScreen
		call BufferRender
		call GameUpdateLoop
		jmp GameLoop

exit:
	mov ax, 4c00h
	int 21h
END start
