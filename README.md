# Developing a workflow for GPR119 agonist screening using machine learning techniques 

## Introduction:
This project focuses on reducing the experimental search space by computationally detecting GPR119 ligands using machine learning techniques. Transfer learning is leveraged here by employing a pre-trained model: **ChemBERTa** to build classifiers to distinguish between GPR119 binder and non-binders. Docking scores from AutoDock Vina and experimental data obtained from in-lab assays and GlassDB were used as features for this model. This repository contains all the scripts and the subsequent data obtained for this pipeline. For a comprehensive understanding of the results and the potential uses of the models derived, please refer to the concluding remarks at the end of this document.

## Project outline:
<p align="center">
  <img width="550" height="400" alt="image" src="https://github.gatech.edu/storage/user/68782/files/a1ed9476-a5da-4bb1-9dba-19a3925d9267">
</p>

## Repository Structure and Script Functionalities
### 1. Training Data Collection
- Docking Positive and Negative Datasets:
    - Positive dataset: Sourced from [GlassDB](https://zhanggroup.org/GLASS/) by querying *Homo sapiens* GPR119-ligand interaction data.
        - 1429 GPR119-ligand interaction data was obtained
        - Comes with combined sdf structure file of all of the ligands (Q8TDV5.tsv)
        - In order to carry out docking, individual sdf files were first obtained by splitting the file using obabel: `obabel Q8TDV5.sdf -O p\_ligand.sdf -m`
        - Finally, the sdf files were converted to pdbqt format for docking: `obabel \*.sdf -opdbqt -m`
        - The docking scripts were prepared and executed in the order:
            1. pos\_protein.pdbqt (named separetely for positive and negative docking to allow for simultaneous multiple ligand docking runs)
            2. conf\_all\_p.txt (configuration file for docking)
            3. run\_vina\_pos.sh (bash script for multiple ligand docking of the positive dataset)
            4. p\_docking\_cmds.sbatch (job script to submit to slurm)
    - Negative dataset: Sourced from Selleck's Anti-infection and Natural Product libraries (previous tested on GPR119 biosensor and known **NOT** to bind to GPR119).
        - The PubChem IDs (CIDs) were derived using the given CAS numbers via the script: [Adding_PubChemID.ipynb]        (https://colab.research.google.com/drive/16O843ywIjOWKuvpDEvfsmMGSJ8GrKdsY#scrollTo=pf98cWOiVa22)
        - Using these CIDs availiable 3D sdf structures of the negative dataset were obtained by executing `bash sdf.sh`.
        - File conversion from sdf to pdbqt was done using [Meeko](https://github.com/forlilab/Meeko) `bash n_sdf2pdbqt_meeko.sh`.

- Docking data collection:
   1. Log\_file\_change.sh #to replace the first 1. With filename so we can directly extract the best binding score without losing file name
   1. Merging\_logs.sh
   1. logs\_extract\_merged.py
   1. Merged\_log.txt
   1. Cleaning step: `awk ‘/^p\_lig/’ merged\_log.txt > output.txt`
   1. View output.txt in excel

### 2. Feature selection

- Docking data: convert to binary using script: [BioAssay_Activity.ipynb](https://colab.research.google.com/drive/1lHBy0eFzV4cYg5f3pb8xqcsQuLhCiIyM#scrollTo=qWW7desIV_d9)
- Experimental: convert to binary

### 3. LLM model and predictions 
- Multi-label: [Multi-label_classification_with_ChemBERTa.ipynb](https://colab.research.google.com/drive/1720FLC2LUZ_Y_Yysk5MNVU_oKv5kNdCd) 
- Binary: [Classification_with_ChemBERTa.ipynb](https://colab.research.google.com/drive/1NIQIhbKqvZGcaEqI0mABlC4jflefuJFT)
