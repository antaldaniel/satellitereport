#' Return a color for each EU country from the SR palette.
#'
#' @param eu_countries_4 If \code{TRUE}, returns values for \code{GB-G},
#' \code{GB-N}, \code{DE-W}, \code{DE-E}.
#' @return A named vector of color hex strings for each country code.
#' @family palette constructor functions
#' @examples
#' palette_eu_countries(eu_countries_4 = TRUE)
#' @export

palette_eu_countries <- function ( eu_countries_4 = FALSE ) {

   my_palette <- c(
     "#007CBB", "#4EC0E4", "#00843A", "#3EA135",
     "#DB001C", "#5C2320", "#4E115A", "#00348A",
     "#BAC615", "#FAE000", "#E88500", "#E4007F")

   names (my_palette) <- c(
     "blue", "lightblue", "darkgreen", "green",
     "red", "brown", "violet", "darkblue",
     "lightgreen", "yellow", "orange", "magenta")

   palette_eu_countries_4 <- c(
     "HU" = my_palette[['green']],
     "PL" = my_palette[['red']],
     'SK' = my_palette[['lightblue']],
     'CZ' = my_palette[['blue']],
     'LV' = my_palette[['red']],
     'LT' =  my_palette[['yellow']],
     'EE' = 'black',
     'BE' = 'black',
     'NL' = my_palette[['orange']],
     'LU' = my_palette[['lightblue']],
     'GB-G' = my_palette[['darkblue']],
     'GB-N' = my_palette[['lightblue']],
     'IE' = my_palette[['darkgreen']],
     'DE-W' = 'black',
     'DE-E' = my_palette[['yellow']],
     'AT' = my_palette[['red']],
     'SI'= my_palette[['blue']],
     'FR'= my_palette[['darkblue']],
     'ES'= my_palette[['yellow']],
     'PT'= my_palette[['red']],
     'IT'= my_palette[['green']],
     'SE'= my_palette[['yellow']],
     'DK'= my_palette[['red']],
     'FI'= my_palette[['darkblue']],
     'HR' = my_palette[['red']],
     'GR'= my_palette[['lightblue']],
     'RO' = my_palette[['yellow']],
     'BG'= my_palette[['green']],
     'CY'= my_palette[['orange']],
     'MT'= my_palette[['red']])


 if ( eu_countries_4 == TRUE ) return ( palette_eu_countries_4 )

   c("HU" = my_palette[['green']],
     "PL" = my_palette[['red']],
     'SK' = my_palette[['lightblue']],
     'CZ' = my_palette[['blue']],
     'LV' = my_palette[['red']],
     'LT' =  my_palette[['yellow']],
     'EE' = 'black',
     'BE' = 'black',
     'NL' = my_palette[['orange']],
     'LU' = my_palette[['lightblue']],
     'GB' = my_palette[['darkblue']],
     'IE' = my_palette[['darkgreen']],
     'DE' = 'black',
     'AT' = my_palette[['red']],
     'SI'= my_palette[['blue']],
     'FR'= my_palette[['darkblue']],
     'ES'= my_palette[['yellow']],
     'PT'= my_palette[['red']],
     'IT'= my_palette[['green']],
     'SE'= my_palette[['yellow']],
     'DK'= my_palette[['red']],
     'FI'= my_palette[['darkblue']],
     'HR' = my_palette[['red']],
     'GR'= my_palette[['lightblue']],
     'RO' = my_palette[['yellow']],
     'BG'= my_palette[['green']],
     'CY'= my_palette[['orange']],
     'MT'= my_palette[['red']])

 }
