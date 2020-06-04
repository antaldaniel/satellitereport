library(dplyr)
library(satellitereport)

eb <- readRDS("data-raw/eurobarometer_79_2.rds")
unique(eb$indicator)
dat <- eb  %>%
  filter ( indicator == "erobarometer_79_2_is_visit_public_library")

names ( dat )
this <- eb  %>%
  filter ( indicator == "erobarometer_79_2_is_visit_public_library")

create_choropleth ( dat = this, level = 2,
                    values_var = 'values',
                    geo_var = 'code16',
                    unit_text = "unit",
                    color_palette = as.character(sr_palette()),
                    type = 'discrete', n=6,
                    style = 'quantile', drop_levels = TRUE)
