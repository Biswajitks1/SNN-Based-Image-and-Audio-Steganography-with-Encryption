# Adds alpha channel and adds noise, masks the last two bits # resizing is removed
import os
import numpy as np
import cv2

# Define input and output Image directories
input_Img_dir = os.path.join(os.getcwd(), "input_images/png_images")
output_Img_dir = os.path.join(input_Img_dir, "../with_alpha")

# # Define the input data to be encoded directory
# input_data_dir = os.path.join(os.getcwd(), "input_data")
# data_file = np.load(f"{input_data_dir}/data1.npy")

# Create output directory if it doesn't exist
os.makedirs(output_Img_dir, exist_ok=True)

# Process each PNG image
for img_file in sorted(os.listdir(input_Img_dir)):
    if img_file.lower().endswith(".png"):
        img_path = os.path.join(input_Img_dir, img_file)
        
        # Load image
        img = cv2.imread(img_path, cv2.IMREAD_UNCHANGED)  # Preserve alpha channel
        if img is None:
            print(f"Skipping {img_file}: Unable to read")
            continue

        # Convert to RGBA if needed
        if img.shape[2] != 4:
            print(f"{img_file} does NOT have an alpha channel. Adding alpha...")
            b, g, r = cv2.split(img)
            alpha = 255 * np.ones(b.shape, dtype=b.dtype)
            img = cv2.merge((b, g, r, alpha))
        else:
            print(f"{img_file} already has an alpha channel.")


        print(f"{img_file} shape is {img.shape}.")

        # Adding the noise

        noise = np.random.randint(0, 4, img.shape, dtype=np.uint8)
        img_temp = img.astype(np.int16)
        noisy_img_temp = img_temp + noise
        valid_mask = (noisy_img_temp >= 0) & (noisy_img_temp <= 255)
        img_noisy = img.copy()
        img_noisy[valid_mask] = (img_temp + noise)[valid_mask].astype(np.uint8)

        # Mask the last two bits
        img_masked = img_noisy & 0b11111100

        if(img_masked.dtype != 'uint8'):
            print("ERROR")
            exit()

        # Save to output
        output_path = os.path.join(output_Img_dir, img_file)
        cv2.imwrite(output_path, img_masked)

        print(f"Processed: {img_file} → Saved to {output_Img_dir}")

print("All images processed successfully!")
