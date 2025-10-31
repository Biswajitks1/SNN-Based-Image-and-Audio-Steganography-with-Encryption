import numpy as np
import cv2
import os
import json

# Loading the JSON map
with open("digit_map_key.json", "r") as f:
    mapping_dict = json.load(f)


def embed_data_in_images(image_folder, data_file, output_folder):
    # Load the sound file
    sound_data = np.load(data_file)  # Shape: (N, 2)
    flattened_data = sound_data.flatten()  # Convert to 1D (interleaved left-right channels)

    # Get all image files
    image_files = sorted([f for f in os.listdir(image_folder) if f.endswith(".png")])
    if not image_files:
        raise ValueError("No PNG images found in the folder")
    
    for img_file in image_files:
        img = cv2.imread(os.path.join(image_folder, img_file), cv2.IMREAD_UNCHANGED)
        h, w, c = img.shape
        if c != 4:
            raise ValueError("Images must have 4 channels (RGBA)")
        
        pixel_idx = 0

        # adjusting for any size of image
        max_values = (h * w) // 3

        if len(flattened_data) > max_values:
            print(f"Warning: Data length {len(flattened_data)} exceeds available pixels {h} * {w} = {max_values}. Truncating data.")


        data_to_embed = flattened_data[:max_values]  # Limit to the number of pixels available 

        for value in data_to_embed:
            # Convert the value into a signed 5-digit string
            sign = 0 if value >= 0 else 1
            digits = [sign] + [int(d) for d in f"{abs(value):05d}"]  # 6 digits in total

            #replacing with the map values
            encrypted_digits = []
            for d in digits:
                d_str = str(d)
                encrypted_digits.append(mapping_dict[d_str]["map_val"])
            
            bit_pairs = []
            for d in encrypted_digits:
                bits = f"{d:04b}"  # Convert to 4-bit binary
                bit_pairs.append(int(bits[:2], 2))  # First 2 bits
                bit_pairs.append(int(bits[2:], 2))  # Last 2 bits

            # Embed into 3 pixels (since each pixel holds 8 bits)
            for i in range(0, 12, 4):  # Process 4 channels at a time
                if pixel_idx >= h * w:
                    break  # Stop if image is full
                
                # Get pixel position
                y, x = divmod(pixel_idx, w)

                img[y, x, 0] = (img[y, x, 0] & 0xFC) | bit_pairs[i]   # B
                img[y, x, 1] = (img[y, x, 1] & 0xFC) | bit_pairs[i+1] # G
                img[y, x, 2] = (img[y, x, 2] & 0xFC) | bit_pairs[i+2] # R
                img[y, x, 3] = (img[y, x, 3] & 0xFC) | bit_pairs[i+3] # A

                pixel_idx += 1
                
        # Save the modified image
        cv2.imwrite(os.path.join(output_folder, img_file), img)

# usage
image_folder = "input_images/with_alpha"
data_file = "input_data/data1.npy"
output_folder = "encrypted_output"
os.makedirs(output_folder, exist_ok=True)
embed_data_in_images(image_folder, data_file, output_folder)
print("Data embedded successfully!")