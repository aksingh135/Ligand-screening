#! /bin/bash

for f in n_ligand*.pdbqt; do
    b=`basename $f .pdbqt`
    echo Processing ligand $b
    mkdir -p $b
    ./autodock_vina_1_1_2_linux_x86/bin/vina --config conf_all_n.txt --ligand $f --out ${b}/out.pdbqt --log ${b}/n_log.txt
   
done
