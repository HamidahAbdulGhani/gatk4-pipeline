#!/bin/bash 
##
## Hamidah Ghani <HamidahGhani20@rcsi.ie> - Dec2022
## Whole Exome/Genome Trio Analysis Pipeline 
#### 
#SBATCH --job-name=job4
#SBATCH --output=%j.baserecab_array_%A_%a.out 
#SBATCH --error=%j.baserecab_array_%A_%a.err  
#SBATCH --partition=ProdQ 
#SBATCH --time=10-00:00:00 
#SBATCH --ntasks=2
#SBATCH --mem=10000
#SBATCH --mail-type=END,FAIL 
#SBATCH --mail-user=HamidahGhani20@rcsi.com
#SBATCH --array=0-5%4

WORK_DIR=/home/data/lighthouse/S6415
BAM=$WORK_DIR/03_bam_hg38version
REF_GENOME=/home/data/lighthouse/suppfiles/hg38_v0_Homo_sapiens_assembly38.fasta
axiom_exome=/home/data/lighthouse/suppfiles/resources_broad_hg38_v0_Axiom_Exome_Plus.genotypes.all_populations.poly.hg38.vcf
dbsnp=/home/data/lighthouse/suppfiles/hg38_v0_Homo_sapiens_assembly38.dbsnp138.vcf
indels=/home/data/lighthouse/suppfiles/hg38_v0_Homo_sapiens_assembly38.known_indels.vcf
RECAL=$WORK_DIR/03_bam_hg38version/03.1_base_recab

module load GATK/4.2.0.0-GCCcore-10.2.0-Java-1.8.0_202

#temporary space in $TMPDIR which as it shows is actually/local/scratch/<job id> is cleared automatically when the job ends
#you can download hg38 dbsnp/axiom/other vcf using GATK Resource Bundle online
#https://gatk.broadinstitute.org/hc/en-us/articles/360035890811-Resource-bundle

names=$(cat $WORK_DIR/s6415.txt)
echo "${names[${SLURM_ARRAY_TASK_ID}]}"


 gatk BaseRecalibrator \
   -I BAM/$(tail -n+$SLURM_ARRAY_TASK_ID $WORK_DIR/s6415.txt| head -n1).markdup.bam \
   -R $REF_GENOME \
   --known-sites ${axiom_exome} \
   --known-sites ${dbsnp} \
   --known-sites ${indels} \
   -O $RECAL/$(tail -n+$SLURM_ARRAY_TASK_ID $WORK_DIR/s6415.txt| head -n1)_recal_data.table \
   --tmp-dir ${TMPDIR}

 gatk ApplyBQSR \
   -R $REF_GENOME \
   -I BAM/$(tail -n+$SLURM_ARRAY_TASK_ID $WORK_DIR/s6415.txt| head -n1).markdup.bam \
   --bqsr-recal-file $RECAL/$(tail -n+$SLURM_ARRAY_TASK_ID $WORK_DIR/s6415.txt| head -n1)_recal_data.table \
   -O $RECAL/$(tail -n+$SLURM_ARRAY_TASK_ID $WORK_DIR/s6415.txt| head -n1).markdup.recal.bam \
   --create-output-bam-index true \
   --tmp-dir ${TMPDIR}

  echo "# recalibration of basecalling scores done."


exit 0