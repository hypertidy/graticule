
limfun <- function(x, lim, nd = 60, meridian = TRUE) {
  ind <- 1:2
  if (!meridian) ind <- 2:1
  cbind(x, seq(lim[1], lim[2], length = nd))[, ind]
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
graticule <- function(easts, norths, ndiscr = 60, xlim, ylim) {
  if (missing(xlim)) xlim <- range(easts)
  if (missing(ylim)) ylim <- range(norths)
  xlines <- lapply(easts, limfun, lim = ylim, meridian = TRUE)
  ylines <- lapply(norths, limfun, lim = xlim, meridian = FALSE)
  xs <- do.call("rbind", lapply(seq_along(xlines), function(xx) {
    res <- data.frame(xlines[[xx]], rep(xx, nrow(xlines[[xx]])), Sys.time() + seq( nrow(xlines[[xx]])))
    names(res) <- c("x", "y", "id", "time")
    res
  }))
  ys <- do.call("rbind", lapply(seq_along(ylines), function(xx) {
    res <- data.frame(ylines[[xx]], rep(xx, nrow(ylines[[xx]])) + max(xs$id), Sys.time() + seq( nrow(ylines[[xx]])))
    names(res) <- c("x", "y", "id", "time")
    res
  }))
  xs$type <- "meridian"
  ys$type <- "parallel"
  d <- rbind(xs, ys)
  coordinates(d) <- ~x+y
  proj4string(d) <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0")
  d0 <- as(trip(d, c("time", "id")), "SpatialLinesDataFrame")
  d0$type <- c(rep("meridian", length(unique(xs$id))), rep("parallel", length(unique(ys$id))))
  d0
}

#
# mikegl <- function(easts, norths, ndiscr = 50, crs = NULL, llcrs = "+proj=longlat +datum=WGS84 +ellps=WGS84", side = "WS") {
#   {
#     xlim <- range(easts)
#     ylim <- range(norths)
#     eastlist <- vector(mode = "list", length = length(easts))
#     for (i in 1:length(easts)) eastlist[[i]] <- Line(cbind(rep(easts[i],  ndiscr), seq(ylim[1], ylim[2], length.out = ndiscr)))
#     northlist <- vector(mode = "list", length = length(norths))
#     for (i in 1:length(norths)) northlist[[i]] <- Line(cbind(seq(xlim[1], xlim[2], length.out = ndiscr), rep(norths[i], ndiscr)))
#     grd_x <- SpatialLines(list(Lines(northlist, "NS"), Lines(eastlist,  "EW")), CRS(llcrs))
#     grd_x <- spTransform(grd_x, CRS(crs))
#
#     return(grd_x)
#   }
# }
#
#
#
# function (obj, easts, norths, ndiscr = 50, lty = 2, offset = 0.5,
#           side = "WS", llcrs = "+proj=longlat +datum=WGS84", plotLines = TRUE,
#           plotLabels = TRUE, ...)
# {
#   obj_ll <- spTransform(obj, CRS(llcrs))
#   if (missing(easts))
#     easts = pretty(bbox(obj_ll)[1, ])
#   if (missing(norths))
#     norths = pretty(bbox(obj_ll)[2, ])
#   grd <- gridlines(obj_ll, easts = easts, norths = norths,
#                    ndiscr = ndiscr)
#   grd_x <- spTransform(grd, CRS(proj4string(obj)))
#   return(grd_x)
#   if (plotLines)
#     plot(grd_x, add = TRUE, lty = lty, ...)
#   if (packageVersion("sp") >= "0.9.84") {
#     grdat_ll <- gridat(obj_ll, easts = easts, norths = norths,
#                        side = side, offset = offset)
#   }
#   else {
#     grdat_ll <- gridat(obj_ll, easts = easts, norths = norths,
#                        offset = offset)
#   }
#   grdat_x <- spTransform(grdat_ll, CRS(proj4string(obj)))
#   if (plotLabels)
#     text(coordinates(grdat_x), labels = parse(text = grdat_x$labels),
#          pos = grdat_x$pos, offset = grdat_x$offset, ...)
# }
