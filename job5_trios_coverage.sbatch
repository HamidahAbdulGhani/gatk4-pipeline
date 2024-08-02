#!/bin/bash 
##
## Hamidah Ghani <HamidahGhani20@rcsi.ie> - Dec2022
## Whole Exome/Genome Trio Analysis Pipeline 
#### 
#SBATCH --job-name=job5
#SBATCH --output=%j.cov_array_%A_%a.out 
#SBATCH --error=%j.cov_array_%A_%a.err  
#SBATCH --partition=ProdQ 
#SBATCH --time=10-00:00:00 
#SBATCH --ntasks=2
#SBATCH --mem=10000
#SBATCH --mail-type=END,FAIL 
#SBATCH --mail-user=HamidahGhani20@rcsi.com
#SBATCH --array=0-2

WORK_DIR=/home/data/lighthouse/S6415
BAM=$WORK_DIR/03_bam_hg38version
REF_GENOME=/home/data/lighthouse/suppfiles/hg38_v0_Homo_sapiens_assembly38.fasta
COV=$WORK_DIR/06_coverage_hg38version
RECAL=$WORK_DIR/03_bam_hg38version/03.1_base_recab

module load GATK/4.2.0.0-GCCcore-10.2.0-Java-1.8.0_202

#put .txt file into all necessary folders


names=$(cat $WORK_DIR/s6415.txt)
echo "${names[${SLURM_ARRAY_TASK_ID}]}"

gatk DepthOfCoverage \
   -R $REF_GENOME \
   -O $COV/coverage \
   -I $RECAL/$(tail -n+$SLURM_ARRAY_TASK_ID $WORK_DIR/list_udn.txt| head -n1).markdup.recal.bam \
   --summary-coverage-threshold 4 --summary-coverage-threshold 6 --summary-coverage-threshold 10 \
   -L $INTERVAL \
   --tmp-dir ${TMPDIR}

  echo "# coverage done."

exit 0