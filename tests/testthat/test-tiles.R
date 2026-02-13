test_that("tiles is sensible ", {
  g <- graticule::graticule(seq(-180, 180, by = 15), lat = c(-45, -43), tiles = TRUE)
  expect_true(nrow(g) == 24)
  expect_s4_class(g, "SpatVector")
  expect_equal(terra::geomtype(g), "polygons")
  gext <- terra::ext(g)
  expect_equal(unname(as.vector(gext)), c(-180, 180, -45, -43), tolerance = 0.01)

  expect_error(graticule(89, tiles = TRUE))
  expect_error(graticule(c(10, 11), 5, tiles = TRUE))
})
