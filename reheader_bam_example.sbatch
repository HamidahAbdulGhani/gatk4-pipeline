##!/bin/bash 
##
## Hamidah Ghani <HamidahGhani20@rcsi.ie>
## 
##
#SBATCH --job-name=rename_id
#SBATCH --output reheader_%A_%a.out
#SBATCH --error reheader_%A_%a.err
#SBATCH --partition=ProdQ 
#SBATCH --time=9-00:00:00 
#SBATCH --ntasks=2
#SBATCH --mem=15000
#SBATCH --mail-type=END,FAIL 
#SBATCH --mail-user=HamidahGhani20@rcsi.com
#SBATCH --array=0-102%3 #run 3 samples in parallel


IN=/home/data/lighthouse/cohort3_egi/03_bam_hg38version  #example
OUT=/home/data/lighthouse/cohort3_egi/03_bam_hg38version/03.3_bam_hg38v_reheader #example

names=$(cat $IN/list1.txt)
echo "${names[${SLURM_ARRAY_TASK_ID}]}"

module load GATK/4.2.0.0-GCCcore-10.2.0-Java-1.8.0_202

gatk AddOrReplaceReadGroups \
       I=$IN/$(tail -n+$SLURM_ARRAY_TASK_ID $IN/list1.txt| head -n1).markdup.bam \
       O=$OUT/$(tail -n+$SLURM_ARRAY_TASK_ID $IN/list1.txt| head -n1).markdup.bam \
       RGID=4 \
       RGLB=lib1 \
       RGPL=ILLUMINA \
       RGPU=unit1 \
       RGSM=$(tail -n+$SLURM_ARRAY_TASK_ID $IN/list1.txt| head -n1) #this will rename your bam file according to your listed sample ID in list1.txt file

exit 0