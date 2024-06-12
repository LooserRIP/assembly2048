from PIL import Image
import pyperclip
import tkinter as tk
from tkinter import filedialog
from pathlib import Path
import os
import colorsys
import shutil
import time
import random

def to_little_endian_bytes(value):
    """Convert an integer value to a little-endian byte representation."""
    if not (0 <= value <= 65535):
        raise ValueError("Value must be between 0 and 65535")
    low_byte = value & 0xFF
    high_byte = (value >> 8) & 0xFF
    return f"{low_byte},{high_byte}"


def hexa(value, intendedbytes = 1):
    value = max(0, min(pow(2, intendedbytes*8)-1, value))
    return f'{value:#0{intendedbytes*2 + 2}x}'[2:]
def combinestringlist(word_list, perelement, substitute = "", hexFormat = False):
    if substitute == "":
        substitute = repeat_to_length("0", perelement)
    leng = len(word_list);
    for iga in range(perelement):
        word_list.append(substitute)
    
    final = []
    for i in range(0, leng, perelement):
        add = "";
        addreverse = "";
        for ig in range(perelement):
            add = add+word_list[i+ig]
            addreverse = addreverse+word_list[i+(perelement-ig-1)]
        if hexFormat:
            add = hexformat(addreverse)
        final.append(add)
    return final

def hexformat(input_str):
    input_str = input_str.lstrip('0')
    if not input_str or not input_str[0].isdigit():
        input_str = '0' + input_str
    return input_str + "h";
def dup(strings):
    if not strings:
        return []

    result = []
    current_string = strings[0]
    count = 1

    for i in range(1, len(strings)):
        if strings[i] == current_string:
            count += 1
        else:
            if count > 1:
                result.append(f"{count} dup({current_string})")
            else:
                result.append(current_string)
            current_string = strings[i]
            count = 1

    if count > 1:
        result.append(f"{count} dup({current_string})")
    else:
        result.append(current_string)

    return result


def newlinejoin(listofbytes, defineword, chunk_size=260, filename = ""):
    listofbytes = dup(listofbytes)
    chunks = []
    current_chunk = []
    current_length = 0
    extraspace = " " * int(len(filename)-3);
    
    for elem in listofbytes:
        elem_length = len(elem)
        if current_length + elem_length > chunk_size:
            chunks.append(current_chunk)
            current_chunk = [elem]
            current_length = elem_length
        else:
            current_chunk.append(elem)
            current_length += elem_length
            
    if current_chunk:
        chunks.append(current_chunk)
    
    result = []
    for chunk in chunks:
        result.append(f"{defineword} {','.join(chunk)}")
    
    return f'\n        {extraspace}'.join(result)

def optimaldefine(listofbytes, filename, character_size):
    combinedB = list(map(lambda x: str(int(x, 16)), listofbytes))
    combinedW = combinestringlist(listofbytes, 2, "00", True);
    combinedD = combinestringlist(listofbytes, 4, "00", True);
    combinedQ = combinestringlist(listofbytes, 8, "00", True);

    result_stringB = f"{newlinejoin(combinedB, 'db', character_size, filename)}"
    result_stringW = f"{newlinejoin(combinedW, 'dw', character_size, filename)}"
    result_stringD = f"{newlinejoin(combinedD, 'dd', character_size, filename)}"
    result_stringQ = f"{newlinejoin(combinedQ, 'dq', character_size, filename)}"

    smallest_string = min([result_stringB, result_stringW, result_stringD, result_stringQ], key=len)
    return f"{filename} {smallest_string}"


def color_to_indices(image_path, color_list, dontCopy = False):
    imgpure = Image.open(image_path)
    img = imgpure.convert('RGB')
    imgalpha = imgpure.convert('RGBA')

    color_tuples = [tuple(int(c[i:i+2], 16) for i in (1, 3, 5)) for c in color_list]

    finals = []
    numbers = [0,0,0,0,0,0]
    result_indices = []
    maxperline = 260
    i = 0;
    sprite_type = 0;

    width, height = img.size

    for y in range(height):
        for x in range(width):
            pixel = img.getpixel((x, y))
            pixelalpha = imgalpha.getpixel((x, y))
            if pixel in color_tuples:
                if pixelalpha[3] == 0:
                    result_indices.append('255')
                    numbers.append(hexa(255,1));
                    sprite_type = 1;
                else:
                    result_indices.append(str(color_tuples.index(pixel)))
                    numbers.append(hexa(color_tuples.index(pixel),1));
            else:
                result_indices.append('255')
                numbers.append(hexa(255,1));
            i += 1;
            if (i >= maxperline):
                i = 0
                finals.append(','.join(result_indices))
                result_indices = [];
            
# + '\n              db '.join(final)
    if i > 0:
        finals.append(','.join(result_indices))
        result_indices = [];
    filename = f"sprite_{Path(image_path).stem}"
    numbers[0] = hexa(width, 2)[2:4]
    numbers[1] = hexa(width, 2)[0:2]
    numbers[2] = hexa(height, 2)[2:4]
    numbers[3] = hexa(height, 2)[0:2]
    numbers[4] = hexa(sprite_type, 2)[2:4]
    numbers[5] = hexa(sprite_type, 2)[0:2]
    combined = combinestringlist(numbers, 8, "00", True);
    result_string = f"{optimaldefine(numbers, filename, 800)}"
    # copy the result
    print(f"Finished processing sprite '{Path(image_path).stem}'")
    if not (dontCopy):
        pyperclip.copy(result_string)
        print(f"Total: {len(numbers)} bytes");
        print(f"\nSprite '{Path(image_path).stem}' copied to clipboard!")
    totalbytes = len(numbers)
    return {'result': result_string, 'bytes': totalbytes};


def rgb_to_hex(rgb):
    return f'#{rgb[0]:02X}{rgb[1]:02X}{rgb[2]:02X}'

def parse_png(file_path):
    img = Image.open(file_path)

    if img.size != (16, 16):
        raise ValueError("Image dimensions must be 16x16")

    img = img.convert('RGB')

    color_hex_codes = []

    for y in range(16):
        for x in range(16):
            rgb = img.getpixel((x, y))
            color_hex_codes.append(rgb_to_hex(rgb))

    return color_hex_codes

def rgb_values_string(file_path):
    img = Image.open(file_path)

    if img.size != (16, 16):
        raise ValueError("Image dimensions must be 16x16")

    img = img.convert('RGB')

    final = [];
    for y in range(16):
        rgb_values = []
        for x in range(16):
            rgb = img.getpixel((x, y))
            final.extend(map(lambda x: hexa(x, 1), rgb))
        #final.append(','.join(dup(list(map(str, rgb_values)))))

    return f"{optimaldefine(final, 'rendering_palette', 600)}"

def open_file_selector_sprite():
    print("Opening")
    #root.withdraw()  # Close the root window
    
    file_path = filedialog.askopenfilename(
        filetypes=[("PNG files", "*.png"), ("All files", "*.*")]
    )
    
    if file_path:
        color_list = parse_png(f"{os.path.dirname(os.path.realpath(__file__))}/palette.png")
        color_to_indices(file_path, color_list)
    else:
        print("Invalid path.")

def rgb_to_hex(rgb):
    return '#{:02x}{:02x}{:02x}'.format(*rgb)

def mask_to_rects(image_path):
    detectedColors = [];
    imgpure = Image.open(image_path)
    imgalpha = imgpure.convert('RGBA') 
    img = imgpure.convert('RGB')  


    words = []
    finals = []
    allrects = [];
    maxperline = 260
    i = 0;
    sprite_type = 0;

    masktable = [];
    totalLeft = 0;
    # Get image dimensions
    width, height = imgalpha.size

    for y in range(height):
        maskrow = [];
        for x in range(width):
            #pixel = img.getpixel((x, y))
            pixelalpha = imgalpha.getpixel((x, y))
            if pixelalpha[3] == 0:
                # this would be air
                maskrow.append(False)
            else:
                # this would be existing
                maskColor = img.getpixel((x, y));
                if maskColor not in detectedColors:
                    detectedColors.append(maskColor);
                maskrow.append(True)
                totalLeft += 1;
        masktable.append(maskrow)
    #print(masktable)
    print(f"Total Left: {totalLeft}\nIterating...");

    for alloci in range(4): #allocate 4 bytes
        words.append("alloc");
    totalrects = 0;
    for iteration in range(500):
        if (totalLeft == 0): break;
        rect = find_best_rect(masktable, width, height);
        for yDelete in range(rect['height']):
            for xDelete in range(rect['width']):
                yDf = yDelete + rect['y'];
                xDf = xDelete + rect['x'];
                if not masktable[yDf][xDf]:
                    print(f"Error at ({yDf},{xDf})");
                masktable[yDf][xDf] = False;
                totalLeft -= 1;
        print(f"Iteration: {iteration}: {rect}, Total Left: {totalLeft}")
        #words.append(create_doubleword(rect['width'] - 1, rect['height'] - 1, rect['x'], rect['y'], True))
        allrects.append(rect);
        totalrects += 1;
        if (totalLeft == 0): break;
    
    allrects.reverse()
    random.shuffle(allrects)
    for addrect in allrects:
        words.append(hexa(addrect['width'], 1))
        words.append(hexa(addrect['height'], 1))
        words.append(hexa(addrect['x'], 1))
        words.append(hexa(addrect['y'], 1))

    words[0] = hexa(width, 1)
    words[1] = hexa(height, 1)
    words[2] = hexa(totalrects, 2)[2:4]
    words[3] = hexa(totalrects, 2)[0:2]
    finals = combinestringlist(words, 8, "00", True);
    print(words)
    print(finals)
    print(f"Solved in {totalrects} rects.");
    print(f"Total: {len(words)} bytes");
    filename = f"mask_{Path(image_path).stem}";
    result_string = f"{optimaldefine(words, filename, 600)}"
    pyperclip.copy(result_string)
    print(f"Mask copied to clipboard.")
    if len(detectedColors):
        print(f"\nDetected colors:")
        color_list = parse_png(f"{os.path.dirname(os.path.realpath(__file__))}/palette.png")
        color_tuples = [tuple(int(c[i:i+2], 16) for i in (1, 3, 5)) for c in color_list]
        for detectedColor in detectedColors:
            if detectedColor in color_tuples:
                print(f"{rgb_to_hex(detectedColor)} - Palette index: {color_tuples.index(detectedColor)}")
            else:
                print(f"{rgb_to_hex(detectedColor)} - Not in palette.")
            
    #if i > 0:
    #    finals.append(','.join(result_indices))
    #    result_indices = [];
    #filename = f"sprite_{Path(image_path).stem}"
    #pyperclip.copy(result_string)

def find_best_rect(masktable, width, height):
    bestrectsq = 0;
    bestrect = {};
    for y in range(height):
        for x in range(width):
            if not (masktable[y][x]):
                continue;
            # Expand in X
            maxWidth = int(width);
            maxHeight = int(height);
            
            maxWidth = 1000;
            maxHeight = 1000;
            xStop = False;
            xHeight = 1;
            xWidth = 1;
            for xAddWidth in range(x+1, width):
                if not (masktable[y][xAddWidth]):
                    break;
                if xWidth >= maxWidth:
                    break;
                xWidth += 1;
            for xAddHeight in range(y+1, height):
                for xAddWidth in range(x, x+xWidth):
                    if not (masktable[xAddHeight][xAddWidth]):
                        xStop = True;
                        break;
                if xStop: break;
                if xHeight >= maxHeight:
                    break;
                xHeight += 1;
            #print(f"({x},{y}) -> X: ({xWidth}, {xHeight} . {xWidth*xHeight}squ)")
            if (xWidth*xHeight > bestrectsq): #new champion
                bestrectsq = xWidth*xHeight;
                bestrect = {'x': x, 'y': y, 'width': xWidth, 'height': xHeight, 'squares': xWidth*xHeight, 'method': 'x'};
                
            # Expand in Y
            yStop = False;
            yHeight = 1;
            yWidth = 1;
            for yAddHeight in range(y+1, height):
                if not (masktable[yAddHeight][x]):
                    break;
                if yHeight >= maxHeight:
                    break;
                yHeight += 1;
            for yAddWidth in range(x+1, width):
                for yAddHeight in range(y, y+yHeight):
                    if not (masktable[yAddHeight][yAddWidth]):
                        yStop = True;
                        break;
                if yStop: break;
                if yWidth >= maxWidth:
                    break;
                yWidth += 1;
            #print(f"({x},{y}) -> Y: ({yWidth}, {yHeight} . {yWidth*yHeight}squ)")
            if (yWidth*yHeight > bestrectsq): #new champion
                bestrectsq = yWidth*yHeight;
                bestrect = {'x': x, 'y': y, 'width': yWidth, 'height': yHeight, 'squares': yWidth*yHeight, 'method': 'y'};
    return bestrect
def open_file_selector_masks():
    #root.withdraw() 
    file_path = filedialog.askopenfilename(
        filetypes=[("PNG files", "*.png"), ("All files", "*.*")]
    )
    if file_path:
        mask_to_rects(file_path)

def open_file_selector_sprites():
    print("Opening File Selector...")
    #root.withdraw()  # Close the root window
    paths = [];
    resultstrings = [];
    totalbytes = 0;
    
    color_list = parse_png(f"{os.path.dirname(os.path.realpath(__file__))}/palette.png")
    while True:
        file_path = filedialog.askopenfilename(
            title="Select a PNG file/File List (Cancel to finish)",
            filetypes=[("PNG files or File Lists", "*.png *.filelist")]
        )
        if file_path:
            if ".filelist" in file_path:
                with open(file_path, 'r', encoding='utf-8') as fr:
                    countbytes = 0;
                    for listadd in fr.read().split('\n'):
                        if listadd in paths:
                            continue;
                        if len(listadd) < 2:
                            continue;
                        res = color_to_indices(listadd, color_list, True);
                        resultstrings.append(res['result'])
                        countbytes += res['bytes']
                        paths.append(listadd);
                    print(f"Added file list '{Path(file_path).stem} ({countbytes} bytes)'")
                    totalbytes += countbytes;
                continue;
            if file_path in paths:
                continue;
            res = color_to_indices(file_path, color_list, True);
            resultstrings.append(res['result'])
            paths.append(file_path);
            print(f"Added sprite '{Path(file_path).stem}'! ({res['bytes']} bytes)")
            totalbytes += res['bytes'];
        else:
            break;
    pyperclip.copy('\n    '.join(resultstrings))
    print(f"Copied {len(paths)} sprites to clipboard!\nTotal: {totalbytes} Bytes")
    saveFileList = input(f"\nSave File List Name (Leave blank to not save)?:\n ")
    if len(saveFileList) > 1:
        output_path_file_list = rf'{os.path.dirname(os.path.realpath(__file__))}/FileLists/{saveFileList}.filelist'
        with open(output_path_file_list, 'w', encoding='utf-8') as f:
            f.write('\n'.join(paths))
        print(f"Saved File List to {output_path_file_list}!")

def hex_to_rgba(hex_code):
    """Convert a hex color code to an RGBA tuple."""
    hex_code = hex_code.lstrip('#')
    if len(hex_code) == 6:
        hex_code += 'FF'
    return tuple(int(hex_code[i:i + 2], 16) for i in range(0, 8, 2))


def get_brightness(color):
    r, g, b, _ = color
    return colorsys.rgb_to_hsv(r / 255.0, g / 255.0, b / 255.0)[2]


def add_image_to_palette(file, all_colors, ordered_palette):
    with Image.open(file) as img:
        img = img.convert('RGBA')
        new_colors = {color for color in img.getdata() if color not in all_colors and color[3] >= 10}
        sorted_new_colors = sorted(new_colors, key=get_brightness)
        all_colors.update(sorted_new_colors)
        ordered_palette.extend(sorted_new_colors)

def extract_palette_from_sprites():
    initial_colors_input = input(
        "Enter a list of hex color codes separated by commas (e.g. #123456, #FFFFFF, #a029bf): ")
    file_list = [];
    initial_colors = [];
    if len(initial_colors_input.split(',')) > 5:
        initial_colors = [hex_to_rgba(color.strip()) for color in initial_colors_input.split(',')]

    all_colors = set(initial_colors)
    ordered_palette = initial_colors.copy()

    while True:
        file = filedialog.askopenfilename(
            title="Select a PNG file/File List (Cancel to finish)",
            filetypes=[("PNG files or File Lists", "*.png *.filelist")]
        )
        if not file:
            break
        if ".filelist" in file:
            with open(file, 'r', encoding='utf-8') as fr:
                for listadd in fr.read().split('\n'):
                    add_image_to_palette(listadd, all_colors, ordered_palette)
                    file_list.append(listadd)
            continue
        add_image_to_palette(file, all_colors, ordered_palette)
        file_list.append(file)
    if len(file_list) == 0:
        return;
    if len(ordered_palette) > 256:
        ordered_palette = ordered_palette[:256]
    while len(ordered_palette) < 256:
        ordered_palette.append((0, 0, 0, 255))
    texture = Image.new('RGBA', (16, 16))
    texture.putdata(ordered_palette)
    shutil.copyfile(
        f"{os.path.dirname(os.path.realpath(__file__))}/palette.png", 
        f"{os.path.dirname(os.path.realpath(__file__))}/Backups/palette{str(int(time.time()))}.png"
    )
    output_path = f"{os.path.dirname(os.path.realpath(__file__))}/palette.png"
    texture.save(output_path)
    print(f"16x16 Texture saved to '{output_path}'!")
    
    save_file_list = input("\nSave File List Name (Leave blank to not save)?:\n ")
    if len(save_file_list) > 1:
        output_path_file_list = rf'{os.path.dirname(os.path.realpath(__file__))}/FileLists/{save_file_list}.filelist'
        with open(output_path_file_list, 'w', encoding='utf-8') as f:
            f.write('\n'.join(file_list))



mode = 0
modesText = ["Sprite", "Mask", "Multiple Sprites", "Copy Palette", "Extract Palette"]
modesInfo = [
    "Select a sprite .PNG to import it.\nSprites are drawn images with color.",
    "Select a .png of a mask (solid color & transparent pixels for none)\nMasks work in a solid-color sort of way,\nand only count non-empty pixels.\nThey will output a list of rects which make up the 'mask'.",
    "Select multiple sprite .PNGs to import them all in order of selection.\nSprites are drawn images with color.\nCancel to finish your selection.",
    "This copies the palette code to your clipboard.\nPalette is located in the directory of this script, as 'palette.png'.",
    "This takes a list of selected image .pngs in order, and creates a palette image.\nThe palette will be stored in the directory of this script, as 'palette.png'\nThe previous 'palette.png' will be backed up.\nThe palette is ordered first by file selection order, then color brightness (dark to light).\nWhen saving the palette, you can optionally save the ordered file list for future imports."]

itt = 0;
ith = 0;
while True:
    inputtext = "Select Mode\n0 - Sprite\n1 - Mask\n2 - Multiple Sprites\n3 - Copy Palette\n4 - Extract Palette From Sprites\nMode: ";
    if (itt > 0):
        inputtext = "\nNew Mode (blank to exit, 'help' for mode list): "
    modeText = input(inputtext)
    if len(modeText) == 0:
        break;
    if modeText.lower() == "help":
        itt = 0;
        ith += 1;
        continue;
    try:
        mode = int(modeText)
        print(f"'{modesText[mode]}' Mode Info:\n{modesInfo[mode]}");
    except:
        mode = 0;
        print(f"Invalid input, expecting a mode number, 'help', or blank for exit.");
        itt += 1;
        ith += 1;
        continue;

    if (ith == 0):
        root = tk.Tk()
        root.withdraw()
    match mode:
        case 0: # Sprite Mode V
            open_file_selector_sprite()
        case 1: # Mask Mode V
            open_file_selector_masks()
        case 2: # Multiple Sprites Mode V
            open_file_selector_sprites()
        case 3: # Copy Palette V
            pyperclip.copy(rgb_values_string(f"{os.path.dirname(os.path.realpath(__file__))}/palette.png"))
            print(f"\nPalette Total: {256*3} bytes")
            print("Palette copied to clipboard!")
        case 4: # Extract Palette From Sprites
            extract_palette_from_sprites()
    itt += 1;
    ith += 1;


