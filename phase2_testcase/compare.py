
def hex_to_float(hex_str):
    """Convert a hexadecimal string to a floating-point number."""
    return struct.unpack('!f', bytes.fromhex(hex_str))[0]

def compare_floats(f1, f2, tolerance=0.0001):
    """Compare two floating-point numbers with a given tolerance."""
    return abs(f1 - f2) <= tolerance * max(abs(f1), abs(f2))

def compare_files(file1, file2):
    """Compare two files containing IEEE754 floating-point numbers."""
    error_count = 0
    total_count = 0
    
    with open(file1, 'r') as f1, open(file2, 'r') as f2:
        for line1, line2 in zip(f1, f2):
            numbers1 = line1.strip().split()
            numbers2 = line2.strip().split()
            total_count += 1

            if len(numbers1) != len(numbers2):
                error_count += 1
                continue

            for hex1, hex2 in zip(numbers1, numbers2):
                float1 = hex_to_float(hex1)
                float2 = hex_to_float(hex2)

                if not compare_floats(float1, float2):
                    error_count += 1
            
    return float(error_count) / total_count

import struct

# Replace these with your file paths
file1_path = 'CheckFile.txt'
file2_path = 'SampleFile.txt'
rate = compare_files(file1_path, file2_path)

print("Error rate:", str(rate))