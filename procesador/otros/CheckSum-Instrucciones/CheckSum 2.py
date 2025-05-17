def calculate_checksums(s):
    # Split the string into a list of lines
    lines = s.strip().split('\n')

    # Initialize an empty list to store the modified lines
    modified_lines = []

    # Iterate through the lines
    for line in lines:
        # Initialize the checksum to 0
        checksum = 0

        # Split the line into a list of numbers (bytes)
        numbers = [line[i:i+2] for i in range(0, len(line), 2)]

        # Add each number to the checksum, taking modulo 256
        for number in numbers:
            checksum = (checksum + int(number, 16)) % 256

        # Compute the two's complement checksum
        checksum = (~checksum + 1) & 0xFF

        # Convert the checksum to a hexadecimal string and append it to the line
        checksum_str = '{:02X}'.format(checksum)
        modified_lines.append(line + checksum_str)

    # Join the modified lines into a single string and return it
    return '\n'.join(modified_lines)

# Input data as a multiline string
data = """
0400000000000013
0400040040000113
"""

# Call the function and print the result
print(calculate_checksums(data))
