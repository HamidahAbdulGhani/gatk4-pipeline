#!/bin/bash 
#### 
#### Hamidah Ghani <HamidahGhani20@rcsi.ie> - Dec2022
#### RCSI Exome Trio Analysis Pipeline 
#### 
#SBATCH --job-name=job7
#SBATCH --partition=ProdQ 
#SBATCH --time=12-00:00:00 
#SBATCH --output=%j.gendbimport_s6415.out 
#SBATCH --error=%j.gendbimport_s6415.err 
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=10000
#SBATCH --mail-type=END,FAIL 
#SBATCH --mail-user=HamidahGhani20@rcsi.com 

WORK_DIR=/home/data/lighthouse
my_database=/home/data/lighthouse/dbimportlghouse200922_s6415
REF_GENOME=$WORK_DIR/suppfiles


module purge  
module load GATK/4.2.0.0-GCCcore-10.2.0-Java-1.8.0_202

### Using GenomicsDBImport in practice to store all gVCF

#backup db

for j in {1..22} X Y M; do
gatk GenomicsDBImport \
		  --genomicsdb-workspace-path ${my_database}_chr${j} \
                  --batch-size 6 \
                  --sample-name-map s6415.sample_map \
      		  --tmp-dir ${TMPDIR} \
                  -L chr${j} \
                  --max-num-intervals-to-import-in-parallel 20 \
                  --merge-input-intervals true \
                  --create-output-variant-index true
done

##  --genomicsdb-update-workspace-path  #Use this argument when adding new samples to an existing GenomicsDB workspace or when using the output-interval-list-to-file option.
##    Either this or genomicsdb-workspace-path must be specified. Must point to an existing workspace.
##it is recommended that users backup existing genomicsdb workspaces before adding new samples using --genomicsdb-update-workspace-path. 
##If the tool fails during incremental import for any reason, the workspace may be in an inconsistent/corrupted state

exit 0