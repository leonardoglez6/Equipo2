#######
# Script : Analisis de terminos GO
# Used by: Leonardo Daniel González López, Yuliana Denisse Sosa Gómez y Efrén Nosedal González
# Original author: Sofia Salazar, Diego Ramirez y Evelia Coss
# Date: 03/05/2026
# Description: El siguiente script nos permite realiza la Determinacion funcional de los genes diferencialmente expresados
# a partir de los datos provenientes del alineamiento de STAR a R,
# Usage: Correr las lineas en un nodo de prueba en el cluster.
# Arguments:
#   - Input: metadata.csv, cuentas de STAR (Terminacion ReadsPerGene.out.tab)
#   - Output: Matriz de cuentas (CSV y RData)
#######

# --- Load packages ----------
library(gprofiler2) #versión 0.2.4
library(enrichplot) #versión 1.26.6
library(DOSE) #versión 4.0.1
library(clusterProfiler) #versión 4.14.6
library(ggplot2) #versión 4.0.1
library(tidyverse) #versión 2.0.0
library(dplyr) #versión 1.1.4

# --- Load data -----
# Cargar archivos
indir <- "/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/results/"
outdir <- "/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/results/"
figdir <- '/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo2/results/figures/'

# ---- Analisis de terminos Go ----
# Seleccionar bases de datos
sources_db <- c("GO:BP", "KEGG", "REAC", "TF", "MIRNA", "CORUM", "HP", "HPA", "WP")

# Seleccionar solo archivos CSV
files <- dir(indir, pattern = "^DE_(.+)\\.csv$") 

# ---- Ejemplo de UN SOLO ARCHIVO --------
# Extraer el nombre del primer archivo
plot_name <- gsub("^DE_(.+)\\.csv$", "\\1",  files[1]) #name

# Cargar archivo
df <- read.csv(file = paste0(indir, files[1]), row.names = 'X')
head(df)

#              baseMean log2FoldChange     lfcSE      stat    pvalue      padj
# WASH7P       372.360143      0.1485778 0.1449530 1.0250070 0.3053599 0.6378155
# LOC124900384   4.409256      0.6691718 0.8804061 0.7600718 0.4472117        NA
# LOC729737      3.807554      0.9168057 0.9658498 0.9492218 0.3425078        NA
# WASH9P        72.607488      0.1041005 0.2532715 0.4110234 0.6810554 0.8760665
# LOC100288069 111.982262      0.4494935 0.2064235 2.1775306 0.0294410 0.1741807
# LINC01409      8.797616      0.1695586 0.6645915 0.2551320 0.7986211        NA


# Agregar informacion sobre la expresion
abslogFC <- 2 # Corte de 2 log2FoldChange
df <- df %>% 
  dplyr::mutate(Expression = case_when(log2FoldChange >= abslogFC & padj < 0.05 ~ "Up-regulated",
                                       log2FoldChange <= -(abslogFC) & padj < 0.05 ~ "Down-regulated",
                                       TRUE ~ "Unchanged")) 

# Obtener los nombres de los genes
# > UP 
up_genes <- df %>% filter(Expression == 'Up-regulated') %>% 
  arrange(padj, desc(abs(log2FoldChange)))
# Extraer solo el nombre de los genes
up_genes <- rownames(up_genes) 

head(up_genes)
# [1] "SERPINB3" "SERPINB4" "RSAD2"    "CXCL10"   "XAF1"     "FGG"   

# > Down
down_genes <- df %>% filter(Expression == 'Down-regulated') %>% 
  arrange(padj, desc(abs(log2FoldChange)))
# Extraer solo el nombre de los genes
down_genes <- rownames(down_genes) 

head(down_genes)
# [1] "STEAP3"       "EDN2"         "LOC105374117"

# 
multi_gp <- gost(list("Upregulated" = up_genes, 
                      "Downregulated" = down_genes), 
                 correction_method = "fdr", user_threshold = 0.05,
                 multi_query = F, ordered_query = T, 
                 sources = sources_db, 
                 evcodes = TRUE,  # intersection = intersection - a comma separated list of genes 
                 # from the query that are annotated to the corresponding term
                 organism = 'hsapiens') # para humano es hsapiens


## ---- colors ---
# paleta de colores
Category_colors <- data.frame(
  category = c("GO:BP", "GO:CC", "GO:MF", "KEGG",
               'REAC', 'TF', 'MIRNA', 'HPA', 'CORUM', 'HP', 'WP'), 
  label = c('Biological Process', 'Cellular Component', 'Molecular Function',  "KEGG",
            'REAC', 'TF', 'MIRNA', 'HPA', 'CORUM', 'HP', 'WP'),
  colors =  c('#FF9900', '#109618','#DC3912', '#DD4477',
              '#3366CC','#5574A6', '#22AA99', '#6633CC', '#66AA00', '#990099', '#0099C6'))

## ----manhattan plot--------
gostp1 <- gostplot(multi_gp, interactive = FALSE)

# Guardar grafica
ggsave(paste0(figdir, "ManhattanGO_", plot_name, ".png"),
       plot = gostp1, dpi = 300)

## ----Dataframe de todos los datos --------
# Convertir a dataframe
gost_query <- as.data.frame(multi_gp$result)

# Extarer informacion en modo matriz de todos los resultados
bar_data <- data.frame("term" = as.factor(gost_query$term_name), "condition" = gost_query$query, 
                       "count" = gost_query$term_size, "p.adjust" = gost_query$p_value, 
                       'category' = as.factor(gost_query$source), "go_id" = as.factor(gost_query$term_id),
                       'geneNames' = gost_query$intersection
)


## ---- DOWN genes ----
bar_data_down <- subset(bar_data, condition == 'Downregulated')

# Ordenar datos y seleccion por pvalue
bar_data_down <-head(bar_data_down[order(bar_data_down$p.adjust),],40) # order by pvalue
bar_data_down_ordered <- bar_data_down[order(bar_data_down$p.adjust),] # order by pvalue
bar_data_down_ordered<- bar_data_down_ordered[order(bar_data_down_ordered$category),] # order by category
bar_data_down_ordered$p.val <- round(-log10(bar_data_down_ordered$p.adjust), 2)
bar_data_down_ordered$num <- seq(1:nrow(bar_data_down_ordered)) # num category for plot

# Guardar dataset
save(bar_data_down_ordered, file = paste0(outdir, "DOWN_GO_", plot_name, ".RData"))

# agregar colores para la grafica
bar_data_down_ordered_mod <- left_join(bar_data_down_ordered, Category_colors, by= "category")

### ---- DOWN genes (barplot) ----
# Generar la grafica
g.down <- ggplot(bar_data_down_ordered_mod, aes(p.val, reorder(term, -num), fill = category)) +
  geom_bar(stat = "identity") +
  geom_text(
    aes(label = p.val),
    color = "black",
    hjust = 0,
    size = 2.2,
    position = position_dodge(0)
  ) +
  labs(x = "-log10(p-value)" , y = NULL) +
  scale_fill_manual(name='Category', 
                    labels = unique(bar_data_down_ordered_mod$label), 
                    values = unique(bar_data_down_ordered_mod$colors)) +
  theme(
    legend.position = "right",
    axis.title.y = element_blank(),
    strip.text.x = element_text(size = 11, face = "bold"),
    strip.background = element_blank()
  )+ theme_classic()


# Guardar la figura
ggsave(paste0(figdir,"barplotDOWN_GO_", plot_name, ".png"),
       plot = g.down + theme_classic(), dpi = 600, width = 10, height = 5)



## ---- UP genes ----
bar_data_up <- subset(bar_data, condition == 'Upregulated')

# Ordenar datos y seleccion por pvalue
bar_data_up <-head(bar_data_up[order(bar_data_up$p.adjust),],40) # order by pvalue
bar_data_up_ordered <- bar_data_up[order(bar_data_up$p.adjust),] # order by pvalue
bar_data_up_ordered<- bar_data_up_ordered[order(bar_data_up_ordered$category),] # order by category
bar_data_up_ordered$p.val <- round(-log10(bar_data_up_ordered$p.adjust), 2)
bar_data_up_ordered$num <- seq(1:nrow(bar_data_up_ordered)) # num category for plot

# Guardar dataset
save(bar_data_up_ordered, file = paste0(outdir, "UP_GO_", plot_name, ".RData"))

# agregar colores para la grafica
bar_data_up_ordered_mod <- left_join(bar_data_up_ordered, Category_colors, by= "category")

### ---- UP genes (barplot) ----
# Generar la grafica
g.up <- ggplot(bar_data_up_ordered_mod, aes(p.val, reorder(term, -num), fill = category)) +
  geom_bar(stat = "identity") +
  geom_text(
    aes(label = p.val),
    color = "black",
    hjust = 0,
    size = 2.2,
    position = position_dodge(0)
  ) +
  labs(x = "-log10(p-value)" , y = NULL) +
  scale_fill_manual(name='Category', 
                    labels = unique(bar_data_up_ordered_mod$label), 
                    values = unique(bar_data_up_ordered_mod$colors)) +
  theme(
    legend.position = "right",
    # panel.grid = element_blank(),
    # axis.text.x = element_blank(),
    # axis.ticks = element_blank(),
    axis.title.y = element_blank(),
    strip.text.x = element_text(size = 11, face = "bold"),
    strip.background = element_blank() 
  ) + theme_classic()

# Guardar la figura
ggsave(paste0(figdir, "barplotUP_GO_", plot_name, ".png"),
       plot = g.up + theme_classic(), dpi = 600, width = 10, height = 5)

# --- Juntar todos los DEGs ---
deg_genes <- df %>% filter(Expression != "Unchanged")
gene_symbols <- rownames(deg_genes)

# --- Conversión a Entrez ID para KEGG ---
gene_entrez <- bitr(gene_symbols,
                    fromType = "SYMBOL",
                    toType   = "ENTREZID",
                    OrgDb    = org.Hs.eg.db)

# --- KEGG enrichment ---
kegg_res <- enrichKEGG(gene         = gene_entrez$ENTREZID,
                       organism     = "hsa",
                       pvalueCutoff = 1,
                       pAdjustMethod = "fdr") # el artículo usaba FDR

kegg_df <- as.data.frame(kegg_res) %>%
  mutate(
    S           = as.integer(sub("/.*", "", GeneRatio)), # genes nuestros en el pathway
    B           = as.integer(sub("/.*", "", BgRatio)), # genes totales del pathway en KEGG
    Rich_Factor = round(S / B, 4)
  ) %>%
  # Convertir Entrez IDs de vuelta a símbolos en la columna geneID
  rowwise() %>%
  mutate(
    gene_symbols_col = {
      ids  <- strsplit(geneID, "/")[[1]]
      syms <- bitr(ids, fromType = "ENTREZID", toType = "SYMBOL", OrgDb = org.Hs.eg.db)
      paste(syms$SYMBOL, collapse = ", ")
    }
  ) %>%
  ungroup() %>%
  dplyr::select(
    `Pathway ID`   = ID,
    `Pathway Name` = Description,
    `S`            = S,
    `B`            = B,
    `Rich Factor`  = Rich_Factor,
    `P value`      = pvalue,
    `Genes`        = gene_symbols_col
  ) %>%
  filter(`P value` < 0.05) %>% #filtramos por p-value porque pvalueCutoff = 0.05 daba errores
  arrange(`P value`)

write.csv(kegg_df, file = paste0(outdir, "KEGG_enrichment_KD_vs_WT.csv"), row.names = FALSE)