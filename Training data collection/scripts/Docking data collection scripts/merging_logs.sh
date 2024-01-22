#! /bin/bash
for f in all_ligands_ligand_*/; do
    cat ${f}/log.txt >> all_logs.txt
done