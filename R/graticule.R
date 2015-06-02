#' graticule: graticule lines for maps
#'
#' @docType package
#' @name graticule
NULL
limfun <- function(x, lim, nd = 60, meridian = TRUE) {
  ind <- 1:2
  if (!meridian) ind <- 2:1
  cbind(x = x, y = seq(lim[1], lim[2], length = nd))[, ind]
}

buildlines <- function(x) {
  do.call("rbind", lapply(seq_along(x), function(xx) {
    res <- data.frame(x[[xx]], rep(xx, nrow(x[[xx]])))
    names(res) <- c("x", "y", "id")
    res
  }))
}

## from raster findMethods("isLonLat")[["character"]]
isLonLat <- function (x)
{
  res1 <- grep("longlat", as.character(x), fixed = TRUE)
  res2 <- grep("lonlat", as.character(x), fixed = TRUE)
  if (length(res1) == 0L && length(res2) == 0L) {
    return(FALSE)
  }
  else {
    return(TRUE)
  }
}

lonlatp4 <- function() {
  "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"
}
#' Create a graticule.
#'
#' @param easts longitudes for meridional lines
#' @param norths latitudes for parallel lines
#' @param ndiscr number of discrete vertices for each segment
#' @param xlim maximum range of parallel lines
#' @param ylim maximum range of meridional lines
#' @export
#'
#' @examples \dontrun{
#' library(rgdal)
#' x <- as.matrix(expand.grid(x = seq(100, 240, by = 15), y = seq(-85, -30, by = 15)))
#' prj <- "+proj=laea +lon_0=180 +lat_0=-70"
#' px <- project(x, prj)
#' g <- graticule(unique(x[,1]), unique(x[,2]))
#' pg <- spTransform(g, CRS(prj))
#' plot(px, type = "n")
#' plot(pg, add = TRUE)
#'
#' g2 <- graticule(unique(x[,1]), unique(x[,2]), ylim = c(-90, 0), xlim = c(110, 250))
#' pg2 <- spTransform(g2, CRS(prj))
#' plot(px, type = "n")
#' plot(pg2, add = TRUE)
#'
#' }
graticule <- function(easts, norths, ndiscr = 60, xlim, ylim, proj = NULL) {
  if (is.null(proj)) proj <- lonlatp4()
  proj <- as.character(proj)  ## in case we are given CRS
  trans <- FALSE
  if (!isLonLat(proj)) trans <- TRUE
  if (missing(easts)) {
    #usr <- par("usr")
    #if (all(usr == c(0, 1, 0, 1))) {
      easts <- seq(-180, 180, by = 15)
  }
  if (missing(norths)) {
      norths <- seq(-90, 90, by = 10)
  }

  if (missing(xlim)) xlim <- range(easts)
  if (missing(ylim)) ylim <- range(norths)
  xlines <- lapply(easts, limfun, lim = ylim, meridian = TRUE)
  ylines <- lapply(norths, limfun, lim = xlim, meridian = FALSE)
  xs <- buildlines(xlines)
  ys <- buildlines(ylines)
  ys$id <- ys$id + max(xs$id)
  xs$type <- "meridian"
  ys$type <- "parallel"
  d <- rbind(xs, ys)
#  coordinates(d) <- ~x+y
 # proj4string(d) <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0")
  d0 <- split(d, d$id)
  l <- vector("list", length(d0))
  for (i in seq_along(d0)) l[[i]] <- Lines(list(Line(as.matrix(d0[[i]][, c("x", "y")]))), ID = as.character(i))
  l <- SpatialLinesDataFrame(SpatialLines(l, proj4string = CRS(lonlatp4())),
                        data.frame(ID = as.character(seq_along(l))))
  if (trans) l <- rgdal:::spTransform.SpatialLinesDataFrame(l, CRS(proj))
  l
  #d0$type <- c(rep("meridian", length(unique(xs$id))), rep("parallel", length(unique(ys$id))))

}

#' Create graticule labels.
#'
#' @param easts longitudes for meridional labels
#' @param norths latitudes for parallel labels
#' @param xlines meridian/s for placement of parallel labels
#' @param ylines parallel/s for placement of meridian labels
#' @export
#' @importFrom sp degreeLabelsEW degreeLabelsNS coordinates<- proj4string
#' @examples
#' plot(graticule(easts = c(100, 120, 160, 180), norths = c(-80,-70,-60, -50,-45, -30),  proj = "+proj=lcc +lon_0=150 +lat_0=-80"))
#' op <- par(xpd = NA); text(labs, lab = parse(text = labs$lab), pos = c(2, 1)[labs$islon + 1], adj = 1.2);par(op)
graticule_labels <- function(easts, norths, xlines, ylines, proj = NULL) {
  if (is.null(proj)) proj <- lonlatp4()
  proj <- as.character(proj)  ## in case we are given CRS
  trans <- FALSE
  if (!raster:::isLonLat(proj)) trans <- TRUE
  if (missing(easts)) {
    #usr <- par("usr")
    #if (all(usr == c(0, 1, 0, 1))) {
    easts <- seq(-180, 180, by = 15)
  }
  if (missing(norths)) {
    norths <- seq(-90, 90, by = 10)
  }
  if (missing(xlines)) xlines <- easts
  if (missing(ylines)) ylines <- norths

  lonlabs <- expand.grid(x = easts, y = ylines)
  lonlabs$lab <-  degreeLabelsEW(lonlabs$x)
  lonlabs$islon <- TRUE
  latlabs <- expand.grid(x = xlines, y = norths)
  latlabs$lab <- degreeLabelsNS(latlabs$y)
  latlabs$islon <- FALSE
  l <- rbind(lonlabs, latlabs)
  coordinates(l) <- 1:2
  proj4string(l) <- CRS(lonlatp4())
  if (trans) {
    l <- rgdal:::spTransform.SpatialPointsDataFrame(l, CRS(proj))
  }
  l
}
