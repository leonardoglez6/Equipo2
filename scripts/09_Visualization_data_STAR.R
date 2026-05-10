######
# Script : Visualizacion grafica de los resultados de DEG
# Used by: Leonardo Daniel González López, Yuliana Denisse Sosa Gómez y Efrén Nosedal González
# Original author: Sofia Salazar, Diego Ramirez y Evelia Coss
# Date: 03/05/2026
# Description: El siguiente script nos permite realiza el Analisis de Terminos GO
# a partir de los datos provenientes del Analisis de DEG
# Usage: Correr las lineas en un nodo de prueba en el cluster.
# Arguments:
#   - Input: 
#       - STEAP3_KD_vs_WT.RData (dds), 
#       - archivoo de salida de DEG en formato CSV DE_KD_vs_WT.csv 
#   - Output: Volcano plot y Heatmap
#######

# --- Load packages ----------
library(dplyr) #versión 1.1.4
library(pheatmap) #versión 1.0.13
library(ggplot2) #versión 4.0.1

# --- Load data -----
# Cargar archivos
figdir <- '/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/results/figures/'

#Cargar variable "dds", proveniente del script "DEG_STAR_KD.R"
load("/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/results/STEAP3_KD_vs_WT.RData")

#Cargar variable "res_KD", proveniente del script "DEG_STAR_KD.R"
res_KD <- read.csv("/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/results/DE_KD_vs_WT.csv", row.names = 1) 

# ---- volcano plot ----
df <- as.data.frame(res_KD)
# padj 0.05 y log2FoldChange de 2
df <- df %>% 
  mutate(Expression = case_when(log2FoldChange >= 2 & padj < 0.05 ~ "Up-regulated",
                                log2FoldChange <= -(2) & padj < 0.05 ~ "Down-regulated",
                                TRUE ~ "Unchanged"))

# visualizacion
#png(file = paste0(figdir, "VolcanoPlot_30min_vs_control.png"))
volcano <- ggplot(df, aes(log2FoldChange, -log(padj,10))) +
  geom_point(aes(color = Expression), size = 0.7) +
  labs(title = "STEAP3 vs WT") +
  xlab(expression("log"[2]*"FC")) + 
  ylab(expression("-log"[10]*"p-adj")) +
  scale_color_manual(values = c("cornflowerblue", "gray50", "firebrick1")) +
  guides(colour = guide_legend(override.aes = list(size=1.5))) +
  geom_vline(xintercept = 2, linetype = "dashed", color = "black", alpha = 0.5) +
  geom_vline(xintercept = -(2), linetype = "dashed", color = "black", alpha = 0.5) +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed", color = "black", alpha = 0.5)

ggsave(filename = paste0(figdir, "VolcanoPlot_KD_vs_WT.png"), plot = volcano)

#dev.off()

# --- Heatmap  (por contrastes) (log2 Fold Change) -----
topGenes <- rownames(res_KD[order(res_KD$padj), ])[1:20] # Obtener el nombre de los 20 genes con p value mas significativo

betas <- coef(dds)
colnames(betas)
# [1] "Intercept"                   "type_STEAP3.knockdown_vs_WT"

mat <- betas[topGenes, "type_STEAP3.knockdown_vs_WT", drop = FALSE] # crear la matriz con el topgene de genes
dim(mat) # [1] 20  1

# Filtro de 3 log2foldchange
thr <- 3 
mat[mat < -thr] <- -thr
mat[mat > thr] <- thr

# Almacenar la grafica
#png(file = paste0(figdir, "Heatmap_log2FoldChage_topgenes.png"))
heat <- pheatmap(mat, breaks=seq(from=-thr, to=thr, length=101),
         cluster_col=FALSE, angle_col = 0)
#dev.off()
ggsave(filename = paste0(figdir, "Heatmap_KD_vs_WT.png"), plot = heat)

# https://master.bioconductor.org/packages/release/workflows/vignettes/rnaseqGene/inst/doc/rnaseqGene.html#time-course-experiments