import os
from PIL import Image

def upscale_pngs():
    # Get the current working directory
    current_folder = os.getcwd()

    # Iterate through all files in the current folder
    for filename in os.listdir(current_folder):
        if filename.endswith(".png"):
            file_path = os.path.join(current_folder, filename)

            # Open the image
            with Image.open(file_path) as img:
                # Calculate new size (4x)
                new_width = img.width * 4
                new_height = img.height * 4

                # Resize using NEAREST (no filtering or smoothing)
                upscaled_img = img.resize((new_width, new_height), Image.NEAREST)

                # Save the upscaled image with a new name
                new_filename = f"upscaled_{filename}"
                upscaled_img.save(os.path.join(current_folder, new_filename))

                print(f"Upscaled and saved: {new_filename}")

if __name__ == "__main__":
    upscale_pngs()
