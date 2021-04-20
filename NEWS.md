# graticule 0.1.6

* Release to fix problems on CRAN, unused LazyData and dep on rmarkdown. 

* Remove warnings from geosphere about longitude, thanks to @Maschette for the suggestion. 

* Fix bug caused by new tile creation. https://github.com/AustralianAntarcticDivision/SOmap/issues/66

* Tile and line graticules are now created by the same process, which discretizes
to a default value of 5e4m (50km). This is settable with `options(graticule.mindist = )`. 

* graticule no longer shares the extra dependency from raster on rgeos, rasterToPolygons is no longer used

* Added supporting information to the package. 


     VERSION 0.1.2

o specify LCC standard parallels explicitly to avoid problems from some PROJ.4 installations

     VERSION 0.1.0

o new function pathologicule to draw the other projection

    VERSION 0.0.3

o upgraded for release

o added ice file raw data for vignette

    VERSION 0.0.2

o added tiles option to graticule to return polygons

o added a readme for the GitHub front page

    VERSION 0.0.1

o basics working

