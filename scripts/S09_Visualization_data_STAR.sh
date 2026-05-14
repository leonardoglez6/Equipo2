#!/bin/bash

#SBATCH --job-name=Visualization_data_STAR             # Nombre del trabajo
#SBATCH --output=/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/scripts/out_logs/Visualization_data_STAR%j.out
#SBATCH --error=/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/scripts/out_logs/Visualization_data_STAR%j.err
#SBATCH --ntasks=1                           # Solo una tarea
#SBATCH --cpus-per-task=1                    # Un núcleo
#SBATCH --mem=2G                             # Memoria pequeña, suficiente para wget
#SBATCH --mail-type=END                      # Notificación al finalizar
#SBATCH --mail-user=minestev17@gmail.com       # Correo de notificación

# Cambiar al directorio de trabajo
cd /mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/scripts

# Cargar modulo de R
module load r/4.4.1-ybalderas

# Correr script 09_Visualization_data_STAR.R
Rscript 09_Visualization_data_STAR.R
