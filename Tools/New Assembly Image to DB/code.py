from PIL import Image
import pyperclip
import tkinter as tk
from tkinter import filedialog
from pathlib import Path

def to_little_endian_bytes(value):
    """Convert an integer value to a little-endian byte representation."""
    # Ensure value is within the range of a 16-bit unsigned integer.
    if not (0 <= value <= 65535):
        raise ValueError("Value must be between 0 and 65535")
    low_byte = value & 0xFF
    high_byte = (value >> 8) & 0xFF
    return f"{low_byte},{high_byte}"

def color_to_indices(image_path, color_list):
    # Open the image
    imgpure = Image.open(image_path)
    img = imgpure.convert('RGB')  # Ensure image is in RGB mode
    imgalpha = imgpure.convert('RGBA')  # Ensure image is in RGB mode

    # Convert color codes to RGB tuples
    color_tuples = [tuple(int(c[i:i+2], 16) for i in (1, 3, 5)) for c in color_list]

    finals = []
    result_indices = []
    maxperline = 260
    i = 0;

    # Get image dimensions
    width, height = img.size

    for y in range(height):
        for x in range(width):
            pixel = img.getpixel((x, y))
            pixelalpha = imgalpha.getpixel((x, y))
            if pixel in color_tuples:
                if pixelalpha[3] == 0:
                    result_indices.append('0')
                else:
                    result_indices.append(str(color_tuples.index(pixel)+1))
            else:
                result_indices.append('0')
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
    result_string = f"    {filename} db {to_little_endian_bytes(width)},{to_little_endian_bytes(height)}," + '\n              db '.join(finals)
    # Copy result string to the clipboard
    pyperclip.copy(result_string)
    print("Sprite copied to clipboard!")

def rgb_to_hex(rgb):
    return f'#{rgb[0]:02X}{rgb[1]:02X}{rgb[2]:02X}'

def parse_png(file_path):
    # Open image file
    img = Image.open(file_path)

    # Verify image dimensions (16x16)
    if img.size != (16, 16):
        raise ValueError("Image dimensions must be 16x16")

    # Convert image to RGB (to standardize the format)
    img = img.convert('RGB')

    # Initialize an empty list to store the color hex codes
    color_hex_codes = []

    # Traverse the image row by row
    for y in range(16):
        for x in range(16):
            # Get the RGB value of the pixel
            rgb = img.getpixel((x, y))
            # Convert RGB to Hex format and add to the list
            color_hex_codes.append(rgb_to_hex(rgb))

    return color_hex_codes

def rgb_values_string(file_path):
    # Open image file
    img = Image.open(file_path)

    # Verify image dimensions (16x16)
    if img.size != (16, 16):
        raise ValueError("Image dimensions must be 16x16")

    # Convert image to RGB (to standardize the format)
    img = img.convert('RGB')

    # Initialize an empty list to store the RGB values
    final = [];
    # Traverse the image row by row
    for y in range(16):
        rgb_values = []
        for x in range(16):
            # Get the RGB value of the pixel
            rgb = img.getpixel((x, y))
            # Add each component of the RGB value to the list
            rgb_values.extend(rgb)
        final.append(','.join(map(str, rgb_values)))

    # Convert the list of RGB values to a comma-separated string
    return '    rendering_palette db ' + '\n              db '.join(final)

def open_file_selector():
    root = tk.Tk()
    root.withdraw()  # Close the root window
    
    file_path = filedialog.askopenfilename(
        filetypes=[("PNG files", "*.png"), ("All files", "*.*")]
    )
    
    if "palette.png" in file_path:
        pyperclip.copy(rgb_values_string("palette.png"))
        print("Palette copied to clipboard!")
    else:
        if file_path:
            color_list = parse_png("palette.png")
            color_to_indices(file_path, color_list)

# Run the file selector
open_file_selector()