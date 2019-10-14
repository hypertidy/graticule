lon <- seq(170, 350, by = 10)
lat <- c(-50, -40)

test_that("no longitude warnings", {
  expect_silent(graticule(lon, lat))

  expect_silent(graticule(lon, lat, tiles = TRUE))

  expect_silent(graticule_labels(lon, lat))
})
