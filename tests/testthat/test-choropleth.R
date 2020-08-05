library(ggplot2)
library(dplyr)
library(testthat)

library(satellitereport)
n = 5
geo_var = 'geo'
values_var = 'values'
type = 'discrete'
show_all_missing = TRUE
unit_text = NULL
color_palette = NULL
na_color = 'grey93'
drop_levels = FALSE
reverse_scale = FALSE
style = 'pretty'
print_style = 'min-max'
iceland = "if_present"
dat = nuts_with_missings
dat$values[c(100,200,300,400,500,600,700,800)] <- NA_real_

all_eu_geo_codes <- eurostat::regional_changes_2016 %>%
  dplyr::distinct ( code16 ) %>%
  filter(!is.na(code16)) %>%
  dplyr::pull(code16)

#all_geo_codes <- geodata_nuts2$id


test_intervals <- data.frame (
  geo = all_eu_geo_codes,
  values = rnorm(length(all_eu_geo_codes), mean = 50, sd = 15),
  row.names = NULL
)

test_with_missings <- data.frame(
  geo = all_eu_geo_codes,
  values = ifelse(all_eu_geo_codes%in%all_eu_geo_codes,
                  rnorm(length(all_eu_geo_codes ), mean=70, sd=4),
                  NA_real_),
  row.names=NULL,
  stringsAsFactors = FALSE
)

create_choropleth ( dat = test_with_missings,
                    n=5, style ='kmeans')

test_with_categories <- data.frame(
  geo = all_eu_geo_codes,
  values = round(runif(n = length(all_eu_geo_codes), min = 1, max =5),0),
  row.names=NULL,
  stringsAsFactors = FALSE
)

test_with_categories$cats <- ifelse(
  test_with_categories$values == 1,
  "missing",
  as.character(test_with_categories$values)
)

cat_palette <- c( '#4EC0E4', 'grey90', '#00843A', '#3EA135', '#DB001C')
names(cat_palette) <- c("2", "missing", "3", "4", "5")

#problem
#create_choropleth ( dat = test_with_categories,
#                    type = 'discrete',
#                    values_var = "cats",
#                    color_palette = cat_palette )


test_with_num_categories <- data.frame(
  geo = all_eu_geo_codes,
  values = round(runif(n = length(all_eu_geo_codes), min = 1, max =5),0),
  row.names=NULL,
  stringsAsFactors = FALSE
)

test_with_num_categories$values <- ifelse(
  test_with_categories$values == 1,
  NA_real_,
  as.numeric(test_with_num_categories$values)
)

create_choropleth ( dat = test_with_num_categories,
                    type = 'discrete',
                    values_var = "values",
                    n = 4,
                    color_palette = cat_palette[2:5],
                    na_color = 'grey93')

testthat::test_that("exception handling works", {
  expect_error(create_choropleth ( dat = test_intervals,
                                   level=4, n=5, style ='kmeans'))
})


