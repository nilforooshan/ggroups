# R package ggroups: Pedigree and Genetic Groups

## Version: 1.1.4

* The 1st official version on CRAN

## Version: 1.2.0

* Modified function `rg` for non-related individuals.
* Added function `mat2tab`.
* Added function `offspring`.
* No backward incompatibility with the previous version

## Version: 1.2.1

* Added function `tabD`.
* Added function `tabDinv`.

## Version 1.3.0

* Debugged function `tabD`.
* Removed function `qmat`.
* Added optional argument `maxgen` to functions `pedup` and `peddown`.

## Version 2.0.1

* Debugged `tabD` function.
* Brought back function `qmat`.
* Added function `buildD`.
* Major computational optimisations (runtime speed) for several functions.

## Version 2.0.2

* Added function `smgsped`.

## Version 2.0.3

* Debugged `tabAinv` for the bug introduced in v2.0.2.

## Version 2.1.0

* Added function `inbreed` based on [Meuwissen & Luo (1992)](https://doi.org/10.1186/1297-9686-24-4-305).
* Function `inb` makes uses of function `inbreed`.

## Version 2.1.1

* Debugged `offspring` function so that in pedigrees with generation overlap animals appear in one generation rather than multiple generations.
