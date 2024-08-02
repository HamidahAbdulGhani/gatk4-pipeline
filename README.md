# gatk4-pipeline

## Overview
SNP and Indels variant calling pipeline using GATK4 with Slurm (RCSI Local Compute)

## Table of Contents
1. [Installation](#installation)
2. [Usage](#usage)
3. [Documentation](#documentation)
4. [Testing](#testing)
5. [Contributing](#contributing)
6. [License](#license)
7. [Citations](#citations)
8. [Contact Information](#contact-information)
9. [Acknowledgments](#acknowledgments)

## Installation
### Prerequisites
All software and tools in this script are available as loadable modules in RCSI Local Compute. Please be aware that RCSI IT may update the software version over time, if that happens, please check and change the version used accordingly.

### Installation Steps
It would be best if you were on RCSI Local Compute to use these scripts.

## Usage
### Quick Start
Run the job according to the assigned script job numbers 01,02,03..12,
The scripts were designed for large-scale WES/WGS trios analysis, to be run in parallel jobs whenever possible.
As a first-time user, I would recommend you run a small sample size to test/make some edits according to your analysis/sample id name etc
After job no 12, please refer to Omri's custom R script for post-filter the results accordingly.
If you need to Snakemake file version of this pipeline, please ask Sahin.

### Detailed Instructions
In-depth usage examples.

### Sample Data
Example are included along the scripts

If you want to rename your BAM files with unique read tags, please refer to my example script: reheader_bam_example

## Documentation
Please refer to HPC Workbook 1-3 from RCSI IT website if your not familiar with Slurm environment.
Please refer to GATK4 Best Practice to understand what this pipeline did (https://gatk.broadinstitute.org/hc/en-us/categories/360002369672)

## Testing
All included in the scripts

## Contributing
Guidelines on how to contribute.

## License
License information.

## Citations
Instructions on how to cite the project.

## Contact Information
If you have a problem with this pipeline, feel free to contact me (hamidahghani20@rcsi.ie)

## Acknowledgments
Funding sources and acknowledgments.
Please cite the original description of the GATK framework.

McKenna A, Hanna M, Banks E, Sivachenko A, Cibulskis K, Kernytsky A, Garimella K, Altshuler D, Gabriel S, Daly M, DePristo MA. (2010). The Genome Analysis Toolkit: a MapReduce framework for analyzing next-generation DNA sequencing data. Genome Res, 20:1297-303. DOI: 10.1101/gr.107524.110.
