#!/bin/bash -l

#SBATCH --job-name=zqr_parallel_download
#SBATCH --output=my_parallel_download_%A_%a.out
#SBATCH --time=48:00:00
#SBATCH --account=zhao
#SBATCH --partition=standard
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=24G
#SBATCH --array=1-152
#SBATCH --mail-type=BEGIN,END,FAIL

echo "$SLURM_JOB_ID starting execution at $(date) on $(hostname)"

source /optnfs/common/miniconda3/etc/profile.d/conda.sh
conda activate ega

file_to_download=$(sed -n "${SLURM_ARRAY_TASK_ID}p" /dartfs/rc/lab/S/Szhao/qiruiz/dataset/file_list.txt)
local_directory="/dartfs/rc/lab/S/Szhao/qiruiz/dataset/EGA/"

echo "get $file_to_download $local_directory/$(basename $file_to_download)" | sftp EGA-outbox

echo "Finished downloading $file_to_download at: $(date)"
