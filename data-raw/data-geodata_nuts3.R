#' The sf File Of NUTS3 (Small Region) Boundaries in Europe
#'
#' @format A data frame with 1522 observations of eight variables:
#' \describe{
#'   \item{id}{NUTS1 codes}
#'   \item{CNTR_CODE}{country codes, \code{UK} for the United Kingdom and
#'   \code{EL} for Greece.}
#'   \item{NUTS_NAME}{The official names of the statistical territories,
#'   in this case, larger regions or provinces.}
#'   \item{FID}{FID regional codes}
#'   \item{NUTS_ID}{The NUTS3 codes}
#'   \item{LEVL_CODE}{The NUTS level code, in this case 3}
#'   \item{geometry}{A sfc_MULTIPOLYGON of the European country boundaries}
#'   \item{geo}{NUTS2016 NUTS3 level regional codes}
#'   }
#' @source \url{https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units/nuts}
"geodata_nuts3"
