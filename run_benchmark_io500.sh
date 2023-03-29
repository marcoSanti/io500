#!/bin/bash

#nodi: 1 2 4 8 16 32 64. 
#core: 1 2 4 8 16 32. al primo giro faccio 2 8 32. dopo faccio girare tutto il resto.

#MAX_NODES=64
#MAX_TASKS=32
MAX_NODES=1
MAX_TASKS=1

for  (( NODE=1;NODE<=$MAX_NODES; NODE=$NODE*2 ))
do    
    for (( TASK=1;TASK<=$MAX_TASKS; TASK=$TASK*4 ))
    do

        #GENERATE temp io500.sh benchmark
        echo "#SBATCH -o ./log.log" | cat - io500.sh > temp && mv temp temprun.sh
        echo "#SBATCH -e ./err.log" | cat - temprun.sh > temp && mv temp temprun.sh
        echo "#SBATCH --ntasks-per-node=$TASK" | cat - temprun.sh > temp && mv temp temprun.sh
        echo "#SBATCH -N $NODE" | cat - temprun.sh > temp && mv temp temprun.sh
        echo "#SBATCH -p broadwell" | cat - temprun.sh >temp && mv temp temprun.sh
        echo "#!/bin/bash" | cat - temprun.sh > temp && mv temp temprun.sh

        #submit job and get job id
        JOBTASK=$( $(sbatch temprun.sh benchmarkConfigSantimaria.ini) | tr -dc '0-9' )

       # echo $JOBTASK
    
    done
done




   