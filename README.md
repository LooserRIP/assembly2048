# 2048 in x86 Assembly
Recreated the 2014 game in x86 assembly for a computer science project.
![image](https://github.com/LooserRIP/assembly2048/assets/46068464/25d40dbd-3063-4644-810e-24912e360b6a)

# Features
- Block Animation (Settling, Merging, Spawning)
- Score Counter
- Camera Shake
- Mouse interactions
- Buttons for toggling camerashake/animation
- UI Animations (Logo, background particles, game over, menu transitions)


# How to Run
1. Use [DOSBOX](https://www.dosbox.com/download.php?main=1) with [TASM](https://www.abandonwaredos.com/aw-download.php?tit=Turbo+Assembler+%28TASM%29&dlc=Zy9UQVNNLnppcA==&rem=5&gid=3586&zdi=NDUyMg==) installed and extracted to a directory.
2. Place 2048.asm in the directory where TASM's BIN folder is.
3. Assuming TASM is extracted to C:/, Enter the following lines: (everything with a = is optional, but recommended)
```
mount c: c:\
c:
cd yourdirectory
cycles = max
core = dynamic
output = openglnb
windowresolution = 1280x800
tasm 2048.asm /zi
tlink 2048.obj
2048
```

### MASM-TASM Alternative
Alternatively, you can use the [MASM-TASM](https://marketplace.visualstudio.com/items?itemName=xsro.masm-tasm) extension for visual studio,
in that case simply open the 2048.asm script, right click, and select "Run ASM Code", make sure your settings are fine (especially cycles = max).
