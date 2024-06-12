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
Use DOSBOX and enter the following lines: (everything with a = is optional, but recommended)
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
