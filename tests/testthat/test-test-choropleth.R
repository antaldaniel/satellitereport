

all_geo_codes <- eurostat::regional_changes_2016 %>%
  dplyr::distinct ( code16 ) %>%
  dplyr::select(code16) %>%
  filter (!is.na(code16)) %>%
  unlist()


test_intervals <- data.frame (
  geo = all_geo_codes,
  values = rnorm(length(all_geo_codes ), mean = 50, sd = 15),
  row.names = NULL
)

create_choropleth ( dat = test_intervals,
                    level=2, n=5, style ='kmeans')

test_that("exception handling works", {
  expect_error(create_choropleth ( dat = test_intervals,
                                   level=4, n=5, style ='kmeans'))
})
