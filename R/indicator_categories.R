#' Create Categories From Numeric Vector.
#'
#' A wrapper around \code{\link[classInt]{classIntervals}} that
#' creates printable univariate class intervals from numeric values.
#' @param values A numeric vector that may contain missing values.
#' @param n Number o intervals, defaults to \code{5}.
#' @param dataPrecision = Number of digits on labels, defaults to
#' \code{0}.
#' @param style Style of interval reporting, defaults to \code{"pretty"}.
#' Style can be one of \code{"fixed"}, \code{"sd"}, \code{"equal"},
#' \code{"pretty"}, \code{"quantile"}, \code{"kmeans"}, \code{"hclust"},
#' \code{"bclust"}, \code{"fisher"}, \code{"jenks"} or \code{"dpih"}.
#' See: \code{\link[classInt]{classIntervals}}.
#' @param print_style Style of printing the labels, defaults to
#' \code{"min-max"}. Alternative is \code{"interval"}
#' @return A character vector containing the category labels.
#' @importFrom classInt classIntervals
#' @importFrom forcats fct_relevel
#' @export
#' @examples{
#' indicator_categories(1:7, n=2)
#' indicator_categories(c(1:6, NA), n=2, print_style = "interval")
#' }

indicator_categories <- function ( values,
                                n = 5,
                                dataPrecision = 0,
                                style = "pretty",
                                print_style = "min-max" ) {

  if (! any(c('numeric', 'integer') %in% class(values)) ) {
    stop ( 'values must be a numeric vector.')
  }

  values_with_na <- values
  values_without_na <- values[!is.na(values)]

  range <- range ( values_without_na)[2]-range(values_without_na)[1]

  if ( range > 200 )   dataPrecision <- 0
  if ( range < 10 )    dataPrecision <- 1
  if ( range < 1 )     dataPrecision <- 2
  if ( range < 0.1 )   dataPrecision <- 3
  if ( range < 0.01 )  dataPrecision <- 4

  categorized <- classInt::classIntervals(values_without_na,
                                          n = n,
                                          style = style,
                                          dataPrecision = dataPrecision )
  categorized
  attr(categorized, "classIntervals")

  left  <- categorized$brks[1:(length(categorized$brks)-1)]
  right <- categorized$brks[2:length(categorized$brks)]

  if ( print_style == 'interval') {
    cats <- data.frame(
      names = paste0( "[",left, ",", right, ")" ),
      min = left) %>%
      rbind (data.frame(
        names = 'missing',
        min = left[1]-1
      ))

   cats$names <- forcats::fct_reorder( cats$names,cats$min, min)

  } else {
    cats <- data.frame (
      names = paste0(as.character(round(left, dataPrecision)),
                         "-",  as.character(round(right, dataPrecision))),
      min = left) %>%
      rbind (data.frame(
        names = 'missing',
        min = left[1]-1
      ))

    cats$names <- forcats::fct_reorder( cats$names,cats$min, min)
  }
  categorized$brks

  return_df <- data.frame ( values = values,
                            cats = 'missing', stringsAsFactors = F)

  for ( i in 1:(length(cats$min)-1) ) {
    return_df$cats <- ifelse ( test = (return_df$values >= cats$min[i]),
                               yes = as.character(cats$names[i]),
                               no = return_df$cats )

    }

  if ( ! any(is.na(return_df$values)) ) {
    return_df <- rbind ( return_df, data.frame ( values = NA_real_,
                                                 cats = 'missing')) ## make sure there is missing present

  } else {
    return_df$cats <- ifelse (is.na(return_df$values), "missing", return_df$cats)
  }

  return_df$cats <- as.factor (return_df$cats )
  return_df$cats <- forcats::fct_relevel(return_df$cats, levels(cats$names))
  return_df[1:length(values),"cats"]

  }
