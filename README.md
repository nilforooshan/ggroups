# Package 'ggroups'

Version 0.1.2

## Installation

```r
devtools::install_github('nilforooshan/ggroups')
```

## Getting help

```r
?`ggroups-package`
?buildA
?gghead
?qmat
?Qgpu
```

[PDF Manual](https://github.com/nilforooshan/ggroups/blob/master/man/ggroups.pdf)

## Description

This package contains functions related to calculating the matrix of genetic group contributions to individuals in a pedigree, and adding genetic group contributions to genetic merit of animals in a pedigree.  It also calculates the genetic relationship matrix **A** from the pedigree.

## Details

The concept of genetic groups or phantom parent groups is based on the fact that unknown parents do not belong to the same base population and they might come from different genetic levels. With **Q**, **ĝ**, and **û** being the matrix of genetic group contributions to individuals in the pedigree, the vector of predicted additive genetic merit of animals, and the vector of predicted genetic group effects, respectively, the contribution of genetic groups should be added to the predicted genetic merit of animals (**Qĝ** + **û**).  
Forming Mixed Model Equations corresponding to the model, **û** and **ĝ** are predicted:

![QuassEq3](https://raw.githubusercontent.com/nilforooshan/Link-resources/master/link_resources/Quaas3.gif)

However, using Quaas and Pollak (1981) transformation, **Qĝ** + **û** can be obtained directly:

![QuassEq4](https://raw.githubusercontent.com/nilforooshan/Link-resources/master/link_resources/Quaas4.gif)

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

This pedigree is used as an example.

```r
ped = data.frame(ID=c(3,4,6,5), SIRE=c(1,3,4,1), DAM=c(2,2,5,2))
```

Perform pedigree checks, add genetic groups to the pedigree and sort it:

```r
gghead(ped)
```

Obtain matrix **Q**:

```r
qmat(gghead(ped))
```

Assume the following `data.frame` for solutions, with columns corresponding to ID, EBV ([**ĝ**, **û**]):

```r
ghat = c(0.1, -0.1)
uhat = seq(-0.15, 0.15, 0.1)
sol = data.frame(ID=1:6, EBV=c(ghat, uhat)))
```

Obtain vextor **Qĝ** + **û**:

```r
Qgpu(qmat(gghead(ped)), sol)
```

To build an additive genetic relationship matrix (**A**) from a pedigree:

```r
ped = data.frame(ID=1:6, SIRE=c(0,0,1,3,1,4), DAM=c(0,0,2,2,2,5))
buildA(ped)
```
