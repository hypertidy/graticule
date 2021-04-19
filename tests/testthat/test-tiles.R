test_that("tiles is sensible ", {
  g <- graticule::graticule(seq(-180, 180, by = 15), lat = c(-45, -43), tiles = TRUE)
  expect_true(nrow(g) == 24)
  expect_equivalent(extent(g), extent(-180, 180, -45, -43))

  expect_error(graticule(89, tiles = TRUE))
  expect_error(graticule(c(10, 11), 5, tiles = TRUE))
})
