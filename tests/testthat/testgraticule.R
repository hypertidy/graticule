context("Basic function")

test_that("graticule creation is successful", {
  g <- graticule(seq(100, 240, by = 15), seq(-85, -30, by = 15))
  expect_s4_class(g, "SpatVector")
  expect_equal(terra::geomtype(g), "lines")

  g2 <- graticule(seq(100, 240, by = 15), seq(-85, -30, by = 15), nverts = 20)
  expect_s4_class(g2, "SpatVector")
  expect_equal(terra::geomtype(g2), "lines")

  g3 <- graticule(seq(100, 240, by = 15), seq(-85, -30, by = 15), nverts = 100, xlim = c(-180, 180), ylim = c(-60, -30))
  expect_s4_class(g3, "SpatVector")
  expect_equal(terra::geomtype(g3), "lines")
})

test_that("labels work", {
  labs <- graticule_labels(seq(100, 240, by = 15), seq(-85, -30, by = 15))
  expect_s4_class(labs, "SpatVector")
  expect_equal(terra::geomtype(labs), "points")
})

