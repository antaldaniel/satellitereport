library(regions)
library(dplyr)
library(tidyr)
library(satellitereport)
dir("../regions/data-raw")


data ("google_nuts_matchtable")

gmr <- readr::read_csv("../regions/data-raw/Global_Mobility_Report.csv")

gmr_france <- gmr %>%
  filter ( country_region_code == "FR")

europe <- gmr %>%
  mutate ( sub_region_1 = ifelse (nchar(sub_region_1)<2,
                                  country_region,
                                  sub_region_1)) %>%
  purrr::set_names (., c("country_code", "country_region",
                        "google_region_name", "sub_region_2",
                        "date",
                        "retail", "grocery", "parks",
                        "transit",
                        "workplaces", "residential"
                       )) %>%
  filter ( country_code %in% google_nuts_matchtable$country_code ) %>%
  select ( -all_of(c("sub_region_2", "country_region")) ) %>%
  pivot_longer ( data =.,
                 cols = c("retail", "grocery", "parks",
                          "transit",
                          "workplaces", "residential"),
                 names_to = "location_type",
                 values_to = "values")


gmr_nuts <- europe %>%
  left_join ( google_nuts_matchtable %>%
                select ( all_of(c("country_code",
                                  "google_region_name",
                                  "typology",
                                  "code_2016"))),
              by =c("country_code", "google_region_name"))

gmr_nuts_france <- filter ( gmr_nuts, country_code == "FR")

example <-  gmr_nuts %>%
  filter ( date == "2020-04-26") %>%
  filter ( location_type == "workplaces") %>%
  filter ( !is.na(code_2016))


create_choropleth( dat = example,
                   geo_var = "code_2016",
                   values_var = "values")

satellitereport:::check_dat_input(dat, "code_2016", "values")

