#' Wrap Text To Adequate Width
#'
#' A wrapper around \code{\link[base]{strwrap}} that
#' creates wrapped text for captions.
#' @param text A character vector that is too long to fit in a caption.
#' @param width Number of characters to allow in text,
#' defaults to \code{50}.
#' @return A character vector containing the category labels.
#' @family utility functions
#' @export
#' @examples{
#' my_text <- "Regional gross domestic product by NUTS 2 regions - million EUR"
#' nchar(my_text)
#' text_wrap (my_text, 40)
#' }


text_wrap <- function(text, width = 50) {
  paste(strwrap(as.character(text), width=width),
        collapse="\n")
}
