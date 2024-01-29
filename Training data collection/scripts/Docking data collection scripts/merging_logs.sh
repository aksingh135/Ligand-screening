#! /bin/bash
for f in n_ligand*/; do
    cat ${f}/log.txt >> all_logs.txt
done
