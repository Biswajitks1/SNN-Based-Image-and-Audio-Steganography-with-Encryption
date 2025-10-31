import numpy as np
import cv2
import os
import json
import csv

# Load digit mapping (from your key file)
with open("digit_map_key.json", "r") as f:
    digit_map = json.load(f)

# Load normalized patterns (each row = 1 digit's spike pattern)
patterns = []
with open("normalized_matrix.csv", "r") as file:
    reader = csv.reader(file)
    for row in reader:
        pattern = [int(float(bit.strip())) for bit in row]
        patterns.append(pattern)

def decrypt_digit(encrypted_val):

    # Special case: if remainder is 0, it's digit 0
    if encrypted_val == 0:
        return 0

    possible_positions = [encrypted_val + 16 * i for i in range(4)]

    for digit in range(1, 10):
        pattern = patterns[digit - 1]
        ones = [i for i, bit in enumerate(pattern) if bit == 1]

        for pos in possible_positions:
            if pos in ones:
                index_in_ones = ones.index(pos)  # where does pos occur in the 1s-only list
                expected_key = digit_map[str(digit)]["key_val"]
                if index_in_ones == expected_key:
                    return digit  

    # If nothing matched
    raise ValueError(f"No matching digit found for encrypted_val = {encrypted_val}")

def extract_data_from_images(image_folder, output_folder):
    image_files = sorted([f for f in os.listdir(image_folder) if f.endswith(".png")])
    if not image_files:
        raise ValueError("No PNG images found in the folder")
    
    os.makedirs(output_folder, exist_ok=True)
    
    for img_file in image_files:
        extracted_values = []
        img = cv2.imread(os.path.join(image_folder, img_file), cv2.IMREAD_UNCHANGED)
        h, w, c = img.shape
        if c != 4:
            raise ValueError("Images must have 4 channels (RGBA)")
        
        pixel_idx = 0

        while pixel_idx + 2 < h * w:  # Ensure enough pixels remain
            bit_pairs = []

            # Read 3 pixels (24 bits)
            for _ in range(3):
                if pixel_idx >= h * w:
                    break
                y, x = divmod(pixel_idx, w)

                # Extract lower 2 bits from each channel
                b = img[y, x, 0] & 0x03  # B
                g = img[y, x, 1] & 0x03  # G
                r = img[y, x, 2] & 0x03  # R
                a = img[y, x, 3] & 0x03  # A

                bit_pairs.extend([b, g, r, a])  # 4 values per pixel (total 12 for 3 pixels)
                pixel_idx += 1
            

            if len(bit_pairs) < 12:
                print("error")
                break  # Incomplete data at the end
            
            # Convert back to digits
            digits = []
            for i in range(0, 12, 2):
                digit = (bit_pairs[i] << 2) | bit_pairs[i + 1]  # Convert two 2-bit values into a 4-bit digit
                digits.append(digit)

            #decrypting the digits
            decrypted_digits = [decrypt_digit(d) for d in digits]

            # Interpret the first digit as the sign (assuming a 4-bit sign)
            sign = -1 if decrypted_digits[0] == 1 else 1  # If MSB is set, it's negative
            
            # Convert the remaining digits to an integer value
            value = 0
            for d in decrypted_digits[1:]:
                value = (value * 10) + int(d)  # Shift left and add new digit
            
            value *= sign  # Apply sign
            extracted_values.append(value)

        # Reshape to stereo sound format
        extracted_values = np.array(extracted_values, dtype=np.int32)
        # extracted_values = np.array(extracted_values, dtype=np.int16)
        if len(extracted_values) % 2 != 0:
            extracted_values = extracted_values[:-1]  # Ensure even number of samples
        extracted_values = extracted_values.reshape(-1, 2)  # Reshape back to (N, 2)

        # Save each extracted sound separately
        output_sound_file = os.path.join(output_folder, os.path.splitext(img_file)[0] + ".npy")
        np.save(output_sound_file, extracted_values)
        print(f"Data extracted from {img_file} and saved to {output_sound_file}")

# usage
image_folder = "encrypted_output"
output_folder = "decrypted_output"
os.makedirs(output_folder, exist_ok=True)
extract_data_from_images(image_folder, output_folder)