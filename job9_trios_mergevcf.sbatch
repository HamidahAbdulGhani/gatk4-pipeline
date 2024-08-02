#!/bin/bash 
#### 
#### Hamidah Ghani <HamidahGhani20@rcsi.ie> -Dec2022 
#### RCSI Exome Trio Analysis Pipeline 
#### 
#SBATCH --job-name=job9
#SBATCH --output=%j.merge_vcf.out 
#SBATCH --error=%j.merge_vcf.err 
#SBATCH --partition=ProdQ 
#SBATCH --time=1-00:00:00  
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2000
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=HamidahGhani20@rcsi.com


WORK_DIR=/home/data/lighthouse
FINALVCF=/home/data/lighthouse/S6415/07_finalvcf_hg38version

module load GATK/4.2.0.0-GCCcore-10.2.0-Java-1.8.0_202


### mergevcfs

   gatk MergeVcfs -I $FINALVCF/input_variant_files_s6415.list \
	-O $FINALVCF/final_cohort_trio_s6415_ALLchr.vcf.gz \
        --tmp_dir ${TMPDIR} \
        --CREATE_INDEX true

exit 0