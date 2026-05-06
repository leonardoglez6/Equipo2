#!/bin/bash

#SBATCH --job-name=qc2
#SBATCH --output=/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/scripts/qc2_%j.out
#SBATCH --error=/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/scripts/qc2_%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=12G
#SBATCH --mail-type=END                      # Notificación al finalizar
#SBATCH --mail-user=enosedal@gmail.com       # Correo de notificación

## --- Analisis de Fastqc ---
# 1. Cargar el módulo de fastqc
module load fastqc/0.11.3

# 2. Correr el analisis
for file in /mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/data/processed/*_trimmed.fq.gz; do 
  fastqc -t 8 $file -o /mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/quality2; 
  done

# ---- Analisis de multiqc ---
# 1. Cargar el módulo de Anaconda
module load anaconda3/2025.06

# 2. Activar el ambiente específico dentro de Anaconda
conda activate multiqc-1.5
cd /mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/quality2

# 3. Ejecutar el comando dentro del ambiente
multiqc .
