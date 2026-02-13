lon <- seq(170, 350, by = 10)
lat <- c(-50, -40)

test_that("no longitude warnings", {
  g <- graticule(lon, lat)
  expect_s4_class(g, "SpatVector")
  expect_equal(terra::geomtype(g), "lines")

  gt <- graticule(lon, lat, tiles = TRUE)
  expect_s4_class(gt, "SpatVector")
  expect_equal(terra::geomtype(gt), "polygons")

  gl <- graticule_labels(lon, lat)
  expect_s4_class(gl, "SpatVector")
  expect_equal(terra::geomtype(gl), "points")
})
