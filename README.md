# Package 'ggroups'

Version 0.1.1

## Installation

```r
devtools::install_github('nilforooshan/ggroups')
```

## Requirement

```r
require("pedigreemm")
```

## Getting help

```r
?ggroups
?qmat
?Qgpu
```

[PDF Manual](https://github.com/nilforooshan/ggroups/blob/master/man/ggroups.pdf)

## Description

This package contains functions related to calculating the matrix of genetic group contributions to individuals in a pedigree, and adding genetic group contributions to genetic merit of animals in a pedigree.

## Details

The concept of genetic groups or phantom parent groups is based on the fact that unknown parents do not belong to the same base population and they might come from different genetic levels. With **Q**, **ĝ**, and **û** being the matrix of genetic group contributions to individuals in the pedigree, the vector of predicted additive genetic merit of animals, and the vector of predicted genetic group effects, respectively, the contribution of genetic groups should be added to the predicted genetic merit of animals (**Qĝ** + **û**).  
Forming Mixed Model Equations corresponding to the model, **û** and **ĝ** are predicted (Quaas, 1988: Eq. [3]). However, using Quaas and Pollak (1981) transformation, **Qĝ** + **û** can be obtained directly (Quaas, 1988: Eq. [4]).  
Some solver packages obtain **Qĝ** + **û** directly, some not. The aim of this package is to find the genetic contribution of each genetic group on each individual in the pedigree (matrix **Q**), and also calculating **Qĝ** + **û**, given the pedigree and a vector of [**ĝ**, **û**].

## Usage

Consider this simple pedigree:

```
3 0 0
4 3 0
6 4 5
5 0 0
```

First, unknown parents are replaced with the corresponding genetic groups.  
Please note that unknown parent IDs should be smaller than animal IDs.

```
3 1 2
4 3 2
6 4 5
5 1 2
```

This pedigree is provided as a sample data (`sampleped`) by the package, with columns corresponding to ID, SIRE, DAM.  
A sample data for solutions is provided (`samplesol`) by the package, with columns corresponding to ID, EBV ([**ĝ**, **û**]).  
`sampleped` and `samplesol` are used in the examples.

Perform pedigree checks, add genetic groups to the pedigree and sort it:

```r
gghead(sampleped)
```

Obtain matrix **Q**:

```r
qmat(gghead(sampleped))
```

Obtain vextor **Qĝ** + **û**:

```r
Qgpu(qmat(gghead(sampleped)), samplesol)
```
