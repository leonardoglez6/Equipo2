# RNAseq report: Silencing of STEAP3 suppresses cervical cancer cell proliferation and migration via JAK/STAT3 signaling pathway

**Fecha de creación:** 14/04/2026

**Materia:** Bioinformática y estadística 2

**Semestre:** 4to semestre

## Integrantes del equipo 👥

-   **Equipo:** 2

-   **Integrantes:**

    -   Leonardo González López (lgonzalez) -
        [minestev17\@gmail.com](mailto:minestev17@gmail.com),
    -   Yuliana Denisse Sosa Gómez (ysosa) -
        [yuliana.sogo2006\@gmail.com](mailto:yuliana.sogo2006@gmail.com)

## Resumen ⚡️

El artículo “Silencing of STEAP3 suppresses cervical cancer cell proliferation and migration via JAK/STAT3 signaling pathway” propone investigar los mecanismos de STEAP3 en la proliferación y migración celular en cáncer cervical. SYEAP3 pertenece a la familia de las proteínas STEAP los cuáles se ha reportado que participan en la proliferación y metástasis del cáncer. Con RNA-seq se comparó la expresión de las vías de señalización en las cuáles participa STEAP3 en presencia de STEAP3 (NC) y con knockdown del gen (KD) en células de la línea celular HeLA.

**Reporte renderizado**: Se encuentra dentro del Github en el archivo [Reporte-Bioproject-Final.html](https://github.com/leonardoglez6/Equipo2/blob/main/Reporte-Bioproject-Final.html)

## Estructura 🗂️

La estructura del proyecto dentro del repositorio de GitHub es la siguiente:

### 📁 Equipo2

- **README.md**: Archivo README del proyecto.

- **Reporte-Bioproject-Final.Rmd**: Archivo que contiene el reporte documentando los datos utilizados obtenidos del BioProject, los resultados obtenidos a partir de los scripts realizados y la discusión de los resultados obtenidos abarcando la comparación con los resultados reportados en el artículo de origen y la complementación con bibliografía adicional.

- **Reporte-Bioproject-Final.html**: Reporte renderizado en formato html.

- **Infografia-Cientifica-Proyecto.pdf**: Infografía del flujo de trabajo y conclusiones para público general.

- **metadata.csv**: Archivo que contiene la metadata utilizada en los scrpits.

| SampleID    | Condición        |
|-------------|------------------|
| SRR31732086 | STEAP3 knockdown |
| SRR31732087 | STEAP3 knockdown |
| SRR31732088 | STEAP3 knockdown |
| SRR31732089 | WT               |
| SRR31732090 | WT               |
| SRR31732091 | WT               |

#### 📁 figures

- **Heatmap_KD_vs_WT.png**: Heatmap que muestra los 20 genes expresados diferencialmente con el p-value más significativo.

- **KEGG_droplot.png**: Droplot que muestra los pathways de KEGG más enriquecidos en los cuales se encuentran los genes expresados diferencialmente obtenidos.

- **ManhattanGO_KD_vs_WT.png**: Manhattan plot de Gene Ontology (GO) que muestra la significancia estadística utilizando el $-\log_{10}(\text{p-value})$ de diferentes enriquecimientos.

- **VolcanoPlot_KD_vs_WT.png**: Volcano plot que muestra los genes up-regulated y down-regulated con log2FoldChange ≥ 2 y ≤ -2 respectivamente, y que tienen un p-valor ajustado < 0.05.

- **barplotDOWN_GO_KD_vs_WT.png**: Barplot con los 40 términos enriquecidos con menor p-value de distintas bases de datos de los genes up-regulated.

- **barplotUP_GO_KD_vs_WT.png**: Barplot con los 40 términos enriquecidos con menor p-value de distintas bases de datos de los genes down-regulated.

- **PCA_rlog.png**: PCA que muestra el batch effect de nuestros datos.

- **PCA_no_batch_rlog.png**: PCA que con el batch effect corregido de nuestros datos.

- **Diagrama_de_flujo.png**: Contiene el workflow del proyecto.

- **Gráficas fastqc**: Contiene las diferentes gráficas obtenidas por el archivo multiqc.

#### 📁 out_logs

Dentro de esta carpeta se encuentran los out logs de todos los jobs de slurm que se corrieron en el cluster ken incluyendo aquellos scripts fallidos como Nextflow.

#### 📁 quality

- **multiqc_report_raw.html**: Reporte de calidad de los 12 archivos FASTQ de datos crudos.

- **multiqc_report_processed.html**: Reporte de calidad de los 12 archivos FASTQ de datos procesados.

#### 📁 results

- **DE_KD_vs_WT.csv**: Contiene la matriz con los genes diferencialmente expresados expresados (DEGs) con su log2FoldChange, p-value y p-value ajustado.

- **DOWN_GO_KD_vs_WT.csv**: Contiene una matriz con los 40 terminos enriquecidos con p-valor más significativo y su p-valor, genes down-regulated y cuentas.

- **KEGG_enrichment_KD_vs_WT.csv**: Contiene una matriz con las vías KEGG enriquecidas con un p-valor < 0.05 para los genes expresados diferencialmente con un log2FoldChange ≥ 2 para los genes up-regulated y ≤ 2 para los genes down-regulated.

- **STEAP3_KD_vs_WT.RData**: Contiene la matriz con la metadata y el objeto dds generado con DESeq2.

- **UP_GO_KD_vs_WT.csv**: Contiene una matriz con los 40 terminos enriquecidos con p-valor más significativo y su p-valor, genes up-regulated y cuentas.

##### 📁 counts

- **raw_counts.RData**: Contiene la matriz con la metadata y la matriz de cuentas crudas de los 6 transcriptomas.

- **raw_counts.csv**: Contiene la matriz de cuentas crudas de los 6 transcriptomas.

##### 📁 figures

Contiene todas las figuras que se encuentran en el directorio `/figures` fuera del directorio `/results` a excepción de las gráficas de los reportes multiqc

#### 📁 scripts

- **01_DownloadRawData.sh**: Descarga los archivos FASTQ del BioProject.

- **02_Quality_raw.sh**: Obtiene los reportes FASTQC de cada muestra y realiza un reporte multiqc de todas las muestras.

- **03_Trimmed.sh**: Realiza el procesado de las muestras para eliminar adaptadores y secuencias de mala calidad.

- **04_Quality_trimmed.sh**: Obtiene los reportes FASTQC de cada muestra procesada y realiza un reporte multiqc de todas las muestras procesadas.

- **05_STAR_index.sh**: Realiza el indexado del genoma de referencia y el archivo de anotaciones para realizar el posterior alineamiento con STAR.

- **06_STAR_align.sh**: Realiza el alineamiento y genera la matriz de cuentas crudas de cada mues†ra utilizando STAR.

- **07_Load_data_STAR.R**: Carga las matrices de cuentas crudas de cada muestra y genera una matriz de cuentas crudas conjunta.

- **S07_Load_data_STAR.sh**: Job de slurm para correr el archivo 07_Load_data_STAR.R.

- **08_DEG_STAR_KD.R**: Realiza la corrección por batch effect de los datos y el análisis de expresión diferencial.

- **S08_DEG_STAR_KD.sh**: Job de slurm para correr el archvo 08_DEG_STAR_KD.R.

- **09_Visualization_data_STAR.R**: Genera un volcano plot de los genes expresados diferencialmente con un p-valor significativo y un log2FoldChange ≥ 2 para genes up-regulated y ≤ 2 para genes down-regulated.

- **S09_Visualization_data_STAR.sh**: Job de slurm para correr el archvo 09_Visualization_data_STAR.R.

- **10_GO_terms_STAR.R**: Realiza enrequecimiento de diferentes términos de distintas bases de datos (GO, KEGG).

- **S10_GO_terms_STAR.sh**: Job de slurm para correr el archvo 10_GO_terms_STAR.R.

## Metadatos 🪪

| **Muestras**   | **Condición**        | **SampleID**     | **Réplica biológica** |
|----------------|----------------------|------------------|-----------------------|
| GSM8682795 | STEAP3 knockdown | SAMN45855841 | KD_3              |
| GSM8682794 | STEAP3 knockdown | SAMN45855842 | KD_2              |
| GSM8682793 | STEAP3 knockdown | SAMN45855843 | KD_1              |
| GSM8682792 | WT               | SAMN45855844 | NC_3              |
| GSM8682791 | WT               | SAMN45855845 | NC_2              |
| GSM8682790 | WT               | SAMN45855846 | NC_1              |

## Cluster modules 🛠️

```
module load anaconda3/2025.06
⎣ source activate multiqc-1.5
module load fastqc/0.11.3
module load star/2.7.9a 
module load trimmomatic/0.33
```

## R packages 🛠️

```
library(clusterProfiler) #versión 4.14.6
library(DESeq2) #versión 1.46.0
library(DOSE) #versión 4.0.1
library(dplyr) #versión 1.1.4
library(enrichplot) #versión 1.26.6
library(ggplot2) #versión 4.0.1
library(ggforce) #versión 0.5.0
library(ggrepel) #versión 0.9.6
library(gprofiler2) #versión 0.2.4
library(org.Hs.eg.db) #versión 3.20.0
library(pheatmap) #versión 1.0.13
library(tidyverse) #versión 2.0.0
```

## Pipeline ⏬

1. Se realizó la descarga de los archivos de secuencia cruda FASTQ de las 6 muestras en el cluster ken desde la página de SRA del BioProject que corresponde al artículo, obteniendo 12 archivos debido a que se secuenció utilizando paired ends, correspondiendo dos archivos por cada muestra. Se utilizó el script `01_DownloadRawData.sh`.

2. Se realizaron los reportes de calidad fastqc de todos los archivos de secuencia crudas y con ellos se realizó un reporte de calidad en conjunto multiqc. Los reportes son archivos html. Se utilizó el script `02_Quality_raw.sh`.

3. Se realizó el procesamiento de las secuencias crudas quitando secuencias de adaptadores y de mala calidad. Se generaron 24 archivos FASTQ de secuencias procesadas, 2 archivos procesados (trimmed y unpaired) por cada archivo de secuencia cruda. Se utilizó el script `03_Trimmed.sh`.

4. Se realizaron los reportes de calidad fastqc y multiqc de los archivos de secuencia procesados. Se utilizó el script `*04_Quality_trimmed.sh`.

5. Se realizaron enlaces simbólicos al genoma de referencia humano versión GRCh38.p14 y a su archivo de anotación. 

6. Se realizó el indexado del genoma y su archivo de anotaciones utilizando STAR para su posterior alineamiento utilizando la misma metodología. Se generaron todos los archivos correspondientes al indexado. Se utilizó el script `05_STAR_index.sh`.

7. Se realizó el alineamiento de las secuencias procesadas para generar 6 transcriptomas (1 por muestra) utilizando STAR. Generó los archivos correspondientes por muestra, dentro los cuales estaban archivos con terminación .ReadPerGene.out.tab los cuales contenían las cuentas para cada gen. Se utilizó el script `06_STAR_align.sh`.

8. Se realizó la importación de las matrices de cuentas generada en el paso anterior a R. Se generó una matriz de cuentas conjunta de todas las muestras y se cargó el archivo de metadata; ambos objetos se guardaron en un .Rdata. Se utilizó el script `S07_Load_data_STAR.sh` para correr el Rscript `07_Load_data_STAR.R`.

9. Se utilizó la matriz de cuentas generada en el paso anterior para realizar la visualización del batch effect de los datos y su corrección; también se generó el objeto que contiene a la matriz de expresión diferencial de los genes. Se utilizó el script `S08_DEG_STAR_KD.sh` para correr el Rscript `.08_DEG_STAR_KD.R`.

10. Se utiizó la matriz de expresión diferencial para realizar un volcanoplot de los genes con un log2FoldChange ≥ 2 y ≤ 2; además se realizó un heatmap con los 20 genes expresados diferencialmente con un p-value más significativo. Se utilizó el script `S09_Visualization_data_STAR.sh` para correr el Rscript `09_Visualization_data_STAR.R`.

11. Se utilizó la matriz de expresión diferencial para realizar un Manhattan plot con los términos GO más enriquecidos, barplots de genes sobreexpresados y subregulados y un dotplot de las vías de KEGG más enriquecidas. Se utilizó el script `S10_GO_terms_STAR.sh` para correr el Rscript `10_GO_terms_STAR.R`.


## Referencias

-   Zhao, Z., Yu, P., Wang, Y., Li, H., Qiao, H., Sun, C., Zhu, L., &
    Yang, P. (2024). Silencing of *STEAP3* suppresses cervical cancer
    cell proliferation and migration via JAK/STAT3 signaling
    pathway. *Cancer & metabolism*, *12*(1), 40.
    <https://doi.org/10.1186/s40170-024-00370-2>

-   Terán, M., Mónaco, M., Haro, C., Ledesma, M. *et al*. Ferroptosis,
    un mecanismo de muerte celular presente en β-talasemia menor.
    (2024). *Revista Bioquímica Y Patología Clínica*, *89*(1),
    19-26. <https://doi.org/10.62073/k7g1yk82>

-   Han, Y., Fu, L., Kong, Y., Jiang, C., Huang, L., & Zhang, H. (2024).
    STEAP3 Affects Ovarian Cancer Progression by Regulating Ferroptosis
    through the p53/SLC7A11 Pathway. *Mediators of inflammation*,
    *2024*, 4048527. <https://doi.org/10.1155/2024/4048527>

-   Wang, S., Luke, C.J., Pak, S.C. *et al.* SERPINB3 (SCCA1) inhibits
    cathepsin L and lysoptosis, protecting cervical cancer cells from
    chemoradiation. *Commun Biol* **5**, 46 (2022).
    <https://doi.org/10.1038/s42003-021-02893-6>

-   Li, X., Lu, M., Yuan, M., Ye, J., Zhang, W., Xu, L., Wu, X., Hui,
    B., Yang, Y., Wei, B., Guo, C., Wei, M., Dong, J., Wu, X., & Gu, Y.
    (2022). CXCL10-armed oncolytic adenovirus promotes
    tumor-infiltrating T-cell chemotaxis to enhance anti-PD-1 therapy.
    *Oncoimmunology*, *11*(1), 2118210.
    <https://doi.org/10.1080/2162402X.2022.2118210>
