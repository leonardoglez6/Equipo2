#!/bin/bash

#SBATCH --job-name=YL_DownloadData              # Nombre del trabajo
#SBATCH --output=/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/data/raw/YLDownloadData%j.out
#SBATCH --error=/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/data/raw/YLøDownloadData_%j.err
#SBATCH --ntasks=1                           # Solo una tarea
#SBATCH --cpus-per-task=1                    # Un núcleo
#SBATCH --mem=2G                             # Memoria pequeña, suficiente para wget
#SBATCH --mail-type=END                      # Notificación al finalizar
#SBATCH --mail-user=minestev17@gmail.com       # Correo de notificación

# Usa el shell bash

# Cargar entorno de módulos si es necesario
. /etc/profile.d/modules.sh

# Cambiar al directorio de trabajo
cd /mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/data/raw

# Comandos de descarga
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR317/090/SRR31732090/SRR31732090_2.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR317/086/SRR31732086/SRR31732086_1.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR317/087/SRR31732087/SRR31732087_2.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR317/089/SRR31732089/SRR31732089_1.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR317/087/SRR31732087/SRR31732087_1.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR317/088/SRR31732088/SRR31732088_2.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR317/090/SRR31732090/SRR31732090_1.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR317/091/SRR31732091/SRR31732091_1.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR317/086/SRR31732086/SRR31732086_2.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR317/089/SRR31732089/SRR31732089_2.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR317/088/SRR31732088/SRR31732088_1.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR317/091/SRR31732091/SRR31732091_2.fastq.gz
