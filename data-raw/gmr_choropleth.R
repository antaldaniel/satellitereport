library(regions)
library(dplyr)
library(tidyr)
library(satellitereport)
dir("../regions/data-raw")

dir ('../../_data/shapefile')
'ref-nuts-2010-60m.shp'

data ("google_nuts_matchtable")

gmr <- readr::read_csv("../regions/data-raw/Global_Mobility_Report.csv")

gmr_france <- gmr %>%
  filter ( country_region_code == "FR")

#View ( google_nuts_matchtable )
#View (gmr_france )
names ( gmr )
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

names (google_nuts_matchtable)

gmr_nuts <- europe %>%
  left_join ( google_nuts_matchtable %>%
                select ( all_of(c("country_code",
                                  "google_region_name",
                                  "typology",
                                  "code_2016"))),
              by =c("country_code", "google_region_name"))

gmr_nuts_france <- filter ( gmr_nuts, country_code == "FR")
gmr_nuts_swiss <- filter ( gmr_nuts, country_code == "CH")
gmr_nuts_estonia <- filter ( gmr_nuts, country_code == "EE")


example <-  gmr_nuts %>%
  filter ( date == "2020-04-26") %>%
  filter ( location_type == "workplaces") %>%
  mutate ( code_2016 = case_when(
    country_code == "IS" & is.na(google_region_name) ~ "IS",
    country_code == "EE" & is.na(google_region_name) ~ "EE",
    country_code == "LV" & is.na(google_region_name) ~ "LV",
    country_code == "MT" & is.na(google_region_name) ~ "MT",
    country_code == "LU" & is.na(google_region_name) ~ "LU",
    country_code == "NO" & is.na(google_region_name) ~ "NO",
    country_code == "SI" & is.na(google_region_name) ~ "SI",
    TRUE ~ code_2016 )) %>%
  filter ( ! code_2016 %in% c("LV00", "LV006") ) %>%
  filter ( !is.na(code_2016) )

dat <- example %>%
  rename ( geo  = code_2016   ) %>%
  mutate ( method = "actual") %>%
  regions::impute_down_nuts( )

values_var = "values"
n = 7
color_palette = sr_palette()[
  c("brown", "red", "darkgreen", "darkblue",
    "orange", "blue", "yellow", "lightgreen",
    "lightblue")]
geo_var = 'geo'
na_color = "grey93"
type = 'discrete'
show_all_missing = TRUE
unit_text = NULL
color_palette = NULL
na_color = 'grey90'
drop_levels = FALSE
reverse_scale = FALSE
style = 'pretty'
print_style = 'min-max'
iceland = "if_present"
geo_var = 'geo'

library(ggplot2)
create_choropleth( dat = dat,
                   values_var = "values",
                   n = 8,
                   color_palette = sr_palette()[
                     c("brown", "red", "darkgreen", "darkblue",
                       "orange", "blue", "yellow",  "lightblue"
                      )],
                   na_color = "grey93") +
  theme ( plot.caption = element_text(hjust = 1),
          plot.title = element_text(hjust = 0.5),
          plot.subtitle = element_text(hjust = 0.5)) +
  labs ( title = "Abstention From Workplaces",
         subtitle = "26 April 2020",
         caption = "data: Google Mobility Report
         \ua9 2020, Daniel Antal, Istvan Zsoldos;
         code: regions.danielantal.eu")

ggsave ( filename = 'not_included/google_mobility_report.jpg',
         units = 'cm', width = 15, height = 10)
