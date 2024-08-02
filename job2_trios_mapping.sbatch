#!/bin/bash 
##
## Hamidah Ghani <HamidahGhani20@rcsi.ie> - Dec2022
## Whole Exome/Genome Trio Analysis Pipeline 
#### 
#SBATCH --job-name=job2
#SBATCH --output=%j.mapping_array_%A_%a.out 
#SBATCH --error=%j.mapping_array_%A_%a.err  
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
module load BWA/0.7.17-GCC-10.2.0
module load SAMtools/1.12-GCC-10.2.0

### 1.2 Burrows-Wheeler aligner 

### sort bam file 
 
names=$(cat $WORK_DIR/s6415.txt)
echo "${names[${SLURM_ARRAY_TASK_ID}]}"

bwa mem -t 4 -M -I 200,100 -B 4 -A 1.0 -w 100 -k 19 -R '@RG\tID:"1"\tSM:"$(tail -n+$SLURM_ARRAY_TASK_ID $WORK_DIR/s6415.txt| head -n1)"\tLB:Exome\tPL:Illumina\tPU:Unknown' ${REF_GENOME} $FASTQ/$(tail -n+$SLURM_ARRAY_TASK_ID $WORK_DIR/s6415.txt| head -n1).1.fastq.gz $FASTQ/$(tail -n+$SLURM_ARRAY_TASK_ID $WORK_DIR/s6415.txt| head -n1).2.fastq.gz | samtools sort -@4 -T ${TMPDIR} -o $BAM/"$(tail -n+$SLURM_ARRAY_TASK_ID $WORK_DIR/s6415.txt| head -n1)"_sorted.bam -
samtools index $BAM/$(tail -n+$SLURM_ARRAY_TASK_ID $WORK_DIR/s6415.txt| head -n1)_sorted.bam $BAM/$(tail -n+$SLURM_ARRAY_TASK_ID $WORK_DIR/s6415.txt| head -n1)_sorted.index

#temporary space in $TMPDIR which as it shows is actually/local/scratch/<job id> is cleared automatically when the job ends

exit 0