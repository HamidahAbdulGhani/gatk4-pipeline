#!/bin/bash 
#### 
#### Hamidah Ghani <HamidahGhani20@rcsi.ie> - Dec2022
#### RCSI Exome Trio Analysis Pipeline 
#### 
#SBATCH --job-name=job8
#SBATCH --output=%j.jointgen.out    
#SBATCH --error=%j.jointgen.err
#SBATCH --partition=ProdQ
#SBATCH --time=8-00:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=14000
#SBATCH --mail-type=END,FAIL 
#SBATCH --mail-user=HamidahGhani20@rcsi.com 

WORK_DIR=/home/data/lighthouse  
REF_GENOME=$WORK_DIR/suppfiles
FINALVCF=/home/data/lighthouse/S6415/07_finalvcf_hg38version
my_database=/home/data/lighthouse/dbimportlghouse200922_s6415


### Perform Joint Genotyping on GenomicsDB workspace
#+
# Change loaded modules
#-
module purge  
module load GATK/4.2.0.0-GCCcore-10.2.0-Java-1.8.0_202

#backup the db first using cp -r db db_backup

for j in {1..22} X Y M; do

gatk GenotypeGVCFs -R $REF_GENOME/hg38_v0_Homo_sapiens_assembly38.fasta \
                  -V gendb://${my_database}_chr${j} \
                  -O $FINALVCF/final_cohort_trio_s6415_chr${j}.vcf.gz \
		  --tmp-dir ${TMPDIR} \
		  -L chr${j} \
		  --only-output-calls-starting-in-intervals true \
		  -new-qual \
                  --max-alternate-alleles 3 \
		  --genomicsdb-shared-posixfs-optimizations true \
                  --create-output-variant-index true
done

echo "# Congratulations, its a final joint genotyped VCF!"

exit 0
