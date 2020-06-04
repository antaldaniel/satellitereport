#' The sf File Of NUTS0 (Country) Boundaries in Europe
#'
#' @format A data frame with 37 observations and eight variables:
#' \describe{
#'   \item{id}{ISO 3166 country codes, except for Greece (EL) and the
#'   United Kingdom (UK)}
#'   \item{CNTR_CODE}{country codes, \code{UK} for the United Kingdom and
#'   \code{EL} for Greece.}
#'   \item{NUTS_NAME}{The official names of the statistical territories,
#'   in this case, countries.}
#'   \item{FID}{FID}
#'   \item{NUTS_ID}{The NUTS0 codes}
#'   \item{LEVL_CODE}{The NUTS level code, in this case 0}
#'   \item{geometry}{A sfc_MULTIPOLYGON of the European country boundaries}
#'   \item{geo}{NUTS2016/NUTS2013/NUTS2010 NUTS0 level regional codes}
#'   }
#' @source \url{https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units/nuts}
"geodata_nuts0"
