#' Satellite Report Utilities
#'
#' This package helps cooperation with Satellite Report. \url{http://satellitereport.com}
#'
#' @section utility functions:
#' \code{\link{indicator_categories}} is a wrapper around
#' \code{\link[classInt]{classIntervals}} and
#' creates printable univariate class intervals from numeric values.
#'
#' @section palette constructor functions:
#' These functions return a named character vector. The values are
#' hex codes of the colors, the names are the European country
#' codes.
#' \code{\link{create_color_palette}} creates a gradual discrete color
#' palette.\cr
#' \code{\link{sr_palette}} returns the satellitereport.com
#' color palette.\cr
#' \code{\link{sr_palette}} returns the satellitereport.com
#' color palette.\cr
#' \code{\link{palette_eu_countries}} returns a variation of the
#' \code{\link{sr_palette}} resembling national colors.\cr
#' \code{\link{palette_europe_countries}} returns a variation of the
#' \code{\link{sr_palette}} resembling national colors for EU and
#' non-EU countries.\cr
#'
#' \code{\link{create_choropleth}} will create a ggplot2 object with a map
#' of European regions and continous or categorical data visualised on it. It
#' can convert continous (numeric) data into categories.
#' @docType package
#' @name satellitereport
NULL
