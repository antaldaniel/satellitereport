#' The sf File Of NUTS2 (Region) Boundaries in Europe
#'
#' @format A data frame with 332 observations of eight variables:
#' \describe{
#'   \item{id}{NUTS1 codes}
#'   \item{CNTR_CODE}{country codes, \code{UK} for the United Kingdom and
#'   \code{EL} for Greece.}
#'   \item{NUTS_NAME}{The official names of the statistical territories,
#'   in this case, larger regions or provinces.}
#'   \item{FID}{FID regional codes}
#'   \item{NUTS_ID}{The NUTS2 codes}
#'   \item{LEVL_CODE}{The NUTS level code, in this case 2}
#'   \item{geometry}{A sfc_MULTIPOLYGON of the European country boundaries}
#'   \item{geo}{NUTS2016 NUTS2 level regional codes}
#'   }
#' @source \url{https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units/nuts}
"geodata_nuts2"

geodata_nuts0$LEVL_CODE
