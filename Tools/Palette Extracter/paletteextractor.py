from PIL import Image
from tkinter import filedialog, Tk

# Open a file dialog to select files
root = Tk()
root.withdraw()  # Hide the root window
files = filedialog.askopenfilenames(
    title="Select PNG files",
    filetypes=[("PNG files", "*.png")]
)

all_colors = set()

# Extract unique colors from each image
for file in files:
    with Image.open(file) as img:
        img = img.convert('RGBA')
        all_colors.update(img.getdata())

# Convert set back to list and ensure only 256 colors max
all_colors = list(all_colors)
if len(all_colors) > 256:
    all_colors = all_colors[:256]

# Fill the rest with black if fewer than 256 colors
while len(all_colors) < 256:
    all_colors.append((0, 0, 0, 255))

# Create the 16x16 texture
texture = Image.new('RGBA', (16, 16))
texture.putdata(all_colors)

# Save the resulting texture
texture.save('texture16x16.png')
print('16x16 texture saved as texture16x16.png')