#!/bin/bash 
##
## Hamidah Ghani <HamidahGhani20@rcsi.ie> - Dec2022
## Whole Exome/Genome Trio Analysis Pipeline 
#### 
#SBATCH --job-name=job3
#SBATCH --output=%j.markdup_array_%A_%a.out 
#SBATCH --error=%j.markdup_array_%A_%a.err  
#SBATCH --partition=ProdQ 
#SBATCH --time=10-00:00:00 
#SBATCH --ntasks=5
#SBATCH --mem=35000
#SBATCH --mail-type=END,FAIL 
#SBATCH --mail-user=HamidahGhani20@rcsi.com
#SBATCH --array=0-5%4

WORK_DIR=/home/data/lighthouse/S6415
FASTQ=$WORK_DIR/01_fastq
BAM=/home/data/lighthouse/S6415/03_bam_hg38version
REF_GENOME=$WORK_DIR/suppfiles/hg38_v0_Homo_sapiens_assembly38.fasta

module purge  
module load GATK/4.2.0.0-GCCcore-10.2.0-Java-1.8.0_202

names=$(cat $WORK_DIR/s6415.txt)
echo "${names[${SLURM_ARRAY_TASK_ID}]}"

   gatk MarkDuplicates -I $BAM/$(tail -n+$SLURM_ARRAY_TASK_ID $WORK_DIR/s6415.txt| head -n1)_sorted.bam --TMP_DIR ${TMPDIR} \
   -O $BAM/$(tail -n+$SLURM_ARRAY_TASK_ID $WORK_DIR/s6415.txt| head -n1).markdup.bam \
   --METRICS_FILE $BAM/$(tail -n+$SLURM_ARRAY_TASK_ID $WORK_DIR/s6415.txt| head -n1).sorted.metrics.txt --REMOVE_DUPLICATES true --CREATE_INDEX true

   echo "# mark duplicates for ${names[${SLURM_ARRAY_TASK_ID}]} done"

#temporary space in $TMPDIR which as it shows is actually/local/scratch/<job id> is cleared automatically when the job ends

exit 0