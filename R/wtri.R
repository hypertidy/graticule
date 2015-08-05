# library(maptools)
# data(wrld_simpl)
# library(gris)
# library(RTriangle)
# library(rgdal)
# 
# library(rworldmap)
# library(rworldxtra)
# data(countriesHigh)
# 
# g <- gris(disaggregate(countriesHigh))
# 
# ptrans <- function(obj) {
#   x <- obj$v
#   mp <- x %>% summarize(x = mean(x), y = mean(y))
#   proj <- sprintf("+proj=laea +ellps=WGS84 +lon_0=%f +lat_0=%f", mp$x[1], mp$y[1])
#   m <- project(as.matrix(x[, c('x', 'y')]), proj)
#   x$x <- m[,1]
#   x$y <- m[,2]
#   obj$v <- x
#   obj
# }
# 
# for (i in seq(nrow(g$o))) {
#   if (nrow(g[i, ]$v) > 50) {
#     ## visit every polygon and triangulate in a local LAEA projection
#     op <- par(mfrow = c(2, 1))
#     tr <- triangulate(mkpslg(g[i,])); plot(tr, asp = 1); title(g$o$NAME[i]); degAxis(1);degAxis(2)
#     tr <- triangulate(mkpslg(ptrans(g[i,]))); plot(tr, asp = 1); axis(1);axis(2)
#     par(op)
#     scan("", 1)
#   }
# }




