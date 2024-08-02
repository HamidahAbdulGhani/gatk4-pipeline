#!/bin/bash 
#### 
#### Hamidah Ghani <HamidahGhani20@rcsi.ie> - Dec2022
#### RCSI Exome Trio Analysis Pipeline 
#### 
#SBATCH --job-name=job6
#SBATCH --output gvcf_cegat_%A_%a.out   
#SBATCH --error gvcf_cegat_%A_%a.err
#SBATCH --partition=ProdQ 
#SBATCH --time=8-00:00:00 
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=13000
#SBATCH --mail-type=END,FAIL 
#SBATCH --mail-user=HamidahGhani20@rcsi.com 
#SBATCH --array=0-6%2

WORK_DIR=/home/data/lighthouse/S6415
OUTVCF=/home/data/lighthouse/S6415/05_vcf_hg38version
BAM=/home/data/human_genetics/LH_reprocessing_updatedbed/LH_probands/recal_BAM
REF_GENOME=/home/data/lighthouse/suppfiles
RECAL=$WORK_DIR/03_bam_hg38version/03.1_base_recab

module purge  
module load GATK/4.2.0.0-GCCcore-10.2.0-Java-1.8.0_202

### Create genome VCF files per sample

names=$(cat $WORK_DIR/s6415.txt)
echo "${names[${SLURM_ARRAY_TASK_ID}]}"

input=$RECAL/$(tail -n+$SLURM_ARRAY_TASK_ID $WORK_DIR/s6415.txt| head -n1).markdup.recal.bam

gatk HaplotypeCaller -R $REF_GENOME/hg38_v0_Homo_sapiens_assembly38.fasta \
    		-I ${input} \
		--emit-ref-confidence GVCF \
		--tmp-dir ${TMPDIR} \
		--intervals $REF_GENOME/hg38_v0_HybSelOligos_whole_exome_illumina_coding_v1_whole_exome_illumina_coding_v1.Homo_sapiens_assembly38.targets.interval_list \
    		--output $OUTVCF/$(tail -n+$SLURM_ARRAY_TASK_ID $WORK_DIR/s6415.txt| head -n1).g.vcf.gz \
                --create-output-variant-index true

echo "# Congratulations, its a unfiltered gVCF!"

exit 0