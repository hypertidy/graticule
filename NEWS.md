# graticule 0.1.5

* added a message about a future migration to sf (simple features) return values, this version starts using sf internally, but still returns Spatial classes

* line and tile collection and projection transformation is now done using sf, 
with the OGR_ENABLE_PARTIAL_REPROJECTION environment variable set to TRUE. This 
means a much wider variety of regions and projections can be successfully generated, 
and the building will be a bit faster. 

* tile creation now performed with quadmesh, which is significantly faster and allows
generation of much larger numbers of tiles

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

