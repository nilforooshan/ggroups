# Package 'ggroups'

Version 0.1.0

## Installation

`library(devtools) && install_github('nilforooshan/ggroups')`

## Requirement

`# install.packages("pedigreemm")`

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
4 0 0
5 4 0
6 0 0
7 5 6
```

First, unknown parents are replaced with the corresponding genetic groups.

```
4 1 2
5 4 2
6 1 2
7 5 6
```

Then, rows corresponding to genetic groups are added to the head of the pedigree.

```
1 0 0
2 0 0
4 1 2
5 4 2
6 1 2
7 5 6
```

This pedigree is used as a `data.frame` to obtain matrix **Q**.

```r
ped = data.frame(ID=c(1:2,4:7), SIRE=c(0,0,1,4,1,5), DAM=c(0,0,2,2,2,6))
qmat(ped)
```

Assuming `sol` being a `data.frame` with 2 numeric columns corresponding to ID, EBV ([**ĝ**, **û**]), the vextor of **Qĝ** + **û** is obtained by:

```r
Qmat = qmat(ped)
sol = data.frame(ID=c(1:2,4:7), EBV=c(0.2,seq(-0.1,0.3,0.1)))
Qgpu(Qmat, sol)
# OR
Qgpu(qmat(ped), sol)
```
