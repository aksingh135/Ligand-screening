# Developing a workflow for GPR119 agonist screening using machine learning techniques 

### Introduction:
This project focuses on reducing the experimental search space by computationally detecting GPR119 ligands using machine learning techniques. Transfer learning is leveraged here by employing a pre-trained model: **ChemBERTa** to build classifiers to distinguish between GPR119 binder and non-binders. Docking scores from AutoDock Vina and experimental data obtained from in-lab assays and [GlassDB](https://zhanggroup.org/GLASS/) were used as features for this model. This repository contains all the scripts and the subsequent data obtained for this pipeline. Conclusionary remarks about the outcomes and potential use of the obtained models can be found at the end of this document.

### Project outline:
<img width="550" height="400" alt="image" src="https://github.gatech.edu/storage/user/68782/files/a1ed9476-a5da-4bb1-9dba-19a3925d9267">

### Repository Structure and Script Functionalities
1. Training data collection
   1. Docking positive and negative datasets

      Positive dataset: 

         - Comes with combined sdf data
         - Split it using obabel: `obabel Q8TDV5.sdf -O p\_ligand.sdf -m`
         - 1429 files
         - Converted to pdbqt using obabel: `obabel \*.sdf -opdbqt -m`
         - dock

      Negative dataset: 

         - Obtain pubchem ids  using CAS using script: [Adding_PubChemID.ipynb]        (https://colab.research.google.com/drive/16O843ywIjOWKuvpDEvfsmMGSJ8GrKdsY#scrollTo=pf98cWOiVa22)
         - Using cids obtain 3d sdf structures that are available 
         - Sdf to pdbqt using meeko (pic of script)
         - dock

      DOCK: run\_vina\_pos.sh

      Conf file: conf\_all\_p.txt
      Report: dock\_pos.out
      Receptor: pos\_protein.pdbqt
      Docking command job script: p\_docking\_cmds.sbatch

1. Collecting docking data
   1. Log\_file\_change.sh #to replace the first 1. With filename so we can directly extract the best binding score without losing file name
   1. Merging\_logs.sh
   1. logs\_extract\_merged.py
   1. Merged\_log.txt
   1. Cleaning step: awk ‘/^p\_lig/’ merged\_log.txt > output.txt
   1. View output.txt in excel
1. Feature selection

Docking data: convert to binary using script: [BioAssay_Activity.ipynb](https://colab.research.google.com/drive/1lHBy0eFzV4cYg5f3pb8xqcsQuLhCiIyM#scrollTo=qWW7desIV_d9)

Experimental: convert to binary

1. LLM model and predictions 
   multi-label: [Multi-label_classification_with_ChemBERTa.ipynb](https://colab.research.google.com/drive/1720FLC2LUZ_Y_Yysk5MNVU_oKv5kNdCd) 
   binary: [Classification_with_ChemBERTa.ipynb](https://colab.research.google.com/drive/1NIQIhbKqvZGcaEqI0mABlC4jflefuJFT)
