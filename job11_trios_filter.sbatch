#!/bin/bash 
#### 
#### Hamidah Ghani <HamidahGhani20@rcsi.ie> - Dec2022
#### RCSI Exome Trio Analysis Pipeline 
#### 
#SBATCH --job-name=job11
#SBATCH --output=%j.trio_variantfilter.out 
#SBATCH --error=%j.trio_variantfilter.err 
#SBATCH --partition=ProdQ 
#SBATCH --time=1-00:00:00
#SBATCH --ntasks=1
#SBATCH --mem=2000
#SBATCH --mail-type=END,FAIL 
#SBATCH --mail-user=HamidahGhani20@rcsi.com 

WORK_DIR=/home/data/lighthouse    
REF_GENOME=$WORK_DIR/suppfiles
FINALVCF=/home/data/lighthouse/S6415/07_finalvcf_hg38version

# Variant filter and annotation


#+
# Change loaded modules
#-
module purge  
module load GATK/4.2.0.0-GCCcore-10.2.0-Java-1.8.0_202

for i in trio_LH0157 #create a file list if you have jobarray job
do
   
   gatk VariantFiltration \
   -R $REF_GENOME/hg38_v0_Homo_sapiens_assembly38.fasta \
   -V $FINALVCF/${i}_unfiltered_snp.vcf.gz \
   -O $FINALVCF/${i}_filtered_snp.vcf.gz \
   --cluster-window-size 10 \
   --filter-name "my_filter1" \
   --filter-expression "QD < 2.0" \
   --filter-name "my_filter2" \
   --filter-expression "FS > 60.0" \
   --filter-name "my_filter3" \
   --filter-expression "MQ < 40.0" \
   --filter-name "my_filter4" \
   --filter-expression "SOR > 3.0" \
   --filter-name "my_filter5" \
   --filter-expression "MQRankSum < -12.5" \
   --filter-name "my_filter6" \
   --filter-expression "ReadPosRankSum < -8.0" \

done

for i in trio_LH0157
do
   gatk VariantFiltration \
   -R $REF_GENOME/hg38_v0_Homo_sapiens_assembly38.fasta \
   -V $FINALVCF/${i}_unfiltered_indel.vcf.gz \
   -O $FINALVCF/${i}_filtered_indel.vcf.gz \
   --cluster-window-size 10 \
   --filter-name "my_filter1" \
   --filter-expression "QD < 2.0" \
   --filter-name "my_filter2" \
   --filter-expression "FS > 200.0" \
   --filter-name "my_filter3" \
   --filter-expression "SOR > 10.0" \

done

##The GATK does not recommend use of compound filtering expressions, e.g. the logical || "OR".
##For such expressions, if a record is null for or missing a particular annotation in the expression, 
##the tool negates the entire compound expression and so automatically passes the variant record even if it fails on one of the expressions.

exit 0