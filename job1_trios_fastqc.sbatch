#!/bin/bash 
##
## Hamidah Ghani <HamidahGhani20@rcsi.ie> - Dec2022
## Whole Exome/Genome Trio Analysis Pipeline 
 
#SBATCH --job-name=job1
#SBATCH --output fastqc_%A_%a.out   
#SBATCH --error fastqc_%A_%a.err 
#SBATCH --partition=ProdQ 
#SBATCH --time=1-00:00:00
#SBATCH --ntasks=1
#SBATCH --mem=2000
#SBATCH --mail-type=END,FAIL 
#SBATCH --mail-user=HamidahGhani20@rcsi.com 
#SBATCH --array=0-5%4 #job array coresponding to your 6 samples(example only), to run 4 in parallel (be aware of the resources)

WORK_DIR=/home/data/lighthouse/S6415                    
REF_GENOME=/home/data/lighthouse/suppfiles              
FASTQ=$WORK_DIR/01_fastq                                
FASTQC=/home/data/lighthouse/S6415/02_fastqc           

#create all require folders
#keep the s6415.txt in your working dir

module load FastQC/0.11.9-Java-11


names=$(cat $WORK_DIR/s6415.txt)
echo "${names[${SLURM_ARRAY_TASK_ID}]}"

fastqc -t 5 -d ${TMPDIR} $FASTQ/$(tail -n+$SLURM_ARRAY_TASK_ID $WORK_DIR/s6415.txt| head -n1)*.fastq.gz -o $FASTQC 

#temporary space in $TMPDIR which as it shows is actually/local/scratch/<job id> is cleared automatically when the job ends


exit 0