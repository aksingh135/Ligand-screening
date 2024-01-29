#!/bin/bash

for file in cid_*.sdf; do
  basename="${file%.sdf}"
  echo "Coverting $file to ${basename}.pdbqt"
  mk_prepare_ligand.py -i "$file" -o "${basename}.pdbqt"

done
  
