#!/bin/bash -l

#SBATCH --job-name=zqr_bam
#SBATCH --output=my_processbam_%A_%a.out
#SBATCH --time=96:00:00
#SBATCH --account=zhao
#SBATCH --partition=standard
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=24G
#SBATCH --array=1-152
#SBATCH --mail-type=BEGIN,END,FAIL

echo $SLURM_JOB_ID starting execution `date` on `hostname`

source /optnfs/common/miniconda3/etc/profile.d/conda.sh
conda activate ega

cd /dartfs/rc/lab/S/Szhao/qiruiz/dataset/EGA

SAMPLE_FILE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" /dartfs/rc/lab/S/Szhao/qiruiz/dataset/file_list.txt)
SAMPLE=$(basename "${SAMPLE_FILE%.bam.c4gh}") 

BAMFILE="${SAMPLE}.bam"

# SAMPLE="SJAEL011861_D1"
# BAMFILE="/dartfs/rc/lab/S/Szhao/qiruiz/dataset/EGA/SJAEL011861_D1.bam"
OUTDIR="count"

mkdir -p "$OUTDIR"
mkdir -p "${OUTDIR}/${SAMPLE}"

featureCounts -T 8 -s 0 -p --countReadPairs\
    -g gene_id \
    -a /dartfs/rc/lab/S/Szhao/qiruiz/RNA-seq/Homo_sapiens.GRCh37.87.gtf \
    -o "${OUTDIR}/${SAMPLE}/${SAMPLE}_featurecounts.txt" \
    -t exon \
    "$BAMFILE"

cut -f 1 "${OUTDIR}/${SAMPLE}/${SAMPLE}_featurecounts.txt" > "${OUTDIR}/${SAMPLE}/${SAMPLE}_featurecounts_Name.txt"
cut -f 6 "${OUTDIR}/${SAMPLE}/${SAMPLE}_featurecounts.txt" > "${OUTDIR}/${SAMPLE}/${SAMPLE}_featurecounts_Length.txt"
cut -f 7 "${OUTDIR}/${SAMPLE}/${SAMPLE}_featurecounts.txt" > "${OUTDIR}/${SAMPLE}/${SAMPLE}_featurecounts_Count.txt"

echo "Finished at: $(date)"
