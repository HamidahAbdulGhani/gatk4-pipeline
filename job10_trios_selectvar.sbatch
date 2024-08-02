#!/bin/bash 
#### 
#### Hamidah Ghani <HamidahGhani20@rcsi.ie> - Dec2022
#### RCSI Exome Trio Analysis Pipeline 
#### 
#SBATCH --job-name=job10
#SBATCH --output=%j.selectvar_s6415.out 
#SBATCH --error=%j.selectvar_s6415.err 
#SBATCH --partition=ProdQ
#SBATCH --time=1-00:00:00 
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=1000
#SBATCH --mail-type=END,FAIL 
#SBATCH --mail-user=HamidahGhani20@rcsi.com 
 

WORK_DIR=/home/data/lighthouse
REF_GENOME=$WORK_DIR/suppfiles
FINALVCF=/home/data/lighthouse/S6415/07_finalvcf_hg38version


######## select variants like SNPs and Indels######

module load GATK/4.2.0.0-GCCcore-10.2.0-Java-1.8.0_202

input=$FINALVCF/final_cohort_trio_s6415_ALLchr.vcf.gz
output=$FINALVCF/trio_LH0157_unfiltered.vcf.gz

gatk SelectVariants \
     -R $REF_GENOME/hg38_v0_Homo_sapiens_assembly38.fasta \
     -V ${input} \
     -sn S6415Nr1_LH0157A \
     -sn S6415Nr2_LH0157B \ 
     -sn S6415Nr3_LH0157C \
     --select-type-to-include SNP \
     --select-type-to-include INDEL \
     -O ${output}


echo "# Congratulations, its a unfiltered VCF!"

exit 0