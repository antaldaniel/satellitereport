#' Create A Choropleth Map
#'
#' This function will create a choropleth map of the European Union and some
#' of its (perspective) member candidates, the EEA countries, and the United
#' Kingdom. The geographical information must conform the official \code{geo}
#' codes of Eurostat.
#'
#' @param dat Eurostat data frame or a data frame derived from
#'  \code{create_indicator} or \code{create_tables}.
#' @param geo_var The name of the variable that contains the standard
#' \code{geo} codes. It defaults to \code{"geo"}.
#' @param values_var The name of the variable that contains the
#' \code{values} To be mapped. It defaults to \code{"values"}. If the data
#' you want to see on map is in the column \code{average_values}, than
#' use  \code{"average_values"}. The values can be numeric or categorical
#' variables.
#' @param unit_text Defaults to \code{NULL}. The title caption of the
#' color (fill) legend.
#' @param n Number of colour categories if discrete (categorical) colouring
#' is chosen, defaults to \code{5}.
#' @param type Defaults to \code{'discrete'} for coloring discrete
#' (categorical) values, can be set to \code{'numeric'} for continous
#' numeric values.
#' @param show_all_missing Defaults to \code{TRUE} when all regions with
#' missing values are explicitly shown in the map.  \code{FALSE} shows only
#' missing observations in \code{dat}. For example, if your dataset contains
#' observations on European Union regions, than it will not contain an
#' \code{NA} value or Norwegian regions in the case of \code{FALSE}.
#' @param color_palette A named character vector with colors. If you use this
#' with categorical variables, make sure that the color_palette has a value
#' for each categories except for missing values, and it is named to the
#' category name (factor level) as it is found in you \code{values_var}.
#' @param na_color Defaults to \code{"grey93"}. This color will be used
#' in the color palette for missing values, unless you have explicitly
#' set one of the names of the palette to \code{"missing"}.
#' @param drop_levels Weather to drop categorical levels on the choropleth
#' if they are not present in the data.  Defaults to \code{FALSE}.
#' @param style Style of interval reporting, defaults to \code{"pretty"}.
#' Style can be one of \code{"fixed"}, \code{"sd"}, \code{"equal"},
#' \code{"pretty"}, \code{"quantile"}, \code{"kmeans"}, \code{"hclust"},
#' \code{"bclust"}, \code{"fisher"}, \code{"jenks"} or \code{"dpih"}.
#' @param print_style Style of printing the labels, defaults to
#' \code{"min-max"}. Alternative is \code{"interval"}
#' @param reverse_scale Defaults to \code{FALSE}.
#' @param iceland Show Iceland on the choropleth?  Defaults to
#' \code{"if_present"}, which shows Iceland if Icelandic data
#' is present.
#' See: \code{\link[classInt]{classIntervals}}.
#' @importFrom dplyr mutate filter select add_count inner_join
#' @importFrom dplyr rename full_join anti_join
#' @importFrom dplyr mutate_if left_join
#' @importFrom tidyr spread
#' @importFrom magrittr `%>%`
#' @importFrom utils data
#' @importFrom forcats fct_explicit_na fct_relevel
#' @return The function returns a \code{ggplot2} object. You can modify the
#' ggplot object, for example, with adding {labs}.
#' @family visualisation functions
#' @examples
#' \dontrun{
#' chreate_choropleth ( your_nuts2_data, level=2, n=5, style="kmeans") +
#'  labs (title = "Your Title", fill = "fill legend name",
#'        subtitle = "Your Subtitle", caption ="Your caption or footnote.")
#' }
#' @export

create_choropleth <- function ( dat,
                                n = 5,
                                geo_var = 'geo',
                                values_var = 'values',
                                type = 'discrete',
                                show_all_missing = TRUE,
                                unit_text = NULL,
                                color_palette = NULL,
                                na_color = 'grey93',
                                drop_levels = FALSE,
                                reverse_scale = FALSE,
                                style = 'pretty',
                                print_style = 'min-max',
                                iceland = "if_present" ) {

  ## non-standard evaluation initialization
  . <- time <- geo <- title <- values <- base_color <- min_colur <- NULL
  code16  <- geodata_europe_2016 <- NULL
  n_category <- n


  ## checking inputs ------------------------------------------------
  check_dat_input(dat=dat, geo_var=geo_var, values_var=values_var)
  if(!is.null(color_palette)) {
    if ( length(color_palette)<n_category & type == "discrete" ){
      stop ("There are not enough colors for the discrete choropleth.")
    }
  }

  dat <- dplyr::select ( dat, all_of(c(geo_var, values_var)))

  ## formating text and legends ----------------------------------------
  unit_text <- if ( is.null(unit_text) ) { unit_text <- ""} else {
    unit_text <- paste(strwrap(as.character(unit_text), width=20),
                       collapse="\n")
  }

  ## Creating color palette
  if (!is.null(color_palette)) {
    min_color <- color_palette[1]
    max_color <- color_palette[2]
  } else {
    min_color <- 'white'
    max_color <- "#00843A"
  }

  ## loading map -----------------------------------------------
  utils::data ( "geodata_europe_2016",
                package = "satellitereport", envir=environment()
                )

  choropleth_map <- geodata_europe_2016

  add_to_map <- dat %>%
    rename ( geo    = {{ geo_var }},
             values = {{ values_var }})

  add_to_map <- add_to_map  %>%
    dplyr::select ( all_of(c("geo", "values") ))

  add_to_map <- mutate_if (add_to_map, is.factor, as.character)
  add_to_map_classes <- vapply(add_to_map, class, character(1))

  ## first numeric values are treated --------------------------
  if ( "numeric" %in% add_to_map_classes[2] ) {
    if ( type=='discrete' ) {
      add_to_map$cat <- indicator_categories(
        values = add_to_map$values,
        n = n_category,
        style = style,
        print_style = print_style)
    } else {
      type <- 'numeric'
    }
  } else { # non-numeric values_vars treated as discrete -----
    type <- 'discrete'
    cats <- unique (add_to_map$values)
    add_to_map$cat <- add_to_map$values
  } ## end of finding out choropleth data type


  ## Make 'missing' a category ----------------------------
  if ( 'cat' %in% names (add_to_map) ) {
    add_to_map <- add_to_map %>%
      dplyr::mutate(
        ## add explicit NA as 'missing'
        cat = forcats::fct_explicit_na(cat, na_level = 'missing')
      ) %>%
      dplyr::mutate(
        ## move 'missing' to the end of the category levels
        cat = forcats::fct_relevel(cat, 'missing',
                                   after = n_category)
      )
  }

  ## Adding the values to the shapefile of Europe-----------------
  choropleth_data <- choropleth_map %>%
    rename ( geo = NUTS_ID ) %>%
    dplyr::left_join(add_to_map, by = 'geo')

  ## If necessary, zoom out to include Iceland ---------------------
  if ( class (iceland) == "character" ) {
    if (  ! any( c("true", "false") %in% tolower(iceland)) ) {
      iceland <- ifelse (
        # If any NUTS code starts with IS for Island
        test = "IS" %in% substr(dat$geo,1,2),
        yes = TRUE, no = FALSE )
    } else if (tolower(iceland) == 'true') {
      iceland <- TRUE
    }  else  if ( tolower (iceland) == 'false') {
      iceland <- FALSE
    }
  }

  ## Coloring for discrete map -----------------------
  if ( type == 'discrete' ) {

    unique_cats <- levels(add_to_map$cat)[
      levels(add_to_map$cat)!= "missing" ]

    if ( is.null(color_palette)) {
      color_palette <- create_color_palette( n=length(unique_cats) )
    }

    color_palette <- c(color_palette, na_color )
    names (color_palette) <- c(unique_cats, "missing")

    are_there_missings <- any(levels(choropleth_data$cat)== "missing" )

    choropleth_data <- choropleth_data %>%
      filter ( !is.na(cat) )

    p <- create_base_plot_cat(choropleth_data = choropleth_data,
                              color_palette = color_palette,
                              na_color = na_color,
                              unit_text = unit_text,
                              iceland = iceland,
                              are_there_missings = are_there_missings )
  } else {
    ## Create the numeric map -----------------------------------
    choropleth_data <- choropleth_data %>%
      filter ( !is.na(values) )

    p <- create_base_plot_num(
      choropleth_data = choropleth_data,
      min_color = min_color,
      max_color = max_color,
      na_color = na_color,
      unit_text = unit_text,
      iceland = iceland )
  }
  ## Return choropleth ------------------------------------------
 p
}

