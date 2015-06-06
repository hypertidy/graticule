<!-- README.md is generated from README.Rmd. Please edit that file -->
Graticules for R
================

Graticules are the longitude latitude lines shown on a projected map, and defining and drawing these lines is not easy to automate. The **graticule** package provides the flexibiility to create and draw these lines by explicit specification by the user.

A simple example uses data from **rworldmap**.

``` r
library(rgdal)
library(raster)
library(rworldmap)
data(countriesLow)
llproj <- projection(countriesLow)
library(graticule)
map<- subset(countriesLow, SOVEREIGNT == "Australia")

## VicGrid
prj <- "+proj=lcc +lat_1=-36 +lat_2=-38 +lat_0=-37 +lon_0=145 +x_0=2500000 +y_0=2500000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"

pmap <- spTransform(map, CRS(prj))

## specify exactly where we want meridians and parallels
lons <- seq(140, 150, length = 5)
lats <- seq(-40, -35, length = 6)
## optionally, specify the extents of the meridians and parallels
## here we push them out a little on each side
xl <-  range(lons) + c(-0.4, 0.4)
yl <- range(lats) + c(-0.4, 0.4)
## build the lines with our precise locations and ranges
grat <- graticule(lons, lats, proj = prj, xlim = xl, ylim = yl)
## build the labels, here they sit exactly on the western and northern extent
## of our line ranges
labs <- graticule_labels(lons, lats, xline = min(xl), yline = max(yl), proj = prj)

## set up a map extent and plot
op <- par(mar = rep(0, 4))
plot(extent(grat) + c(4, 2) * 1e5, asp = 1, type = "n", axes = FALSE, xlab = "", ylab = "")
plot(pmap, add = TRUE)
## the lines are a SpatialLinesDataFrame
plot(grat, add = TRUE, lty = 5, col = rgb(0, 0, 0, 0.8))
## the labels are a SpatialPointsDataFrame, and islon tells us which kind
text(subset(labs, labs$islon), lab = parse(text = labs$lab[labs$islon]), pos = 3)
text(subset(labs, !labs$islon), lab = parse(text = labs$lab[!labs$islon]), pos = 2)
```

![](README-unnamed-chunk-2-1.png)

``` r

par(op)
```

A polar example
---------------

Download some ice concentration data and plot with a graticule. This is not the prettiest map it could be, the example is showing how we have control over exactly where the lines are created. We can build the lines anywhere, not necessarily at regular intervals or rounded numbers, and we can over or under extend the parallels relative to the meridians and vice versa.

``` r
library(raster)
library(graticule)
library(rgdal)
icefile <- "ftp://sidads.colorado.edu/pub/DATASETS/nsidc0081_nrt_nasateam_seaice/south/nt_20150530_f17_nrt_s.bin"
tfile <- file.path(tempdir(), basename(icefile))
if (!file.exists(tfile)) download.file(icefile, tfile, mode = "wb")

ice <- raster(tfile)

meridians <- seq(-180, 160, by = 20)
parallels <- c(-80, -73.77, -68, -55, -45)
mlim <- c(-180, 180)
plim <- c(-88, -50)
grat <- graticule(lons = meridians, lats = parallels, xlim = mlim, ylim = plim, proj = projection(ice))
labs <- graticule_labels(meridians, parallels, xline = -45, yline = -60, proj = projection(ice))
plot(ice, axes = FALSE)
plot(grat, add = TRUE, lty = 3)
text(labs, lab = parse(text= labs$lab), col= c("firebrick", "darkblue")[labs$islon + 1], cex = 0.85)
title(sprintf("Sea ice concentration %s", gsub(".bin", "", basename(tfile))), cex.main = 0.8)
title(sub = projection(ice), cex.sub = 0.6)
```

![](README-unnamed-chunk-3-1.png)

Create the graticule as polygons
--------------------------------

Continuing from the sea ice example, build the graticule grid as actual polygons. Necessarily the xlim/ylim option is ignored since we otherwise have not specified sensibly closed polygonal rings.

``` r
polargrid <- graticule(lons = c(meridians, 180), lats = parallels,  proj = projection(ice), tiles = TRUE)
#> Loading required namespace: rgeos
centroids <- project(coordinates(polargrid), projection(ice), inv = TRUE)
labs <- graticule_labels(meridians, parallels,  proj = projection(ice))
labs <- graticule_labels(as.integer(centroids[,1]), as.integer(centroids[,2]),  proj = projection(ice))
labs <- labs[!duplicated(as.data.frame(labs)), ] ## this needs a fix
cols <- sample(colors(), nrow(polargrid))
op <- par(mar = rep(0, 4))
plot(polargrid, col  = cols, bg = "black")

text(labs[labs$islon, ], lab = parse(text = labs$lab[labs$islon]), col = "black",  cex = .55, pos = 3)
text(labs[!labs$islon, ], lab = parse(text = labs$lab[!labs$islon]), col = "black", cex = .55, pos = 1)
```

![](README-unnamed-chunk-4-1.png)

``` r

par(op)
```

Comparison to tools in **sp** and **rgdal**
-------------------------------------------

The **rgdal** function *llgridlines* will draw a graticule on a map but has a few limitations.

-   no control over the exact meridian and parallel lines to draw
-   the extent of lines is not independent of their perpendicular counterparts
-   relies on a projected object with sufficient verticular density.

Many of these limitations can be worked around, especially by leveraging tools in the **raster** package but it's not particularly elegant.

Above we defined longitude and latitude ranges for an area of interest in Australia. We can plot the projected map and put on a **llgridlines** graticule. (Note that Heard, Macquarie and Lord Howe Islands dictate the bounds of our plot here.)

``` r
plot(pmap)
llgridlines(pmap)
```

![](README-unnamed-chunk-5-1.png)

We cannot easily modify the lines to be only in our local area, since llgridlines over rides ours inputs with the bounding box of the overall object.

``` r
plot(pmap)
lons <- seq(140, 150, length = 5)
lats <- seq(-40, -35, length = 6)
llgridlines(pmap, easts = lons, norths = lats)
```

![](README-unnamed-chunk-6-1.png)

What we can do is crop the object, or create a new one with the overall extents of our region of interest. This is much closer to what I want but still I need to fiddle to get it just right.

``` r
op <- par(xpd = NA)
ex <- as(extent(range(lons), range(lats)), "SpatialPolygons")
projection(ex) <- llproj
pex <- spTransform(ex, CRS(projection(pmap)))
plot(extent(pex), type = "n", axes = FALSE, xlab = "", ylab = "", asp = 1)
plot(pmap, add = TRUE)
llgridlines(pex, easts = lons, norths = lats)
```

![](README-unnamed-chunk-7-1.png)

``` r
par(op)
```

How about the polar example? This is not bad, but the default number of vertices is not sufficient and we don't get a sensible set of meridians.

``` r
plot(ice, axes = FALSE)
##llgridlines(ice)  does not understand a raster
llgridlines(as(ice, "SpatialPoints"))
```

![](README-unnamed-chunk-8-1.png)

Try again, we increase the verticular density, but still I can't get a line at -180/180 and 80S.

``` r
plot(ice, axes = FALSE)
llgridlines(as(ice, "SpatialPoints"), easts = c(-180, -120, -60, 0, 60, 120), norths = c(-80, -70, -60, -50), ndiscr = 50)
```

![](README-unnamed-chunk-9-1.png)

Comparison to **mapGrid** in **oce**
------------------------------------

The **oce** package has a lot of really neat map projection tools, but it works rather differently from the *Spatial* and *raster* tools in R. We need to drive the creation of the plot from the start with `mapPlot`, as it sets up the projection metadata for the current plot and handles that for subsequent plotting additions. There needs to be a wide review of all this stuff to consolidate across many different packages . . .

Here is our map of Victoria.

``` r
library(oce)
## we need to hop the crevasse into another world
pp <- coordinates(as(as(map, "SpatialLines"), "SpatialPoints"))
mapPlot(pp[,1], pp[,2], projection = projection(pmap), longitudelim = xl, latitudelim = yl, type = "n", grid = FALSE)
mapGrid(longitude = lons, latitude = lats)
## and to prove that all is well in the world
plot(pmap, add = TRUE)
```

![](README-unnamed-chunk-10-1.png)

Here is our polar map, this is good I haven't explore **oce** enough yet to do it justice. For bonus points we add **mapTissot**, need to check this out a lot more.

``` r
ipts <- coordinates(spTransform(xyFromCell(ice, sample(ncell(ice), 1000), spatial = TRUE), CRS(llproj)))
mapPlot(ipts[,1], ipts[,2], projection = projection(ice), type = "n", grid = FALSE)

plot(ice, add = TRUE)
mapGrid(10, 15)
mapTissot()
```

![](README-unnamed-chunk-11-1.png)

Notes
-----

It could be said that effort should be shared with the *sp* and *rgdal* projects to improve the functionality for the `llgridlines` and its worker functions `gridlines` and `gridat` in that central place, and I agree with this. But I have an interest in working with graticules more directly as objects, and potentially stored in relational-table approach built on **dplyr**, and so I just found it simpler to start from scratch in this package. Also, there is a lot of this functionality spread around the place in *sp*, *raster*, *maptools*, *fields*, *oce* and many others. It is time for a new review, analogous to the effor that built *sp* in ca. 2002.

### Terminology

I tend to use the same terminology as used within [Manifold System](http://www.manifold.net) *because it's so awesome* and that's where I first learnt about most of these concepts. In my experience not many people use the term *graticule* in this way, so take it from the master himself on page 8 (Snyder, 1987):

> To identify the location of points on the Earth, a graticule or network of longitude and latitude lines has been superimposed on the surface. They are commonly referred to as meridians and parallels, respectively.

References
----------

Snyder, John Parr. Map projections--A working manual. No. 1395. USGPO, 1987.
