#! /bin/bash
#+
# Function to replace use of sbatch command, which outputs the Job ID
# of the job if successfully launched. On success the return status is zero;
# on failure it is non-zero which will cause the calling script to handle an error.
#
# Use this function in a Bash script to launch jobs with dependencies.
#-
function sbatch_rcsi () {
local sbr="$(/usr/bin/sbatch "$@")"
if [[ "$sbr" =~ Submitted\ batch\ job\ ([0-9]+) ]]; then
 echo "${BASH_REMATCH[1]}"
 return 0
else
 echo "sbatch failed"
 return 1
fi
}
# first job - no dependencies
jid1=$(sbatch_rcsi --mem=2g --ntasks=2 job1.sbatch) #example 
# multiple jobs can depend on a single job
jid2=$(sbatch_rcsi --dependency=afterok:$jid1 --mem=30g --ntasks=2 job2.sbatch) #example
jid3=$(sbatch_rcsi --dependency=afterok:$jid2 --mem=4g --ntasks=2 job3.sbatch)  #example
jid4=$(sbatch_rcsi --dependency=afterok:$jid3 --mem=2g --ntasks=2 job4.sbatch)  #example
jid5=$(sbatch_rcsi --dependency=afterok:$jid4 --mem=10g --ntasks=2 job5.sbatch) #example
jid6=$(sbatch_rcsi --dependency=afterok:$jid5 --mem=2g --ntasks=2 job6.sbatch) #example
# a job array can depend on a job
#jid5=$(sbatch_rcsi --array=0-3 --dependency=afterany:$jid4 --mem=2g --ntasks=2 job5.sbatch) #example

#the lists goes on depending on your jobs!

exit 0
 
