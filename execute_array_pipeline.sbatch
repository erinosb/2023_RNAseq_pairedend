#!/usr/bin/env bash
# slurm_array_launcher.sbatch
# Run each line of a metadata file as a separate job
# Invoke this script with 
# sbatch --array=1-3 slurm_array_launcher.sbatch
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --time=0:20:00
#SBATCH --qos=normal
#SBATCH --partition=amilan
#SBATCH --job-name=array-job
#SBATCH --output=%x.%A_%a.log # will produce: array-job.123456_1.log

#### 1. Specify metadata file
METADATAFILENAME=metadata.txt
### Assume a meta data file is of this format:
# slurm_array_task_id  sample_name     filename_l     filename_r
# 1             sample_name_1   filename_l_1   filename_r_1
# 2             sample_name_2   filename_l_2   filename_r_2
# 3             ...           ...           ...

#### 2. GET A SINGLE LINE FROM THE METADATA FILE:
#################################################################################
metadataline=$(grep -w $SLURM_ARRAY_TASK_ID $METADATAFILENAME)
#### Explanation:
#### SLURM_ARRAY_JOB_ID equals one of the numbers requested on the commandline with "sbatch --array"
#### "grep -w $SLURM_ARRAY_TASK_ID" greps that number provided it is surrounded by whitespace
#### METADATAFILENAME is set early in the script
#### "metadataline=$( ... )" captures the whole line
#################################################################################

#### 3. PASS WHOLE LINE AS ARGUMENTS TO THE SCRIPT                                  
#################################################################################
#### if your script takes:                                           
#### execute.sh sample_number  sample_name     filename_l     filename_r
#### then you can pass all arguments unchanged:
bash execute.sh $metadataline

### Alternative 3: pass only the sample_name     filename_l     filename_r
fields=($metadataline) # parse whitespace-delimited fields into array
bash execute.sh ${fields[1]} ${fields[2]} ${fields[3]}
