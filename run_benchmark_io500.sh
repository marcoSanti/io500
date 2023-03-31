#!/bin/bash


SLEEPTIME_SECONDS=10
MAX_NODES=64
MAX_TASKS=32
CLUSTER=broadwell


for  (( NODE=1;NODE<=$MAX_NODES; NODE=$NODE*2 ))
do    
	for (( TASK=2;TASK<=$MAX_TASKS; TASK=$TASK*2 ))
	do
	echo "Running test with $NODE nodes,  and $TASK tasks per node, on cluster $CLUSTER"
		#GENERATE temp io500.sh benchmark
		echo "#SBATCH -o ./log.log" | cat - io500.sh > temp && mv temp temprun.sh
		echo "#SBATCH -e ./err.log" | cat - temprun.sh > temp && mv temp temprun.sh
		echo "#SBATCH --ntasks-per-node=$TASK" | cat - temprun.sh > temp && mv temp temprun.sh
		echo "#SBATCH -N $NODE" | cat - temprun.sh > temp && mv temp temprun.sh
		echo "#SBATCH -p $CLUSTER" | cat - temprun.sh >temp && mv temp temprun.sh
		echo "#!/bin/bash" | cat - temprun.sh > temp && mv temp temprun.sh

		#submit job and get job id
		JOBTASK=$(sbatch temprun.sh benchmarkConfigSantimaria.ini | tr -dc '0-9' )
		echo "Submitted job with slurm task: $JOBTASK"
		#sleep until next job
		while [ $(squeue -j $JOBTASK | wc -l) -ne "1" ]
		do
			sleep $SLEEPTIME_SECONDS
		done

		#rename targz file
		LSTMODFILE=$(ls -1t ./results | grep .tgz | head -1)
		echo "Moving $LSTMODFILE to final place"
		mv ./results/$LSTMODFILE ./results/test-nodes_$NODE-tasks_$TASK.tgz

		echo
		echo
	
	done
done

rm -f temprun.sh

