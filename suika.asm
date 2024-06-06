IDEAL
MODEL small
STACK 100h
SEGMENT ScreenBuffer PUBLIC
	buffer db (320*200) dup(0)
ENDS ScreenBuffer

DATASEG

	nullbyte equ 0ffh
	nullword equ 0ffffh
	boolFalse equ 0
	boolTrue equ 1
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

	;  ____                _           _             
	; |  _ \ ___ _ __   __| | ___ _ __(_)_ __   __ _ 
	; |  _ <  __/ | | | (_| |  __/ |  | | | | | (_| |
	; |_| \_\___|_| |_|\__,_|\___|_|  |_|_| |_|\__, |
	;                                          |___/ 
    rendering_palette db 46,34,47,62,53,70,98,85,101,150,108,108,171,148,122,105,79,98,127,112,138,155,171,178,199,220,208,255,255,255,110,39,39,179,56,49,234,79,54,245,125,74,174,35,52,232,59,59
              db 251,107,29,247,150,23,249,194,43,122,48,69,158,69,57,205,104,61,230,144,78,251,185,84,76,62,36,103,102,51,162,169,71,213,224,75,251,255,134,22,90,76,35,144,99,30,188,115
              db 145,219,105,205,223,108,49,54,56,55,78,74,84,126,100,146,169,132,178,186,144,11,94,101,11,138,143,14,175,155,48,225,185,143,248,226,50,51,83,72,74,119,77,101,180,77,155,230
              db 143,211,255,69,41,63,107,62,117,144,94,169,168,132,243,234,173,237,117,60,84,162,75,111,207,101,127,237,128,153,131,28,93,195,36,84,240,79,120,246,129,129,252,167,144,253,203,176
              db 104,41,60,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

	sprite_1 db 16,0,16,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,2,2,2,2,2,2,2,2,2,2,2,2,0,1,1,0,2,2,2,2,2,2,2,2,2,2,2,2,0,1,1,0,2,2,2,2,2,2,2,2,2,2,2,2,0,1,1,0,2,2,2,2,2,2,2,2,2,2,2,2,0,1,1,0,2,2,2,2,3,3,3,3,2,2,2,2,0,1,1,0,2,2,2,2,3,3,3,3,2,2,2,2,0,1,1,0,2,2,2,2,3,3,3,3,2,2,2,2,0,1,1,0,2,2,2,2,3,3,3,3,2,2,2,2,0,1,1,0,2,2,2,2,2,2,2,2,2,2,2,2,0,1,1,0,2,2,2,2,2,2,2,2,2,2,2,2,0,1,1,0,2,2,2,2,2,2,2,2,2,2,2,2,0,1,1,0,2,2,2,2,2,2,2,2,2,2,2,2,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
    sprite_board db 66,0,66,0,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,65,65,65,65,20,20,20,20,20,20,65,65,65,65,21,21,20,20,20,20,65,20,20,20,20,65,20,20,20,20,21,21,65,65,65,65,20,65,65,65,65,20,65,65,65,65,21,21,20,20,20,20,65,65,65,65,65,65,20,20,20,20,21,21,21,21,65,65,65,65,65,20,20,20,20,65,65,65,65,65,21,21,20,20,20,65,20,65,65,65,65,20,65,20,20,20,21,21,65,65,65,20,65,20,20,20,20,65,20,65,65,65,21,21,20,20,20,20,20,65,65,65,65,20,20,20
              db 20,20,21,21,21,21,65,65,65,20,20,20,20,20,20,20,20,65,65,65,21,21,20,20,65,65,65,65,20,20,65,65,65,65,20,20,21,21,65,65,20,20,20,20,65,65,20,20,20,20,65,65,21,21,20,20,20,65,65,65,65,65,65,65,65,20,20,20,21,21,21,21,65,65,20,20,65,20,20,20,20,65,20,20,65,65,21,21,20,65,65,65,65,65,65,65,65,65,65,65,65,20,21,21,65,20,20,20,20,20,20,20,20,20,20,20,20,65,21,21,20,20,65,65,20,65,65,65,65,20,65,65,20,20,21,21,21,21,20,65,20,65,20,65,20,20,65,20,65,20,65,20,21,21,65,20,65,65,65,65,20,20,65,65,65,65,20,65,21,21,20,65,20,20,20,20,65,65,20,20,20,20,65,20,21,21,65,20,65,20,65,20,65,65,20,65,20,65,20,65,21,21,21,21,20,20,20,20,65,20,20,20,20,65,20,20,20,20,21,21,20,65,65,65,65,65,65,65,65,65,65,65,65,20,21,21,65,20,20,20,20,20,20,20,20,20,20,20,20,65,21,21,65,65,65,65,20,65,65,65
              db 65,20,65,65,65,65,21,21,21,21,20,20,20,20,20,20,20,20,20,20,20,20,20,20,21,21,20,65,20,65,20,65,65,65,65,20,65,20,65,20,21,21,65,20,65,20,65,20,20,20,20,65,20,65,20,65,21,21,65,65,65,65,65,65,65,65,65,65,65,65,65,65,21,21,21,21,20,20,20,20,20,20,20,20,20,20,20,20,20,20,21,21,20,65,20,65,20,65,65,65,65,20,65,20,65,20,21,21,65,20,65,20,65,20,20,20,20,65,20,65,20,65,21,21,65,65,65,65,65,65,65,65,65,65,65,65,65,65,21,21,21,21,20,20,20,20,65,20,20,20,20,65,20,20,20,20,21,21,20,65,65,65,65,65,65,65,65,65,65,65,65,20,21,21,65,20,20,20,20,20,20,20,20,20,20,20,20,65,21,21,65,65,65,65,20,65,65,65,65,20,65,65,65,65,21,21,21,21,20,65,20,65,20,65,20,20,65,20,65,20,65,20,21,21,65,20,65,65,65,65,20,20,65,65,65,65,20,65,21,21,20,65,20,20,20,20,65,65,20,20,20,20,65,20,21,21,65,20,65,20
              db 65,20,65,65,20,65,20,65,20,65,21,21,21,21,65,65,20,20,65,20,20,20,20,65,20,20,65,65,21,21,20,65,65,65,65,65,65,65,65,65,65,65,65,20,21,21,65,20,20,20,20,20,20,20,20,20,20,20,20,65,21,21,20,20,65,65,20,65,65,65,65,20,65,65,20,20,21,21,21,21,65,65,65,20,20,20,20,20,20,20,20,65,65,65,21,21,20,20,65,65,65,65,20,20,65,65,65,65,20,20,21,21,65,65,20,20,20,20,65,65,20,20,20,20,65,65,21,21,20,20,20,65,65,65,65,65,65,65,65,20,20,20,21,21,21,21,65,65,65,65,65,20,20,20,20,65,65,65,65,65,21,21,20,20,20,65,20,65,65,65,65,20,65,20,20,20,21,21,65,65,65,20,65,20,20,20,20,65,20,65,65,65,21,21,20,20,20,20,20,65,65,65,65,20,20,20,20,20,21,21,21,21,65,65,65,65,20,20,20,20,20,20,65,65,65,65,21,21,20,20,20,20,65,20,20,20,20,65,20,20,20,20,21,21,65,65,65,65,20,65,65,65,65,20,65,65,65,65,21,21
              db 20,20,20,20,65,65,65,65,65,65,20,20,20,20,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,20,20,20,20,65,20,20,20,20,65,20,20,20,20,21,21,65,65,65,65,20,20,20,20,20,20,65,65,65,65,21,21,20,20,20,20,65,65,65,65,65,65,20,20,20,20,21,21,65,65,65,65,20,65,65,65,65,20,65,65,65,65,21,21,21,21,20,20,20,65,20,65,65,65,65,20,65,20,20,20,21,21,65,65,65,65,65,20,20,20,20,65,65,65,65,65,21,21,20,20,20,20,20,65,65,65,65,20,20,20
              db 20,20,21,21,65,65,65,20,65,20,20,20,20,65,20,65,65,65,21,21,21,21,20,20,65,65,65,65,20,20,65,65,65,65,20,20,21,21,65,65,65,65,65,20,20,20,20,65,65,65,65,65,21,21,20,20,20,20,20,65,65,65,65,20,20,20,20,20,21,21,65,65,20,20,20,20,65,65,20,20,20,20,65,65,21,21,21,21,20,65,65,65,65,65,65,65,65,65,65,65,65,20,21,21,65,65,65,65,65,20,20,20,20,65,65,65,65,65,21,21,20,20,20,20,20,65,65,65,65,20,20,20,20,20,21,21,65,20,20,20,20,20,20,20,20,20,20,20,20,65,21,21,21,21,65,20,65,65,65,65,20,20,65,65,65,65,20,65,21,21,20,65,65,65,20,65,20,20,65,20,65,65,65,65,21,21,20,20,20,20,65,20,65,65,20,65,20,20,20,65,21,21,20,65,20,20,20,20,65,65,20,20,20,20,65,20,21,21,21,21,20,65,65,65,65,65,65,65,65,65,65,65,65,20,21,21,20,20,20,20,65,20,20,20,20,65,20,20,20,20,21,21,65,65,65,65,20,65,65,65
              db 65,20,65,65,65,65,21,21,65,20,20,20,20,20,20,20,20,20,20,20,20,65,21,21,21,21,20,65,20,65,20,65,65,65,65,20,65,20,65,20,21,21,20,20,20,20,20,20,20,20,20,20,20,20,20,20,21,21,65,65,65,65,65,65,65,65,65,65,65,65,65,65,21,21,65,20,65,20,65,20,20,20,20,65,20,65,20,65,21,21,21,21,20,65,20,65,20,65,65,65,65,20,65,20,65,20,21,21,20,20,20,20,20,20,20,20,20,20,20,20,20,20,21,21,65,65,65,65,65,65,65,65,65,65,65,65,65,65,21,21,65,20,65,20,65,20,20,20,20,65,20,65,20,65,21,21,21,21,20,65,65,65,65,65,65,65,65,65,65,65,65,20,21,21,20,20,20,20,65,20,20,20,20,65,20,20,20,20,21,21,65,65,65,65,20,65,65,65,65,20,65,65,65,65,21,21,65,20,20,20,20,20,20,20,20,20,20,20,20,65,21,21,21,21,65,20,65,65,65,65,20,20,65,65,65,65,20,65,21,21,20,65,65,65,20,65,20,20,65,20,65,65,65,65,21,21,20,20,20,20
              db 65,20,65,65,20,65,20,20,20,65,21,21,20,65,20,20,20,20,65,65,20,20,20,20,65,20,21,21,21,21,20,65,65,65,65,65,65,65,65,65,65,65,65,20,21,21,65,65,65,65,65,20,20,20,20,65,65,65,65,65,21,21,20,20,20,20,20,65,65,65,65,20,20,20,20,20,21,21,65,20,20,20,20,20,20,20,20,20,20,20,20,65,21,21,21,21,20,20,65,65,65,65,20,20,65,65,65,65,20,20,21,21,65,65,65,65,65,20,20,20,20,65,65,65,65,65,21,21,20,20,20,20,20,65,65,65,65,20,20,20,20,20,21,21,65,65,20,20,20,20,65,65,20,20,20,20,65,65,21,21,21,21,20,20,20,65,20,65,65,65,65,20,65,20,20,20,21,21,65,65,65,65,65,20,20,20,20,65,65,65,20,20,21,21,65,65,20,20,20,65,65,65,65,20,20,20,20,20,21,21,65,65,65,20,65,20,20,20,20,65,20,65,65,65,21,21,21,21,20,20,20,20,65,20,20,20,20,65,20,20,20,20,21,21,65,65,65,65,65,20,20,20,20,65,65,65,20,20,21,21
              db 65,65,20,20,20,65,65,65,65,20,20,20,20,20,21,21,65,65,65,65,20,65,65,65,65,20,65,65,65,65,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,65,65,65,65,20,65,65,65,65,20,65,65,65,65,21,21,20,20,20,20,20,65,65,65,65,20,20,20,65,65,21,21,20,20,65,65,65,20,20,20,20,65,65,65,65,65,21,21,20,20,20,20,65,20,20,20,20,65,20,20,20,20,21,21,21,21,65,65,65,20,65,20,20,20,20,65,20,65,65,65,21,21,20,20,20,20,20,65,65,65,65,20,20,20
              db 65,65,21,21,20,20,65,65,65,20,20,20,20,65,65,65,65,65,21,21,20,20,20,65,20,65,65,65,65,20,65,20,20,20,21,21,21,21,65,65,20,20,20,20,65,65,20,20,20,20,65,65,21,21,20,20,20,20,20,65,65,65,65,20,20,20,20,20,21,21,65,65,65,65,65,20,20,20,20,65,65,65,65,65,21,21,20,20,65,65,65,65,20,20,65,65,65,65,20,20,21,21,21,21,65,20,20,20,20,20,20,20,20,20,20,20,20,65,21,21,20,20,20,20,20,65,65,65,65,20,20,20,20,20,21,21,65,65,65,65,65,20,20,20,20,65,65,65,65,65,21,21,20,65,65,65,65,65,65,65,65,65,65,65,65,20,21,21,21,21,20,65,20,20,20,20,65,65,20,20,20,20,65,20,21,21,65,20,20,20,65,20,65,65,20,65,20,20,20,20,21,21,65,65,65,65,20,65,20,20,65,20,65,65,65,20,21,21,65,20,65,65,65,65,20,20,65,65,65,65,20,65,21,21,21,21,65,20,20,20,20,20,20,20,20,20,20,20,20,65,21,21,65,65,65,65,20,65,65,65
              db 65,20,65,65,65,65,21,21,20,20,20,20,65,20,20,20,20,65,20,20,20,20,21,21,20,65,65,65,65,65,65,65,65,65,65,65,65,20,21,21,21,21,65,20,65,20,65,20,20,20,20,65,20,65,20,65,21,21,65,65,65,65,65,65,65,65,65,65,65,65,65,65,21,21,20,20,20,20,20,20,20,20,20,20,20,20,20,20,21,21,20,65,20,65,20,65,65,65,65,20,65,20,65,20,21,21,21,21,65,20,65,20,65,20,20,20,20,65,20,65,20,65,21,21,65,65,65,65,65,65,65,65,65,65,65,65,65,65,21,21,20,20,20,20,20,20,20,20,20,20,20,20,20,20,21,21,20,65,20,65,20,65,65,65,65,20,65,20,65,20,21,21,21,21,65,20,20,20,20,20,20,20,20,20,20,20,20,65,21,21,65,65,65,65,20,65,65,65,65,20,65,65,65,65,21,21,20,20,20,20,65,20,20,20,20,65,20,20,20,20,21,21,20,65,65,65,65,65,65,65,65,65,65,65,65,20,21,21,21,21,20,65,20,20,20,20,65,65,20,20,20,20,65,20,21,21,65,20,20,20
              db 65,20,65,65,20,65,20,20,20,20,21,21,65,65,65,65,20,65,20,20,65,20,65,65,65,20,21,21,65,20,65,65,65,65,20,20,65,65,65,65,20,65,21,21,21,21,65,20,20,20,20,20,20,20,20,20,20,20,20,65,21,21,20,20,20,20,20,65,65,65,65,20,20,20,20,20,21,21,65,65,65,65,65,20,20,20,20,65,65,65,65,65,21,21,20,65,65,65,65,65,65,65,65,65,65,65,65,20,21,21,21,21,65,65,20,20,20,20,65,65,20,20,20,20,65,65,21,21,20,20,20,20,20,65,65,65,65,20,20,20,20,20,21,21,65,65,65,65,65,20,20,20,20,65,65,65,65,65,21,21,20,20,65,65,65,65,20,20,65,65,65,65,20,20,21,21,21,21,65,65,65,20,65,20,20,20,20,65,20,65,65,65,21,21,20,20,20,20,20,65,65,65,65,20,20,20,20,20,21,21,65,65,65,65,65,20,20,20,20,65,65,65,65,65,21,21,20,20,20,65,20,65,65,65,65,20,65,20,20,20,21,21,21,21,65,65,65,65,20,65,65,65,65,20,65,65,65,65,21,21
              db 20,20,20,20,65,65,65,65,65,65,20,20,20,20,21,21,65,65,65,65,20,20,20,20,20,20,65,65,65,65,21,21,20,20,20,20,65,20,20,20,20,65,20,20,20,20,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,20,20,20,20,65,65,65,65,65,65,20,20,20,20,21,21,65,65,65,65,20,65,65,65,65,20,65,65,65,65,21,21,20,20,20,20,65,20,20,20,20,65,20,20,20,20,21,21,65,65,65,65,20,20,20,20,20,20,65,65,65,65,21,21,21,21,20,20,20,20,20,65,65,65,65,20,20,20
              db 20,20,21,21,65,65,65,20,65,20,20,20,20,65,20,65,65,65,21,21,20,20,20,65,20,65,65,65,65,20,65,20,20,20,21,21,65,65,65,65,65,20,20,20,20,65,65,65,65,65,21,21,21,21,20,20,20,65,65,65,65,65,65,65,65,20,20,20,21,21,65,65,20,20,20,20,65,65,20,20,20,20,65,65,21,21,20,20,65,65,65,65,20,20,65,65,65,65,20,20,21,21,65,65,65,20,20,20,20,20,20,20,20,65,65,65,21,21,21,21,20,20,65,65,20,65,65,65,65,20,65,65,20,20,21,21,65,20,20,20,20,20,20,20,20,20,20,20,20,65,21,21,20,65,65,65,65,65,65,65,65,65,65,65,65,20,21,21,65,65,20,20,65,20,20,20,20,65,20,20,65,65,21,21,21,21,65,20,65,20,65,20,65,65,20,65,20,65,20,65,21,21,20,65,20,20,20,20,65,65,20,20,20,20,65,20,21,21,65,20,65,65,65,65,20,20,65,65,65,65,20,65,21,21,20,65,20,65,20,65,20,20,65,20,65,20,65,20,21,21,21,21,65,65,65,65,20,65,65,65
              db 65,20,65,65,65,65,21,21,65,20,20,20,20,20,20,20,20,20,20,20,20,65,21,21,20,65,65,65,65,65,65,65,65,65,65,65,65,20,21,21,20,20,20,20,65,20,20,20,20,65,20,20,20,20,21,21,21,21,65,65,65,65,65,65,65,65,65,65,65,65,65,65,21,21,65,20,65,20,65,20,20,20,20,65,20,65,20,65,21,21,20,65,20,65,20,65,65,65,65,20,65,20,65,20,21,21,20,20,20,20,20,20,20,20,20,20,20,20,20,20,21,21,21,21,65,65,65,65,65,65,65,65,65,65,65,65,65,65,21,21,65,20,65,20,65,20,20,20,20,65,20,65,20,65,21,21,20,65,20,65,20,65,65,65,65,20,65,20,65,20,21,21,20,20,20,20,20,20,20,20,20,20,20,20,20,20,21,21,21,21,65,65,65,65,20,65,65,65,65,20,65,65,65,65,21,21,65,20,20,20,20,20,20,20,20,20,20,20,20,65,21,21,20,65,65,65,65,65,65,65,65,65,65,65,65,20,21,21,20,20,20,20,65,20,20,20,20,65,20,20,20,20,21,21,21,21,65,20,65,20
              db 65,20,65,65,20,65,20,65,20,65,21,21,20,65,20,20,20,20,65,65,20,20,20,20,65,20,21,21,65,20,65,65,65,65,20,20,65,65,65,65,20,65,21,21,20,65,20,65,20,65,20,20,65,20,65,20,65,20,21,21,21,21,20,20,65,65,20,65,65,65,65,20,65,65,20,20,21,21,65,20,20,20,20,20,20,20,20,20,20,20,20,65,21,21,20,65,65,65,65,65,65,65,65,65,65,65,65,20,21,21,65,65,20,20,65,20,20,20,20,65,20,20,65,65,21,21,21,21,20,20,20,65,65,65,65,65,65,65,65,20,20,20,21,21,65,65,20,20,20,20,65,65,20,20,20,20,65,65,21,21,20,20,65,65,65,65,20,20,65,65,65,65,20,20,21,21,65,65,65,20,20,20,20,20,20,20,20,65,65,65,21,21,21,21,20,20,20,20,20,65,65,65,65,20,20,20,20,20,21,21,65,65,65,20,65,20,20,20,20,65,20,65,65,65,21,21,20,20,20,65,20,65,65,65,65,20,65,20,20,20,21,21,65,65,65,65,65,20,20,20,20,65,65,65,65,65,21,21,21,21
              db 20,20,20,20,65,65,65,65,65,65,20,20,20,20,21,21,65,65,65,65,20,65,65,65,65,20,65,65,65,65,21,21,20,20,20,20,65,20,20,20,20,65,20,20,20,20,21,21,65,65,65,65,20,20,20,20,20,20,65,65,65,65,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21
	

	
	;   ____                        _                _      
	;  / ___| __ _ _ __ ___   ___  | |    ___   __ _(_) ___ 
	; | |  _ / _` | '_ ` _ \ / _ \ | |   / _ \ / _` | |/ __|
	; | |_| | (_| | | | | | |  __/ | |__| (_) | (_| | | (__ 
	;  \____|\__,_|_| |_| |_|\___| |_____\___/ \__, |_|\___|
	;                                          |___/        
	
	listID_board dw nullword
	game_boardOffset dw nullword
	listID_boardAvailable dw nullword

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
	push ax bx cx dx di si

	listID equ [word ptr bp + 4]

	; Get list info offset
	mov bx, listID
	shl bx, 3 ;every list info is 8 bytes exactly
	add bx, offset lists_info ;this is now the list's info offset

	; Move the offset of the list
	mov di, [word ptr bx]
	; Get the element length
	mov ax, [word ptr bx+2]
	mov dx, 0
	mov si, [word ptr bx+4] ;Save the element *length*, this'll serve as the index
	mul si ;Multiply it by the index
	mov cx, ax ; CX = ElementLength * Count
	cmp cx, 0
	jz ListClear_NoLoop
	ListClear_Loop: ;Setting byte by byte, because i'm an idiot and terribly scared of movsb
		mov [byte ptr di], nullbyte
		inc di
	loop ListClear_Loop
	ListClear_NoLoop:

	pop si di dx cx bx ax
	pop bp
	ret 2
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
	; Get the element length
	mov ax, [word ptr bx+2]

	mul index ;Multiply it by the index
	add di, ax ;DI = ListOffset + (ElementLength * Index) = ListElementReferenceOffset
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
	mov di, 0
	mov cx, 32000
	BufferClear_Loop:
		mov [word ptr es:di], 0h
		add di, 2
	loop BufferClear_Loop
	pop es di cx bx ax
	ret
endp BufferClear

proc RenderFrame ;renders the screenbuffer over to the video memory
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
endp RenderFrame

proc RenderScreen ;Renders the game's objects onto the screen.
	push ax bx cx dx si
	call BufferClear
	
	;push offset sprite_1
	;push 310 ;x
	;push 10 ;y
	;call BufferSprite
	push [word ptr listID_particles] ; List ID
	push offset RenderScreen_ParticleRenderForeach
	push boolFalse
	call ListForeach
	jmp RenderScreen_ParticleRenderForeachExit
	RenderScreen_ParticleRenderForeach:
		push offset sprite_1 ;sprite
		add [word ptr di], 1h 
		add [word ptr di+2], 1h
		cmp [word ptr di], 320 ;X border detection
		jl RenderScreen_ParticleDontWrapX
			mov [word ptr di], 0
			sub [word ptr di], 16
		RenderScreen_ParticleDontWrapX:
		cmp [word ptr di+2], 200 ;Y border detection
		jl RenderScreen_ParticleDontWrapY
			mov [word ptr di+2], 0
			sub [word ptr di+2], 16
		RenderScreen_ParticleDontWrapY:
		push [word ptr di] ;x
		push [word ptr di+2] ;y
		call BufferSprite
		ret
	RenderScreen_ParticleRenderForeachExit:

	push offset sprite_board
	push 0
	push 0
	push boolTrue
	call BufferSpriteCenter

	pop si dx cx bx ax
	ret
endp RenderScreen

proc BufferSprite ;Adds a sprite to the buffer
	; Parameters:
    ; - Sprite Offset
    ; - Top Left X
    ; - Top Left Y
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
	add di, 4

	mov cx, 0
	mov bx, 0
	BufferSprite_SetLoop:
		
		mov al, [byte ptr di]
		cmp al, 0
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
			dec [byte ptr es:si]
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



proc InitializePalette ;Initializes the palette
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

proc InitializeParticles ;Initializes particles
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
		push 336
		call NumberRandom
		pop ax
		sub ax, 16
		mov [word ptr di], ax ;PX
		push 0
		push 216
		call NumberRandom
		pop ax
		sub ax, 16
		mov [word ptr di + 2], ax ;PY
		push 0
		push 2
		call NumberRandom
		pop ax
		sub ax, 16
		mov [word ptr di + 4], 0 ;VX
		mov [word ptr di + 6], 0 ;VY
		pop ax
		ret
	InitializeParticles_particlesForeachExit:
	
	push [word ptr listID_particles]
	push nullword
	call ListSetCount
	
	pop si di dx cx bx ax
	ret
endp InitializeParticles

proc InitializeBoard ;Initializes the board variables
	push ax bx cx dx di si
	cmp [word ptr listID_board], nullword ;If the board list is null
	jnz InitializeBoard_DontCreateListBoard
		;Creating the list here
		push 2 ;Every board tile needs a type, that's it, only 2.
		push 16 ;Board is 4x4 - 16 tiles.
		call ListCreate
		pop [word ptr listID_board] ; List ID

		push 2 
		push 16 	
		call ListCreate ;Creating the same list as board, that hosts the indices that are available to spawn on
		pop [word ptr listID_boardAvailable] ; List ID
	InitializeBoard_DontCreateListBoard:


	push [word ptr listID_boardAvailable] ; List ID
	push 0
	call ListGet
	pop bx
	
	push [word ptr listID_boardAvailable]
	call ListClear

	push 0
	call GameSpawnRandomTile
	push 0
	call GameSpawnRandomTile

	pop si di dx cx bx ax
	ret
endp InitializeBoard


proc GameSpawnRandomTile
	; Info: Spawns a game tile into the board list at a random null position.
	; Parameters: Tile Type
	push bp
	mov bp, sp
	push ax bx cx dx di si
	tileType equ [word ptr bp + 4]
	
	push [word ptr listID_board]
	push offset GameSpawnRandomTile_boardForeach
	push boolTrue
	call ListForeach ;Foreach on list 'board'
	jmp GameSpawnRandomTile_boardForeachExit
	GameSpawnRandomTile_boardForeach:
		;DI = offset, CX = iterations left, AX = list element's length
		cmp [word ptr di], nullword
		jne GameSpawnRandomTile_NotNullSkip
			push [word ptr listID_boardAvailable] ; List ID
			call ListGetAdd ;Like list add but returns the offset
			pop bx ;We now got the add position
			mov [word ptr bx], 16
			sub [word ptr bx], cx ; Element = listIndex
		GameSpawnRandomTile_NotNullSkip:
		ret
	GameSpawnRandomTile_boardForeachExit:
	;jmp skiptest

	push [word ptr listID_boardAvailable]
	call ListCount
	pop bx
	; If bx = 0, no available spots, this would mean losing. at the moment,
	; i'll be jumping to exit.
	cmp bx, 0
	jne GameSpawnRandomTile_NotLose
		jmp exit
	GameSpawnRandomTile_NotLose:

	push 0
	push bx ; List Count
	call NumberRandom
	pop si ; si = index

	push [word ptr listID_boardAvailable]
	push si
	call ListGet
	pop bx

	mov ax, tileType
	mov [word ptr bx], ax

	skiptest:
	pop si di dx cx bx ax
	pop bp
	ret 2
endp GameSpawnRandomTile


proc GameSpawnTile
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
endp GameSpawnTile

proc InitializeInternal
; Info: Initializes all the necessary internal variables.
	push ax bx cx dx di si
	mov ax, offset lists_alloc
	mov [word ptr lists_offset], ax
	pop si di dx cx bx ax
ret
endp InitializeInternal




start:
	mov ax, @data
	mov ds, ax
	call InitializeInternal

	mov ax, 0A000h
	mov es, ax ; ES is now at the video memory
	
	; Graphics Mode
	
	mov ax, 13h
	int 10h
	call InitializePalette

	call InitializeParticles

	call InitializeBoard
	
	render:
		call RenderScreen
		call RenderFrame
		jmp render

exit:
	mov ax, 4c00h
	int 21h
END start
