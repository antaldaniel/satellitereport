geo_var = 'geo'
values_var = 'values'
type = 'discrete'
unit_text = NULL
color_palette = NULL
na_color = 'grey93'
reverse_scale = FALSE
style = 'pretty'
print_style = 'min-max'
iceland = "if_present"
level = 2

all_eu_geo_codes <- eurostat::regional_changes_2016 %>%
  dplyr::distinct ( code16 ) %>%
  dplyr::select(code16) %>%
  filter (!is.na(code16)) %>%
  unlist()

all_geo_codes <-geodata_nuts2$id


test_intervals <- data.frame (
  geo = all_eu_geo_codes,
  values = rnorm(length(all_eu_geo_codes ), mean = 50, sd = 15),
  row.names = NULL
)

test_with_missings <- data.frame(
  geo = all_geo_codes,
  values = ifelse(all_geo_codes%in%all_eu_geo_codes,
                  rnorm(length(all_geo_codes ), mean=70, sd=4),
                  NA_real_),
  row.names=NULL,
  stringsAsFactors = FALSE
)



create_choropleth ( dat = test_with_missings,
                    level=2, n=5, style ='kmeans')

test_with_categories <- data.frame(
  geo = all_geo_codes,
  values = round(runif(n = length(all_geo_codes), min = 1, max =5),0),
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


create_choropleth ( dat = test_with_categories,
                    level = 2,
                    type = 'discrete',
                    values_var = "cats",
                    color_palette = cat_palette )


test_with_num_categories <- data.frame(
  geo = all_geo_codes,
  values = round(runif(n = length(all_geo_codes), min = 1, max =5),0),
  row.names=NULL,
  stringsAsFactors = FALSE
)

test_with_num_categories$values <- ifelse(
  test_with_categories$values == 1,
  NA_real_,
  as.numeric(test_with_num_categories$values)
)

create_choropleth ( dat = test_with_num_categories,
                    level = 2,
                    type = 'discrete',
                    values_var = "values",
                    n = 4,
                    color_palette = cat_palette[2:5],
                    na_color = 'grey93')

test_that("exception handling works", {
  expect_error(create_choropleth ( dat = test_intervals,
                                   level=4, n=5, style ='kmeans'))
})
