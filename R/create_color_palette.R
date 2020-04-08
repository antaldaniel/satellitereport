#' Create A Discrete Color Palette
#'
#' This is a wrapper around \code{\link[grDevices]{colorRamp}}.
#' The default colors are taken from \code{\link{sr_palette}}.
#' @param n Number of colors, defaults to \code{5}.
#' @param base_color Defaults to \code{"#00348A"}.
#' @param min_color Defaults to \code{"grey90"}.
#' @param reverse_scale Defaults to \code{FALSE}.
#' @seealso sr_palette
#' @importFrom grDevices colorRampPalette
#' @examples {
#' create_color_palette(base_color = 'red', min_color = 'white', n=3)
#' create_color_palette('red', 'white', n=4, reverse_scale =TRUE)
#' }
#' @export

create_color_palette <- function(base_color = '#00348A',
                                 min_color = 'grey90',
                                 n = n,
                                 reverse_scale = FALSE) {

  color_palette <- grDevices::colorRampPalette(
    c(min_color, base_color),
    bias=.1,space="rgb")(n*2)

  if (reverse_scale) {
    color_palette <- rev(color_palette)
  }

  color_palette <- color_palette[ -1]
  color_palette[c(TRUE, FALSE)]
}
