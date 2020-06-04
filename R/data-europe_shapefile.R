#' The sf File Of NUTS Boundaries in Europe (NUTS2016)
#'
#' @format A data.frame with 1951 observations of 2 variables extended with
#' a simple feature list column to class of sf:
#' \describe{
#'   \item{NUTS_ID}{The NUTS geocodes}
#'   \item{STAT_LEVL_}{The NUTS level code, 0,1,2 or 3.}
#'   \item{geometry}{A sfc_MULTIPOLYGON of the European country boundaries}
#'   }
#' @source \url{https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units/nuts}
"geodata_europe_2016"
