install.packages("XML")
source("https://bioconductor.org/biocLite.R")
biocLite("devtools", "tximport", "ShortRead", "GenomicAlignments", "DESeq2", suppressUpdates=TRUE, suppressAutoUpdate=TRUE)
devtools::install_github("pachterlab/sleuth")
