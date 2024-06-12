# 2048 in x86 Assembly
Recreated this game for a computer science project.

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
