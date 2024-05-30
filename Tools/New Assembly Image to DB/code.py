from PIL import Image
import pyperclip
import tkinter as tk
from tkinter import filedialog

def color_to_indices(image_path, color_list):
    # Open the image
    img = Image.open(image_path)
    img = img.convert('RGB')  # Ensure image is in RGB mode

    # Convert color codes to RGB tuples
    color_tuples = [tuple(int(c[i:i+2], 16) for i in (1, 3, 5)) for c in color_list]

    result_indices = []

    # Get image dimensions
    width, height = img.size

    for y in range(height):
        for x in range(width):
            pixel = img.getpixel((x, y))
            if pixel in color_tuples:
                result_indices.append(str(color_tuples.index(pixel)))
            else:
                result_indices.append('0')

    result_string = ','.join(result_indices)

    # Copy result string to the clipboard
    pyperclip.copy(result_string)
    print("String copied to clipboard!")

def open_file_selector():
    root = tk.Tk()
    root.withdraw()  # Close the root window
    
    file_path = filedialog.askopenfilename(
        filetypes=[("PNG files", "*.png"), ("All files", "*.*")]
    )
    
    if file_path:
        color_list = ["#603A5B", "#331D27", "#FFFFFF", "#FFFC75"]
        color_to_indices(file_path, color_list)

# Run the file selector
open_file_selector()