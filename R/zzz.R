
.onLoad <- function(libname, pkgname) {
  op <- options()
  op.graticule <- list(
    graticule.mindist = 5e4
  )
  toset <- !(names(op.graticule) %in% names(op))
  if (any(toset)) options(op.graticule[toset])

  invisible()
}
