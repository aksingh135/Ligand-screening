# Developing a workflow for GPR119 agonist screening using machine learning techniques 

## Introduction:
This project focuses on reducing the experimental search space by computationally detecting ligands for a specific GPCR using machine learning techniques. Transfer learning is leveraged here by employing a pre-trained model: **[ChemBERTa](https://arxiv.org/abs/2010.09885)** to build classifiers for distinguishing between binder and non-binders. Docking scores from AutoDock Vina and experimental data obtained from assays and GlassDB were used as features for this model. This repository contains the publishable scripts and the subsequent data obtained for this pipeline. For a comprehensive understanding of the results and the potential uses of the models derived, please refer to the concluding remarks at the end of this document.

## Project outline:
<p align="center">
<img width="550" height="400" alt="image" src="https://github.com/aksingh135/Ligand-screening/assets/106146795/cc0f794b-918b-4c26-9958-9ae28306c66e">
</p>

## Repository Structure and Script Functionalities
### 1. Training Data Collection
- Docking Positive and Negative Datasets:
    - Positive dataset: Sourced from [GlassDB](https://zhanggroup.org/GLASS/) by querying *Homo sapiens* GPR119-ligand interaction data.
        - 1429 GPR119-ligand interaction data was obtained
        - Comes with combined sdf structure file of all of the ligands (Q8TDV5.tsv)
        - In order to carry out docking, individual sdf files were first obtained by splitting the file using obabel: `obabel Q8TDV5.sdf -O p_ligand.sdf -m`
        - Finally, the sdf files were converted to pdbqt format for docking: `obabel \*.sdf -opdbqt -m`
        - The docking scripts were prepared and executed in the order:
            1. protein.pdbqt 
            2. conf\_all.txt (configuration file for docking)
            3. run\_vina\.sh (bash script for multiple ligand docking)
            4. docking\_cmds.sbatch (job script to submit to slurm)
    - Negative dataset: Sourced from experimental data.
      > **_NOTE:_**  The note content.
        - The PubChem IDs (CIDs) were derived using the given CAS numbers via the script: [Adding_PubChemID.ipynb](https://colab.research.google.com/drive/16O843ywIjOWKuvpDEvfsmMGSJ8GrKdsY#scrollTo=pf98cWOiVa22)
        - Using these CIDs availiable 3D sdf structures of the negative dataset were obtained by executing `bash sdf.sh`.
        - File conversion from sdf to pdbqt was done using [Meeko](https://github.com/forlilab/Meeko) `bash n_sdf2pdbqt_meeko.sh`.


- Docking data collection:
    - The scripts used for extracting docking score were run in the order:
       1. Log\_file\_change.sh (Replaces the first numbering associated with the top binding score '1.' in the log file with filename so we can directly extract the best docking score without losing the ligand name.)
       2. Merging\_logs.sh (Merges all of the docking logs obtained from the multiple-ligand docking and stores it in: *all\_logs_n.txt*.)
       3. logs\_extract\_merged.py (Extracts the top binding score in the merged doc *all\_logs_n.txt*.)
       4. Merged\_log.txt
       5. Cleaning step: `awk ‘/^ligand/’ merged_log.txt > output.txt` 
       6. View output.txt in excel

### 2. Feature selection
Docking scores and previous experimental data were used as features for the classification models.
- Docking data was converted to a binary format using a threshold determined via EC50 values comparable to the particular GPCR agonist: [Pos_data_BioAssay_Activity.ipynb](https://colab.research.google.com/drive/1S3Ml0gHAuu9491m7nRKi7jzk3moOOGV0?usp=sharing) anything at the threshold and above was labeled with '1' and anything below was '0'.
- Experimental data was converted to binary such that '1' was assigned to binding and '0' indicated non-binding.

### 3. LLM model and predictions 
Originally, the multi-label ChemBERTa classification aimed to capture patterns in non-agreeing instances with a specific focus on recognizing "confusing agonists." Since a lack of equal label representation in the data was realized, a simpler binary classifier leveraging only the agreeing experimental and docking data was implemented. This model aims for a more straightforward distinction between positive and negative instances, acknowledging the limitations posed by the insufficient data for capturing the intricacies of confusing agonists. Model predictions were done on the Anti-diabetic compound library as GPR119 is often a therapeutic target for diabetes.

### 4. Outcomes, conclusions and future applications
Upon addressing the identified issues, not only was a significant increase in model metrics observed, but the binary model also made more meaningful predictions *(assigning the '11' label to one-third of the Anti-diabetic compound library)*. Hence, for limited experimental data, the established pipeline with binary classification using ChemBERTa has the potential to screen small molecules for potential ligands. 
GPCRs with larger datasets can leverage the ChemBERTa multi-label classifier for capturing "confusing agonists," thereby offering a more nuanced and comprehensive analysis with larger datasets. By teaching the model to identify non-agreeing experimental and docking chemicals, the search for potential ligands becomes more refined, potentially increasing the success rate in experimental replication of computationally predicted binders.
