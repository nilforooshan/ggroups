# Package 'ggroups'

Version 1.1.4

## Installation

To get the current released version from CRAN:

```r
install.packages("ggroups")
```

To get the current development version from GitHub, do one of the two followings:

```r
# install.packages("devtools")
devtools::install_github('nilforooshan/ggroups')
```

or

```r
file_tar.gz = 'ggroups_1.1.4.tar.gz' # Find the filename at https://github.com/nilforooshan/Link-resources/raw/master/link_resources/
installer = file.path(tempdir(), file_tar.gz)
download.file(paste0("https://github.com/nilforooshan/Link-resources/raw/master/link_resources/", file_tar.gz), destfile=installer)
install.packages(installer, repos=NULL, type='source')
```

## Description

This package contains pedigree processing and analyzing functions, including functions for checking and renumbering the pedigree, making the pedigree relationship matrix and its inverse, in matrix and tabular formats, as well as functions related to genetic groups.

## Details

First, it is recommended to check the pedigree `data.frame` with the `pedcheck` function. Pedigree relationship matrix and its inverse are fundamentals in the conventional and modern animal breeding. The concept of genetic groups stems from the fact that not all the unknown parents are of the same genetic level. The genetic group contribution matrix (**Q**) is required to weight and add genetic group effects (**&gcirc;**) to the genetic merit of animals (**&ucirc;**), which is equal to **Q&gcirc;** + **&ucirc;** ([Quaas, 1988](https://doi.org/10.3168/jds.S0022-0302(88)79691-5)). Calculating **Q** is computationally challenging, and for large pedigree, large RAM and long computational time is required. Therefore, the functions `qmatL` and its parallel version, `qmatXL` are introduced. Overlap between sire and dam genetic groups is supported.

### For more details, please read the PDF manual.
