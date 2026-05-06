#!/bin/bash

#SBATCH --job-name=trimm
#SBATCH --output=/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/scripts/out_logs/trimm_%j.out
#SBATCH --error=/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/scripts/out_logs/trimm_%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --mail-type=END                      # Notificación al finalizar
#SBATCH --mail-user=minestev17@gmail.com       # Correo de notificación


## --- Analisis de Fastqc ---
# 1. Cargar el módulo de Trimmomatic
module load trimmomatic/0.33
cd /mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/data/raw

# 2. Correr el analisis
for i in *_1.fastq.gz;
do echo
trimmomatic PE -threads 8 -phred33 $i "${i%_1.fastq.gz}_2.fastq.gz" \
/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/data/processed/"${i%_1.fastq.gz}_1_trimmed.fq.gz" \
/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/data/processed/"${i%_1.fastq.gz}_1_unpaired.fq.gz" \
/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/data/processed/"${i%_1.fastq.gz}_2_trimmed.fq.gz" \
/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/data/processed/"${i%_1.fastq.gz}_2_unpaired.fq.gz" \
ILLUMINACLIP:/mnt/data/bioinfo-estadistica-2/RNAseq_2026/BioProject_2026/adapters/TruSeq3-PE-2.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:80 \

done
