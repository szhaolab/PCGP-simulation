#!/bin/bash -l

#SBATCH --job-name=zqr_parallel_download
#SBATCH --output=my_parallel_download_%A_%a.out
#SBATCH --time=96:00:00
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
cd /dartfs/rc/lab/S/Szhao/qiruiz/dataset/EGA/

full_file_path=$(sed -n "${SLURM_ARRAY_TASK_ID}p" /dartfs/rc/lab/S/Szhao/qiruiz/dataset/file_list.txt)
file_name=$(basename "$full_file_path")

echo "Decrypting $file_name"
crypt4gh decrypt --sk /dartfs-hpc/rc/home/p/f0070pp/gears/id_ed25519 < $file_name > "${file_name%.c4gh}"

echo "Finished decrypting ${file_name%.c4gh}.bam at: $(date)"

