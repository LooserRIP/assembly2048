from PIL import Image
from tkinter import filedialog, Tk
import colorsys


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


def main():
    root = Tk()
    root.withdraw()  # Hide the root window

    # Get initial color codes from the user
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

    # Convert list to ensure only 256 colors max, maintaining the order
    if len(ordered_palette) > 256:
        ordered_palette = ordered_palette[:256]

    # Fill the rest with black if fewer than 256 colors
    while len(ordered_palette) < 256:
        ordered_palette.append((0, 0, 0, 255))

    # Create a 16x16 texture
    texture = Image.new('RGBA', (16, 16))
    texture.putdata(ordered_palette)

    # Save the resulting texture
    output_path = r'C:\Users\User\Documents\GitHub\Other\assembly2048\Tools\Palette Extracter\generated.png'
    texture.save(output_path)
    print('16x16 texture saved at:', output_path)
    save_file_list = input(
        "Saved files file name? (blank for none): ")
    if len(save_file_list) > 1:
        output_path_file_list = rf'C:\Users\User\Documents\GitHub\Other\assembly2048\Tools\Palette Extracter\{save_file_list}.filelist'
        with open(output_path_file_list, 'w', encoding='utf-8') as f:
            f.write('\n'.join(file_list))

if __name__ == "__main__":
    main()