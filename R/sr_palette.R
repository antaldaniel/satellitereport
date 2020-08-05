#' SR Color Palette
#'
#' @param ext Should the original 12 color palette be extended? Defaults
#' to \code{FALSE}.
#' @return The Satellit Report color palette designed by Endre Koronczi.
#' @family palette constructor functions
#' @examples{
#' sr_palette()
#' sr_palette(ext=TRUE)
#' }
#' @export

sr_palette <- function ( ext = FALSE) {
  my_palette <- c("#007CBB", "#4EC0E4", "#00843A", "#3EA135",
                  "#DB001C", "#5C2320", "#4E115A", "#00348A",
                  "#BAC615", "#FAE000", "#E88500", "#E4007F")

  names (my_palette) <- c("blue", "lightblue", "darkgreen", "green",
                          "red", "brown", "violet", "darkblue",
                          "lightgreen", "yellow", "orange", "magenta")

  if ( ext == TRUE ) {
    my_palette_ext <- c( my_palette, "#7f7f7f", "#282828", "#666666",
                         "#000000", "#141414")
    names (my_palette_ext)[13:17] <- c("ext1", "ext2", "ext3", "ext4", "ext5")
    return ( my_palette_ext)
  } else {
    return (my_palette)
  }
}
