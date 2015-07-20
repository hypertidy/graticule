
graticule
=========

Graticules are the longitude latitude lines shown on a projected map, and defining and drawing these lines is not easy to automate. The graticule package provides the tools to create and draw these lines by explicit specification by the user. This provides a good compromise between high-level automation and the flexibility to drive the low level details as needed, using base graphics in R.

Installation
============

The graticule package is on GitHub, and can be installed like this:

    ```R
    if (packageVersion("devtools") < 1.6) {
      install.packages("devtools")
    }
    devtools::install_github("mdsumner/graticule")
    ```

Known issues
------------

o There's work needed for when `graticule_labels()` are created without using `xline/yline`, need more careful separation between generating every combination in the grid versus single lines
