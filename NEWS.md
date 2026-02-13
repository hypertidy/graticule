# graticule 0.4.0

* Fixed namespace doc thanks to CRAN.

# graticule 0.3.0

* Remove checks for tests upset by package startup messages. 

# graticule 0.2.0

* Now return values of functions are documented. 

* Now import the reproj package for the coordinate transformation support. 

* Removed function `pathologicule()`, no one will miss it. Might reappear as {gridicule} when we have
better PROJ support. 

* Removed unused methods package from Imports. 

* Removed rgdal, maptools, rworldmap, oce from Suggests, and tested check succeeds without
 those being installed. 

* New function `lonlat()` for quick and dirty plots and to generate fields of longitude and  
 latitude. 

* update for #16, not great still but better



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

