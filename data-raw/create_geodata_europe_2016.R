require(sf)
source('not_included/local_path.R')
geodata_europe_2016 <- sf::st_read(nuts_path)
usethis::use_data ( geodata_europe_2016,
                    internal = FALSE, overwrite = TRUE)
#' \describe{
#'   \item{NUTS_ID}{The NUTS geocodes}
#'   \item{STAT_LEVL_}{The NUTS level code, 0,1,2 or 3.}
#'   \item{SHAPE_AREA_}{The NUTS level code, 0,1,2 or 3.}
#'   \item{SHAPE_LEN_}{The NUTS level code, 0,1,2 or 3.}
#'   \item{geometry}{A sfc_MULTIPOLYGON of the European country boundaries}
#'   }
