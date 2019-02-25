# Package 'ggroups'

Version 1.0.2

## Installation

```r
devtools::install_github('nilforooshan/ggroups')
```

Alternatively:

```r
installer = file.path(tempdir(), 'ggroups_1.0.2.tar.gz')
download.file('https://github.com/nilforooshan/Link-resources/raw/master/link_resources/ggroups_1.0.2.tar.gz', destfile=installer)
install.packages(installer, repos=NULL, type='source')
```

## Description

This package contains pedigree processing and analyzing functions, including functions for checking and renumbering the pedigree, making the pedigree relationship matrix and its inverse, in matrix and tubular formats, as well as functions related to genetic groups.

## Details

First, it is recommended to check the pedigree `data.frame` with the `pedcheck` function. Pedigree relationship matrix and its inverse are fundamentals in the conventional and modern animal breeding. The concept of genetic groups stems from the fact that not all the unknown parents are of the same genetic level. The genetic group contribution matrix (**Q**) is required to weight and add genetic group effects (**ĝ**) to the genetic merit of animals (**û**), which is equal to **Qĝ** + **û** ([Quaas, 1988](https://doi.org/10.3168/jds.S0022-0302(88)79691-5)). Calculating **Q** is computationally challenging, and for large pedigree, large RAM and long computational time is required. Therefore, the functions `qmatL` and its parallel version, `qmatXL` are introduced. Overlap between sire and dam genetic groups is supported.

### Please read the PDF manual for more details.
