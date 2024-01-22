#! /bin/bash

for f in p_ligand*.pdbqt; do
    b=`basename $f .pdbqt`
    echo Processing ligand $b
    mkdir -p $b
    ./autodock_vina_1_1_2_linux_x86/bin/vina --config conf_all_p.txt --ligand $f --out ${b}/out.pdbqt --log ${b}/p_log.txt
   
done
