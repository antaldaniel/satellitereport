## code to prepare `geodata_sf` dataset goes here

load(file.path('data-raw', "geodata_sf.rda"))
usethis::use_data(geodata_nuts0, overwrite=TRUE, internal=TRUE)
usethis::use_data(geodata_nuts1, overwrite=TRUE, internal=TRUE)
usethis::use_data(geodata_nuts2, overwrite=TRUE, internal=TRUE)
usethis::use_data(geodata_nuts3, overwrite=TRUE, internal=TRUE)
