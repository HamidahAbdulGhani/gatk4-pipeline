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

--------------------------------------------------------------------------------------------------------------------------------

##To run JointGenotyoing more quicker, please split them per chr and run ii in parallel and merge the VCF later on


#example script for chr1 (please edit for chr2....Y

#SBATCH --job-name=jointgen_LH_BGP42_chr1
#SBATCH --output=%j.jointgen_LH_BPG42_chr1.out    
#SBATCH --error=%j.jointgen_LH_BPG42_chr1.err
#SBATCH --partition=ProdQ
#SBATCH --time=8-00:00:00
#SBATCH --ntasks=2
#SBATCH --mem=9000
#SBATCH --mail-type=END,FAIL 
#SBATCH --mail-user=HamidahGhani20@rcsi.com 

WORK_DIR=/home/data/lighthouse  
REF_GENOME=$WORK_DIR/suppfiles
FINALVCF=$WORK_DIR/cohort1_lighthouse/10_finalvcf  
my_database=$WORK_DIR/dbimportlghouse300921


### Perform Joint Genotyping on GenomicsDB workspace
#+
# Change loaded modules
#-
module purge  
module load GATK/4.2.0.0-GCCcore-10.2.0-Java-1.8.0_202

###backup the db first using cp -r db db_backup

output=$FINALVCF/final_cohort_trio_LH_intervals_353s_chr1.vcf.gz
gatk GenotypeGVCFs -R $REF_GENOME/hg38_v0_Homo_sapiens_assembly38.fasta \
                  -V gendb://${my_database} \
                  -O ${output} \
		  --tmp-dir ${TMPDIR} \
		  -L chr1 \
		  --only-output-calls-starting-in-intervals true \
		   -new-qual \
                  --max-alternate-alleles 3

echo "# Congratulations, its a final joint genotyped VCF for Chr1!"

exit 0



