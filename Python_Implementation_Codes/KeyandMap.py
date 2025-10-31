import numpy as np
import csv
import json



# === Hardcoded positions for each digit 1–9 --- are 0 indexed ===
# Example: {digit: position_of_1_to_use}
hardcoded_positions = {
    1: 59,
    2: 39,
    3: 45,
    4: 37,
    5: 50,
    6: 44,
    7: 52,
    8: 41,
    9: 54
}

# === Load patterns from CSV ===
patterns = []  # each item is a list of 0/1 for that digit (digit 1-9)

with open("NEST_output/normalized_matrix.csv", "r") as file:
    reader = csv.reader(file)
    for row in reader:
        # Convert string bits to integers
        pattern = pattern = [int(float(bit.strip())) for bit in row]
        patterns.append(pattern)

# === Generate map and key for each digit ===
results = {}

results[0] = {
    "selected_pos": "NA",
    "map_val": 0,
    "quotient": 0,
    "key_val": "NA"
}


for digit in range(1, 10):
    pattern = patterns[digit]

    # Get all positions of 1s in this pattern
    ones_pos = [i for i, bit in enumerate(pattern) if bit == 1]
    print(ones_pos)

    # Get the hardcoded position for this digit
    selected_pos = hardcoded_positions[digit]

    if selected_pos not in ones_pos:
        print(f" Digit {digit}: Selected position {selected_pos} is not a '1' bit.")
        continue

    map_val = selected_pos % 16
    quotient = selected_pos // 16
    key_val = ones_pos.index(selected_pos)  # Index in the 1s-only list

    results[digit] = {
        "selected_pos": selected_pos,
        "map_val": map_val,
        "quotient": quotient,    # for info, not used in encryption
        "key_val": key_val
    }

# === Print result ===
print("Digit | Pos | Rem(map_value) | Quot | Key (where is 1 in 1s-only list)")
print("-" * 40)
for d, info in results.items():
    print(f"  {d}   | {info['selected_pos']:>3} |  {info['map_val']:>2}  |  {info['quotient']:>2}   |   {info['key_val']}")

with open("digit_map_key.json", "w") as jsonfile:
    json.dump(results, jsonfile, indent=4)
