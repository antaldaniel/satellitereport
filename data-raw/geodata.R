## code to prepare `geodata_sf` dataset goes here

load(file.path('data-raw', "geodata_sf.rda"))
usethis::use_data(geodata_nuts0,
                  geodata_nuts1,
                  geodata_nuts2,
                  geodata_nuts3, overwrite=TRUE, internal=TRUE)
