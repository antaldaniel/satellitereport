require(sf)

europe_shapefile <- readRDS(file.path("data-raw", "europe_shapefile.rds"))
geodata_europe_2016 <- sf::st_as_sf (europe_shapefile)
geodata_europe_2016 <- geodata_europe_2016[, -c("SHAPE_AREA", "SHAPE_LEN")]

usethis::use_data ( geodata_europe_2016, internal = FALSE, overwrite = TRUE)


#' \describe{
#'   \item{NUTS_ID}{The NUTS geocodes}
#'   \item{STAT_LEVL_}{The NUTS level code, 0,1,2 or 3.}
#'   \item{SHAPE_AREA_}{The NUTS level code, 0,1,2 or 3.}
#'   \item{SHAPE_LEN_}{The NUTS level code, 0,1,2 or 3.}
#'   \item{geometry}{A sfc_MULTIPOLYGON of the European country boundaries}
#'   }
