
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![Travis-CI Build
Status](https://travis-ci.org/mdsumner/graticule.svg?branch=master)](https://travis-ci.org/mdsumner/graticule)
[![](http://www.r-pkg.org/badges/version/graticule)](http://www.r-pkg.org/pkg/graticule)
[![](http://cranlogs.r-pkg.org/badges/graticule)](http://www.r-pkg.org/pkg/graticule)

# graticule

Graticules are the longitude latitude lines shown on a projected map,
and defining and drawing these lines is not easy to automate. The
graticule package provides the tools to create and draw these lines by
explicit specification by the user. This provides a good compromise
between high-level automation and the flexibility to drive the low level
details as needed, using base graphics in R.

# Installation

Insall the latest released version from CRAN with

``` r
install.packages("graticule")
```

The development version of the graticule package is on GitHub, and can
be installed like this:

``` r
devtools::install_github("mdsumner/graticule")
```

## Known issues

Please feel free to share your experiences and report problems at
<https://github.com/mdsumner/graticule/issues>

  - general problems with segmentation, this is not done smartly yet
  - There’s work needed for when `graticule_labels()` are created
    without using `xline/yline`, need more careful separation between
    generating every combination in the grid versus single lines

-----

Please note that the ‘graticule’ project is released with a [Contributor
Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project,
you agree to abide by its terms.
