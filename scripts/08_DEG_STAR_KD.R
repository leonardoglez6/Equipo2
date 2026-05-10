######
# Script : Analisis de expresion diferencial
# Used by: Leonardo Daniel González López, Yuliana Denisse Sosa Gómez & Efrén Nosedal González
# Original author: Sofia Salazar, Diego Ramirez y Evelia Coss
# Date: 02/05/2026
# Description: Analisis de expresion Diferencial a partir de los datos provenientes del alineamiento de STAR a R,
# Primero correr el script "load_data_inR.R"
# Usage: Correr las lineas en un nodo de prueba en el cluster.
# Arguments:
#   - Input: Cargar la variable raw_counts.RData que contiene la matriz de cuentas y la metadata
#   - Output: DEG
#######

# --- Load packages and specifications ----------
library(DESeq2) #versión 1.46.0
library(ggplot2) #versión 4.0.1

# --- Load data -----
# Cargar archivos
outdir <- "/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/results/"
figdir <- '/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/results/figures/'

#Cargar variable "counts", proveniente del script "load_data_inR.R"
load("/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/results/counts/raw_counts.RData")
samples <- metadata$sample_id # Extraer los nombres de los Transcriptomas
metadata$type <- as.factor(metadata$type) # convertir a factor

# --- DEG ----
counts <- counts[which(rowSums(counts) > 10),] #Seleccionamos genes con mas de 10 cuentas

# Convertir al formato dds
dds <- DESeqDataSetFromMatrix(countData =  counts, 
                              colData = metadata, design = ~type) #Se hace un DESeqDataSet para realizar un analisis

dim(dds) # checar las dimensiones
#[1] 17266     6

##  -- Asignar la referencia y generar contrastes -----
# Las comparaciones se realizan por pares
#Si no se indica de manera explicita que se va a comparara, lo va a tomar de manera alfabetica, 
# en este caso se indica que control es la referencia, 
dds$type <- relevel(dds$type, ref = "WT") 

## --- Obtener archivo dds ----

dds <- DESeq(dds)

# estimating size factors
# estimating dispersions
# gene-wise dispersion estimates
# mean-dispersion relationship
# final dispersion estimates
# fitting model and testing

# Obtener la lista de coeficientes o contrastes
resultsNames(dds)

#[1] "Intercept"                   "type_STEAP3.knockdown_vs_WT"

# Guardar la salida del diseno
save(metadata, dds, file = paste0(outdir, 'STEAP3_KD_vs_WT.RData'))

## --- Normalizacion de los datos ---------

# Regularized logarithm or rlog
# Normalizacion de las cuentas por logaritmo y podrias hacer el analisis usando este objeto en lugar del dds
ddslog <- rlog(dds, blind = F) #Para DEG
ddslog_vis <- rlog(dds, blind = T) #Para visualizar

## --- Deteccion de batch effect ----

# Almacenar la grafica
plt <- plotPCA(ddslog_vis, intgroup = "type")
ggsave(filename = paste0(figdir, "PCA_rlog.png"), plot = plt)
#png(file = paste0(figdir, "PCA_rlog.png"))
#plt <- plotPCA(ddslog_vis, intgroup = "type")
#print(plt)
#dev.off()

# En la grafica de las primeras dos componentes principales son notorias las diferencias 
# entre tipos de muestras con respecto a las componente principales que capturan su varianza, 
# cada componente principal representa una combinacion lineal de las variables (en este caso genes) 
# que explican la mayor cantidad de varianza en nuestros datos (las cuentas).

## ---- Obtener informacion del único contraste ----
# results(dds, contrast=c("condition","treated","untreated"))
res_KD <- results(dds, name = "type_STEAP3.knockdown_vs_WT")
res_KD

summary(res_KD)

# out of 17266 with nonzero total read count
# adjusted p-value < 0.1
# LFC > 0 (up)       : 744, 4.3%
# LFC < 0 (down)     : 825, 4.8%
# outliers [1]       : 0, 0%
# low counts [2]     : 4687, 27%
# (mean count < 15)
# [1] see 'cooksCutoff' argument of ?results
# [2] see 'independentFiltering' argument of ?results

# Guardar los resultados
write.csv(res_KD, file=paste0(outdir, 'DE_KD_vs_WT.csv'))
