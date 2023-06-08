lon <- seq(170, 350, by = 10)
lat <- c(-50, -40)

test_that("no longitude warnings", {
  expect_s4_class(graticule(lon, lat), "SpatialLinesDataFrame")

  expect_s4_class(graticule(lon, lat, tiles = TRUE), "SpatialPolygonsDataFrame")

  expect_s4_class(graticule_labels(lon, lat), "SpatialPointsDataFrame")
})
