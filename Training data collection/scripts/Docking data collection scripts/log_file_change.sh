#!/bin/bash
for dir in ligand*/; do
    dir_name=$(basename "$dir")
    awk -v d="$dir_name" 'BEGIN { flag = 0 } { if ($1 == "1") { flag = 1 } if (flag == 1) { $1 = d; flag = 0 } print }' "${dir}log.txt" > "${dir}log_new.txt"
    mv "${dir}log_new.txt" "${dir}log.txt"
done
