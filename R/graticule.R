#' graticule: graticule lines for maps
#'
#' @docType package
#' @name graticule
NULL
limfun <- function(x, lim, meridian = TRUE, nverts = NULL) {

  mindist <- getOption("graticule.mindist")
  if (is.na(mindist) || is.null(mindist) || !is.numeric(mindist)) {
    mindist <- 5e4
    warning(sprintf("option('graticule.mindist') is malformed, using %fm", mindist))
  }
  if (!meridian) {
    out <- ll_extent(lim, c(x, x), mindist = mindist, nverts = nverts)
  } else {
    out <- ll_extent(c(x, x), lim, mindist = mindist, nverts = nverts)
  }
  out
}

step_fun <- function(x, steps, nd = 60, meridian = TRUE) {
  ind <- 1:2

  if (!meridian) ind <- 2:1
  op <- options(warn = -1)
  on.exit(options(op))
  step_seg <- as.data.frame(utils::head(matrix(steps, nrow = length(steps)+1, ncol = 2), -2))
  lapply(split(step_seg, 1:nrow(step_seg)), function(a) cbind(x = x, y = seq(unlist(a)[1], unlist(a)[2], length = nd))[, ind])
}

buildlines <- function(x) {
  do.call("rbind", lapply(seq_along(x), function(xx) {
    res <- data.frame(x[[xx]], rep(xx, nrow(x[[xx]])))
    names(res) <- c("x", "y", "id")
    res
  }))
}

## from raster findMethods("isLonLat")[["character"]]
# isLonLat <- function (x)
# {
#   res1 <- grep("longlat", as.character(x), fixed = TRUE)
#   res2 <- grep("lonlat", as.character(x), fixed = TRUE)
#   if (length(res1) == 0L && length(res2) == 0L) {
#     return(FALSE)
#   }
#   else {
#     return(TRUE)
#   }
# }

lonlatp4 <- function() {
  "+proj=longlat +datum=WGS84"
}

#' Create graticule lines.
#'
#' Specify the creation of lines along meridians by specifying their placement
#' at particular \code{lons} (longitudes) and \code{lats} (latitudes) and their extents
#' with \code{xlim} (extent of parallel line in longitude) and \code{ylim} (extent of meridional line in latitude).
#'
#' Provide a valid PROJ.4 string to return the graticule lines in this projection. If this is not specified the graticule
#' lines are returned in their original longlat / WGS84.
#' All segments are discretized as _rhumb_lines_ at `getOption("graticule.mindist")` metres, which
#' defaults to `5e4`.
#' The arguments \code{xlim}, \code{ylim} and \code{nverts} are ignored if \code{tiles} is \code{TRUE}.
#' @param lons longitudes for meridional lines
#' @param lats latitudes for parallel lines
#' @param nverts number of discrete vertices for each segment
#' @param xlim maximum range of parallel lines
#' @param ylim maximum range of meridional lines
#' @param proj optional proj.4 string for output object
#' @param tiles if \code{TRUE} return polygons as output
#' @return SpatialLines or SpatialPolygons object
#' @export
#' @importFrom reproj reproj_xy
#' @importFrom raster isLonLat raster extent values<- ncell res
#' @importFrom sp SpatialLinesDataFrame Line Lines SpatialLines CRS
#' @examples
#' graticule()
graticule <- function(lons, lats, nverts = NULL, xlim, ylim, proj = NULL, tiles = FALSE) {
  if (is.null(proj)) proj <- lonlatp4()
  proj <- as.character(proj)  ## in case we are given CRS
  trans <- FALSE
  if (tiles) {
    if (!missing(xlim)) {
      warning("xlim is ignored if 'tiles = TRUE'")
    }
    if (!missing(ylim)) {
      warning("ylim is ignored if 'tiles = TRUE'")
    }

  }
  if (!raster::isLonLat(proj)) trans <- TRUE
  if (missing(lons)) {
    #usr <- par("usr")
    #if (all(usr == c(0, 1, 0, 1))) {
    lons <- seq(-180, 180, by = 15)
  }
  if (missing(lats)) {
    lats <- seq(-90, 90, by = 10)
  }

  if (tiles) {
    pp <- graticule_tiles(lons, lats, proj = proj)
    return(pp)
  }
  if (missing(xlim)) xlim <- range(lons)
  if (missing(ylim)) ylim <- range(lats)
  xline <- lapply(lons, limfun, lim = ylim, meridian = TRUE, nverts = nverts)
  yline <- lapply(lats, limfun, lim = xlim, meridian = FALSE, nverts = nverts)
  xs <- buildlines(xline)
  ys <- buildlines(yline)
  ys$id <- ys$id + max(xs$id)
  xs$type <- "meridian"
  ys$type <- "parallel"
  d <- rbind(xs, ys)
  d0 <- split(d, d$id)
  l <- vector("list", length(d0))
  for (i in seq_along(d0)) {
    m1 <- as.matrix(d0[[i]][, c("x", "y")])
    if (trans) {
      m1 <- reproj::reproj_xy(m1, proj, source = "+proj=longlat +datum=WGS84")
    } else {
      proj <- "OGC:CRS84"
    }
    l1 <- sp::Lines(list(sp::Line(m1)), ID = as.character(i))
    l[[i]] <- l1
  }
  l <- sp::SpatialLinesDataFrame(sp::SpatialLines(l, proj4string = sp::CRS(proj)),
                                 data.frame(ID = as.character(seq_along(l))))
  l

}

#' Create graticule labels.
#'
#' Returns a set of points with labels, for plotting in conjuction with \code{\link{graticule}}.
#'
#' SpatialPoints are returned in the projection of \code{proj} if given, or longlat / WGS84.
#' @param lons longitudes for meridional labels
#' @param lats latitudes for parallel labels
#' @param xline meridian/s for placement of parallel labels
#' @param yline parallel/s for placement of meridian labels
#' @param proj optional proj.4 string for output object
#' @export
#' @importFrom sp degreeLabelsEW degreeLabelsNS coordinates<- proj4string<-
#' @return SpatialPoints object with labels for downstream use
#' @examples
#' xx <- c(100, 120, 160, 180)
#' yy <- c(-80,-70,-60, -50,-45, -30)
#' prj <- "+proj=lcc +lon_0=150 +lat_0=-80 +lat_1=-85 +lat_2=-75 +ellps=WGS84"
#' plot(graticule(lons = xx, lats = yy,  proj = prj))
#' labs <- graticule_labels(lons = xx, lats = yy, xline = 100, yline = -80,  proj = prj)
#' op <- par(xpd = NA)
#' text(labs, lab = parse(text = labs$lab), pos = c(2, 1)[labs$islon + 1], adj = 1.2)
#' par(op)
graticule_labels <- function(lons, lats, xline, yline, proj = NULL) {
  if (is.null(proj)) proj <- lonlatp4()
  proj <- as.character(proj)  ## in case we are given CRS
  trans <- FALSE
  if (!raster::isLonLat(proj)) trans <- TRUE
  if (missing(lons)) {
    #usr <- par("usr")
    #if (all(usr == c(0, 1, 0, 1))) {
    lons <- seq(-180, 180, by = 15)
  }
  if (missing(lats)) {
    lats <- seq(-90, 90, by = 10)
  }
  if (missing(xline)) xline <- lons
  if (missing(yline)) yline <- lats

  lonlabs <- expand.grid(x = lons, y = yline)
  lonlabs$lab <-  degreeLabelsEW(lonlabs$x)
  lonlabs$islon <- TRUE
  latlabs <- expand.grid(x = xline, y = lats)
  latlabs$lab <- degreeLabelsNS(latlabs$y)
  latlabs$islon <- FALSE
  l <- rbind(lonlabs, latlabs)
  p4 <- lonlatp4()
  if (trans) {
    l[1:2] <- reproj::reproj_xy(l[1:2], proj, source = p4)
    p4 <- proj
  }

  coordinates(l) <- 1:2


  proj4string(l) <- CRS(p4)

  l
}
