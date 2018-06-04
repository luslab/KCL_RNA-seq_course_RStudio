install.packages("XML")
source("https://bioconductor.org/biocLite.R")
biocLite("devtools", "GenomicRanges", "Rsamtools", "tximport", "ShortRead", "GenomicAlignments", "DESeq2")
devtools::install_github("pachterlab/sleuth")
