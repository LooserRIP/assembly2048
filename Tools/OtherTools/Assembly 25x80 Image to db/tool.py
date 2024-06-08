from PIL import Image
import numpy as np
import tkinter as tk
from tkinter import filedialog
def main():
    root = tk.Tk()
    root.withdraw()
    
    file_path = filedialog.askopenfilename()
    img = Image.open(file_path).convert('L') 
    img = img.resize((80, 25)) 
    img_arr = np.asarray(img)

    img_arr = np.where(img_arr <= 85, 2, img_arr)  # black
    img_arr = np.where((img_arr > 85) & (img_arr <= 170), 1, img_arr)  # gray
    img_arr = np.where(img_arr > 170, 0, img_arr)  # white


    for row in img_arr:
        row_str = 'db ' + ','.join(map(str, row))
        print(row_str)
if __name__ == "__main__":
    main()