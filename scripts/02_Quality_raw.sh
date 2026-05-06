#!/bin/bash

#SBATCH --job-name=qc1
#SBATCH --output=/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/scripts/out_logs/multiqc_%j.out
#SBATCH --error=/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/scripts/out_logs/multiqc_%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --mail-type=END                      # Notificación al finalizar
#SBATCH --mail-user=minestev17@gmail.com       # Correo de notificación


## --- Analisis de Fastqc ---
# 1. Cargar el módulo de fastqc
module load fastqc/0.11.3

# 2. Correr el analisis
fastqc /mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/data/raw/SRR31732088_1.fastq.gz -o /mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/quality1
fastqc /mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/data/raw/SRR31732090_2.fastq.gz -o /mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/quality1

# ---- Analisis de multiqc ---
# 1. Cargar el módulo de Anaconda
module load anaconda3/2025.06

# 2. Activar el ambiente específico dentro de Anaconda
source activate multiqc-1.5
cd /mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/quality1
# 3. Ejecutar el comando dentro del ambiente
multiqc .
