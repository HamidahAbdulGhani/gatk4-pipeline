#!/bin/bash 
#### 
#### Hamidah Ghani <HamidahGhani20@rcsi.ie> - Dec2023
#### RCSI Exome Trio Analysis Pipeline 
#### 
#SBATCH --job-name=job12
#SBATCH --output=%j.annotation_trio_LH0157.out
#SBATCH --output=%j.annotation_trio_LH0157.err
#SBATCH --partition=ProdQ 
#SBATCH --time=1-00:00:00 
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=12000
#SBATCH --mail-type=END,FAIL 
#SBATCH --mail-user=HamidahGhani20@rcsi.com 


WORK_DIR=/home/data/lighthouse
REF_GENOME=$WORK_DIR/suppfiles
FINALVCF=/home/data/lighthouse/S6415/07_finalvcf_hg38version
ANNOVAR=/home/data/lighthouse/S6415/08_annovar
HUMAN_DB=$WORK_DIR/references_wes/humandb
DENOVO=/home/data/lighthouse/S6415/09_denovolists
PED=/home/data/lighthouse/S6415/11_pedigree_files  
VCF_REF=$WORK_DIR/suppfiles/resources_broad_hg38_v0_1000G_omni2.5.hg38.vcf.gz

#create all your ped file as per example if you run trios!
#remove denovo calling if you run singletons

#+
# Change loaded modules
#-
module purge
module load VCFtools/0.1.16-GCC-9.3.0/
#Prepare VCF files for SNP


	vcftools --gzvcf $FINALVCF/trio_LH0157_filtered_snp.vcf.gz --remove-filtered-all --recode --out $FINALVCF/trio_LH0157_filtered_snp_PASS --recode-INFO-all


#+
# Change loaded modules
#-
module purge
module load HTSlib/1.12-GCC-10.2.0 BCFtools/1.12-GCC-10.2.0 


	bgzip $FINALVCF/trio_LH0157_filtered_snp_PASS.recode.vcf
	tabix $FINALVCF/trio_LH0157_filtered_snp_PASS.recode.vcf.gz
	bcftools norm -m-both -o $FINALVCF/trio_LH0157_snp_step1.vcf $FINALVCF/trio_LH0157_filtered_snp_PASS.recode.vcf.gz
	bcftools norm -f $REF_GENOME/hg38_v0_Homo_sapiens_assembly38.fasta -o $FINALVCF/trio_LH0157_snp_step2.vcf $FINALVCF/trio_LH0157_snp_step1.vcf


#+
# Change loaded modules
#-i
module purge
module load annovar/20191024-GCCcore-8.2.0-Perl-5.28.1


##Convert to annovar format- convert variant call file generated from various software programs into ANNOVAR input format

	convert2annovar.pl --includeinfo --withzyg --format vcf4  $FINALVCF/trio_LH0157_snp_step2.vcf > $ANNOVAR/trio_LH0157_snp_PASS.avinput

##Run annovar

	table_annovar.pl $ANNOVAR/trio_LH0157_snp_PASS.avinput $HUMAN_DB -buildver hg38 -out $ANNOVAR/trio_LH0157_snp_PASS_anno --remove --protocol refGene,cytoBand,genomicSuperDups,exac03,gnomad_exome,gnomad_genome,avsnp147,dbnsfp33a,dbscsnv11,mcap,clinvar_20210501,revel --operation g,r,r,f,f,f,f,f,f,f,f,f -nastring . -csvout -polish
	rm -rf  $FINALVCF/trio_LH0157_snp_step*.vcf


#Prepare VCF files for INDEL
#+
# Change loaded modules
#-
module purge
module load VCFtools/0.1.16-GCC-9.3.0
#Prepare VCF files for indels

	vcftools --gzvcf $FINALVCF/trio_LH0157_filtered_indel.vcf.gz --remove-filtered-all --recode --out $FINALVCF/trio_LH0157_filtered_indel_PASS --recode-INFO-all

#+
# Change loaded modules
#-
module purge
module load HTSlib/1.12-GCC-10.2.0 BCFtools/1.12-GCC-10.2.0 

	
	bgzip $FINALVCF/trio_LH0157_filtered_indel_PASS.recode.vcf
	tabix $FINALVCF/trio_LH0157_filtered_indel_PASS.recode.vcf.gz
	bcftools norm -m-both -o $FINALVCF/trio_LH0157_indel_step1.vcf $FINALVCF/trio_LH0157_filtered_indel_PASS.recode.vcf.gz
	bcftools norm -f $REF_GENOME/hg38_v0_Homo_sapiens_assembly38.fasta -o $FINALVCF/trio_LH0157_indel_step2.vcf $FINALVCF/trio_LH0157_indel_step1.vcf


#+
# Change loaded modules
#-
module purge
module load annovar/20191024-GCCcore-8.2.0-Perl-5.28.1


##Convert to annovar format- convert variant call file generated from various software programs into ANNOVAR input format

	convert2annovar.pl --includeinfo --withzyg --format vcf4  $FINALVCF/trio_LH0157_indel_step2.vcf > $ANNOVAR/trio_LH0157_indel_PASS.avinput

##Run annovar


	table_annovar.pl $ANNOVAR/trio_LH0157_indel_PASS.avinput $HUMAN_DB -buildver hg38 -out $ANNOVAR/trio_LH0157_indel_PASS_anno --remove --protocol refGene,cytoBand,genomicSuperDups,exac03,gnomad_exome,gnomad_genome,avsnp147,dbnsfp33a,dbscsnv11,mcap,clinvar_20210501,revel --operation g,r,r,f,f,f,f,f,f,f,f,f -nastring . -csvout -polish
	rm -rf  $FINALVCF/trio_LH0157_indel_step*.vcf



## Refine Genotype workflow, call de novo snp##
#+
# Change loaded modules
#-
module purge
module load GATK/4.2.0.0-GCCcore-10.2.0-Java-1.8.0_202


##Step 1: Derive posterior probabilities of genotypes
	gatk CalculateGenotypePosteriors -R $REF_GENOME/hg38_v0_Homo_sapiens_assembly38.fasta --de-novo-prior 1.0E-6 -ped $PED/trio_LH0157.ped -supporting $VCF_REF -V $FINALVCF/trio_LH0157_filtered_snp_PASS.recode.vcf.gz -O $FINALVCF/trio_LH0157_recalibratedVariants_snp_postCGP.vcf

##Step 2: Filter low quality genotypes
	gatk VariantFiltration -R $REF_GENOME/hg38_v0_Homo_sapiens_assembly38.fasta -V $FINALVCF/trio_LH0157_recalibratedVariants_snp_postCGP.vcf  -G-filter "GQ < 20.0" -G-filter-name lowGQ -O $FINALVCF/trio_LH0157_recalibratedVariants_snp_postCGP_Gfiltered.vcf

##Step 3: Annotate possible de novo mutations
	gatk VariantAnnotator -R $REF_GENOME/hg38_v0_Homo_sapiens_assembly38.fasta -V $FINALVCF/trio_LH0157_recalibratedVariants_snp_postCGP_Gfiltered.vcf -A PossibleDeNovo -ped $PED/trio_LH0157.ped -O $FINALVCF/trio_LH0157_recalibratedVariants_snp_postCGP_Gfiltered_deNovos.vcf


#+
# Change loaded modules
#-
module purge
module load VCFtools/0.1.16-GCC-9.3.0


	vcftools --vcf $FINALVCF/trio_LH0157_recalibratedVariants_snp_postCGP_Gfiltered_deNovos.vcf --minGQ 20 --remove-filtered-all --recode --out $FINALVCF/trio_LH0157_recal_snp_deNovo_GQ20 --recode-INFO-all --keep-INFO-all
	grep 'DeNovo' $FINALVCF/trio_LH0157_recal_snp_deNovo_GQ20.recode.vcf > $DENOVO/trio_LH0157_denovo_snp.list




## Refine Genotype workflow, call de novo indel##
#+
# Change loaded modules
#-
module purge
module load GATK/4.2.0.0-GCCcore-10.2.0-Java-1.8.0_202

##Step 1: Derive posterior probabilities of genotypes
	gatk CalculateGenotypePosteriors -R $REF_GENOME/hg38_v0_Homo_sapiens_assembly38.fasta --de-novo-prior 1.0E-6 -ped $PED/trio_LH0157.ped -supporting $VCF_REF -V $FINALVCF/trio_LH0157_filtered_indel_PASS.recode.vcf.gz -O $FINALVCF/trio_LH0157_recalibratedVariants_indel_postCGP.vcf


##Step 2: Filter low quality genotypes
	gatk VariantFiltration -R $REF_GENOME/hg38_v0_Homo_sapiens_assembly38.fasta -V $FINALVCF/trio_LH0157_recalibratedVariants_indel_postCGP.vcf  -G-filter "GQ<20.0" -G-filter-name lowGQ -O $FINALVCF/trio_LH0157_recalibratedVariants_indel_postCGP_Gfiltered.vcf

##Step 3: Annotate possible de novo mutations
	gatk VariantAnnotator -R $REF_GENOME/hg38_v0_Homo_sapiens_assembly38.fasta -V $FINALVCF/trio_LH0157_recalibratedVariants_indel_postCGP_Gfiltered.vcf -A PossibleDeNovo -ped $PED/trio_LH0157.ped -O $FINALVCF/trio_LH0157_recalibratedVariants_indel_postCGP_Gfiltered_deNovos.vcf

#+
# Change loaded modules
#-
module purge
module load VCFtools/0.1.16-GCC-9.3.0

	vcftools --vcf $FINALVCF/trio_LH0157_recalibratedVariants_indel_postCGP_Gfiltered_deNovos.vcf --minGQ 20 --remove-filtered-all --recode --out $FINALVCF/trio_LH0157_recal_indel_deNovo_GQ20 --recode-INFO-all --keep-INFO-all
	grep 'DeNovo' $FINALVCF/trio_LH0157_recal_indel_deNovo_GQ20.recode.vcf > $DENOVO/trio_LH0157_denovo_indel.list


exit 0