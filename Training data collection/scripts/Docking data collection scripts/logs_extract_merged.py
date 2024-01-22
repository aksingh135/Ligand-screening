import re
import os
import csv

# File paths
input_file_path = '/Users/akshitasingh/Downloads/all_logs_n.txt'
output_file_directory = '/Users/akshitasingh/Desktop/PPY-LAB/' #needed for the individual output files
output_file_prefix = 'o_temp' #prefix for output files
merged_logs_file = '/Users/akshitasingh/Desktop/PPY-LAB/merged_log_n.txt'

# REGEX to extract the binding energy tables occuring between pattern1 and pattern2
pattern1 = r'(\-*\+*\-*\+*\-*\+*\--+)'  # Updated pattern with capturing parentheses
pattern2 = r'Writing output \.\.\. done\.'

# Reading the input file
with open(input_file_path, 'r') as input_file:
    input_text = input_file.read()

# Locating all the REGEX matching patterns and storing pattern1 and pattern2 occurances in matches1 and matches2 respectively
matches1 = re.finditer(pattern1, input_text)
matches2 = re.finditer(pattern2, input_text)
''' # Checking the contents of matches1 and matches2 and counting the occurrences:
a = 0
for x in matches1:
    print(x)
    a += 1
print(a)
b = 0
for y in matches2:
    print(y)
    b += 1
print(b)
'''

merged_logs = '' #Initializing merged logs to store the concatenated text
output_counter = 1 #Keeping track of the output file number

# Loop through the matches
for match1 in matches1: #iterating over matches found by pattern1
    # Find the corresponding match2
    '''match2 = None #removing this because there is no case where you won't fine match2'''

    for m in matches2: #iterating over matches found by pattern2
        if m.start() > match1.start():
        #The above condition checks if the start position of the match found by matches2 is greater than the start position of the current match found by matches1 thus resolving the issue of duplicate patterns of matches2 occurring in the text as the conditional ensures that only matches from matches2 that occur after the current match in matches1 are considered.
            match2 = m
            break

    '''if match2 is None: #removing this because there is no case where you won't fine match2
        break'''

    # Extracting the text between pattern1 and pattern2
    log = input_text[match1.end():match2.start()]
    merged_logs += log #appending the text contained in the log variable to the merged_logs variable

    # Creation of output file path
    output_file_path = f'{output_file_directory}{output_file_prefix}{output_counter}.txt'

    # Writing the extracted text to the output file
    with open(output_file_path, 'w') as output_file:
        output_file.write(log)

    # Incrementing for the next output file
    output_counter += 1

# Writing the merged logs variable to the merged_logs_file
with open(merged_logs_file, 'w') as output_file:
    output_file.write(merged_logs)

# Deleting the individual output files
for i in range(1, output_counter):
    output_file_path = f'{output_file_directory}{output_file_prefix}{i}.txt'
    os.remove(output_file_path)