##submit_jobs.sh: need to change the absolute pathway of run.job 
##corresponding to the working directory, 
##and it will submit 1199-1100=100 jobs on Sherlock, 
##so be cautious to submit it to the brunger node.



mainfolder=$PWD
for i in `seq 1100 1199`;
do
cd $mainfolder
mkdir $i
cd $i
sbatch ../../run.job
done
