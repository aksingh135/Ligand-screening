#!/bin/bash

filename="numbers.txt"
folder="sdfs"

# Create the folder if it doesn't exist
mkdir -p "$folder"

numbers=($(cat "$filename"))

for number in "${numbers[@]}"; do
    wget "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/${number}/record/SDF?record_type=3d" -O "$folder/compound_${number}.sdf"
done
