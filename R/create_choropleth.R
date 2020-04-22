#' Create A Choropleth Map
#'
#' This function will create a choropleth map of the European Union and some
#' of its (perspective) member candidates, the EEA countries, and the United
#' Kingdom. The geographical information must conform the official \code{geo}
#' codes of Eurostat.
#' @param dat Eurostat data frame or a data frame derived from
#'  \code{create_indicator} or \code{create_tables}.
#' @param level Defaults to \code{0}. The NUTS level used to create the
#' choropleth chart, i.e. \code{0}, \code{1}, \code{2} or \code{3}.
#' @param geo_var The name of the variable that contains the standard
#' \code{geo} codes. It defaults to \code{"geo"}.
#' @param values_var The name of the variable that contains the
#' \code{values} To be mapped. It defaults to \code{"values"}. If the data
#' you want to see on map is in the column \code{average_values}, than
#' use  \code{"average_values"}. The values can be numeric or categorical
#' variables.
#' @param unit_text Defaults to \code{NULL}.
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
#' @importFrom dplyr mutate_if
#' @importFrom poorman left_join
#' @importFrom tidyr spread
#' @importFrom magrittr `%>%`
#' @importFrom utils data
#' @importFrom grDevices colorRampPalette
#' @importFrom ggplot2 ggplot aes geom_sf
#' @importFrom ggplot2 scale_fill_manual scale_fill_gradient
#' @importFrom ggplot2 scale_fill_continuous
#' @importFrom ggplot2 labs theme_light theme guides coord_sf
#' @importFrom ggplot2 element_blank xlim ylim guide_legend
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
                                level = 0,
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

  . <- time <- geo <- title <- values <- base_color <- min_colur <- NULL
  code16  <- NULL
  geodata_nuts0 <- geodata_nuts1 <- geodata_nuts2 <- geodata_nuts3 <- NULL
  n_category <- n

  if (!is.null(color_palette)) {
    min_color <- color_palette[1]
    max_color <- color_palette[2]
  } else {
    min_color <- 'white'
    max_color <- "#00843A"
  }


  if ( !'data.frame' %in% class(dat) ) {
    stop("dat must be a data.frame-like object.") }

  if ( any(!c(geo_var, values_var) %in% names(dat)) ) {
    stop( paste(c(geo_var, values_var), collapse = ", ") ,
          " must be present in\nnames(dat)=",
          paste(names(dat), collapse=", "))
  }

  add_to_map <- dat[, c(geo_var, values_var)]
  if ( !ncol(add_to_map) ) stop ("add_to_map error.")

  add_to_map <- mutate_if (add_to_map, is.factor, as.character)
  add_to_map_classes <- vapply(add_to_map, class, character(1))
  names(add_to_map) <- c("geo", "values")

  ## first numeric values are treated --------------------------
  if ( "numeric" %in% add_to_map_classes[2] ) {
    if ( type=='discrete' ) {
      add_to_map$cat <- indicator_categories(
           values = add_to_map$values,
           n = n_category,
           style = style,
           print_style = print_style)

      unique_cats <- levels(add_to_map$cat)[levels(add_to_map$cat)!= "missing"]

      if ( is.null(color_palette)) {
        color_palette <- create_color_palette( n=length(unique_cats) )
      }

    } else {
      type <- 'numeric'
    }
  } else { # end of numeric cases, non-numeric maps follow -----
    type <- 'discrete'
    cats <- unique ( add_to_map$values)
    add_to_map$cat <- add_to_map$values
    add_to_map$cat <- forcats::fct_explicit_na(add_to_map$cat,
                                               na_level = 'missing')

    unique_cats <- unique(add_to_map$cat)[unique(add_to_map$cat)!='missing']

    levels ( add_to_map$cat)
    if ( is.null(color_palette) ) {
      color_palette <- create_color_palette(n=length(unique_cats))
    }
  } ## end of finding out choropleth data type

  ## loading the relevant map -------------------------------
  if ( level == 0 ) {
    utils::data("geodata_nuts0", package = "satellitereport", envir = environment())
    nuts_ids <- geodata_nuts0$id
    add_to_map$geo <- ifelse ( add_to_map$geo == "GB", "UK",
                        ifelse ( add_to_map$geo == "GR", "EL",
                                 add_to_map$geo))
    geodata <- geodata_nuts0
  } else if ( level == 1 )  {
    utils::data("geodata_nuts1", package = "satellitereport", envir = environment())
    geodata <- geodata_nuts1
    nuts_ids <- geodata$id
  } else if ( level == 2 )  {
    utils::data("geodata_nuts2", package = "satellitereport", envir = environment())
    geodata  <- geodata_nuts2
    nuts_ids <- geodata$id
  } else if ( level == 3 ) {
    utils::data("geodata_nuts3", package = "satellitereport", envir = environment())
    geodata  <- geodata_nuts3
    nuts_ids <- geodata$id
  }  else {
    stop ( "Level must be [NUTS] 0, 1, 2 or 3.")
  }

  this_geometry <- geodata$geometry
  ## joining data with map ---------------------------------------------
  add_to_map <- add_to_map %>%
    dplyr::filter( geo %in% nuts_ids )

  if ( nrow(add_to_map) ==  0) {
    stop("Data does not overlap with map. Is the NUTS level correctly set?")
  }

  geodata <- geodata %>%
    poorman::left_join(add_to_map, by = 'geo')

  #names ( geodata )

  #check <- geodata %>% select ( geo, cats )

  ## formating text and legends ----------------------------------------
  unit_text <- if ( is.null(unit_text) ) { unit_text <- ""} else {
    unit_text <- paste(strwrap(as.character(unit_text), width=20),
                        collapse="\n")
  }

  if ( class (iceland) == "character" ) {
    if (  ! any( c("true", "false") %in% tolower(iceland)) ) {
      iceland <- ifelse ( "IS" %in% dat$geo, TRUE, FALSE )
    } else if (tolower(iceland) == 'true') {
      iceland <- TRUE
    }  else  if ( tolower (iceland) == 'false') {
      iceland <- FALSE
    }
  }

  ## Make all missing cases explicit ---------------------------------

  if( show_all_missing & type == 'discrete' ) {

    geodata$cat <- forcats::fct_explicit_na(geodata$cat,
                                            na_level = "missing")

  }

  ## coloring & base map  ---------------------------------------------
  if ( type == 'discrete' ) {

    if ( 'cat' %in% names(geodata) ) {

      unique_categories <- levels(geodata$cat)[levels(geodata$cat)!='missing']

      color_palette <- color_palette[color_palette != na_color]
      color_palette <- color_palette[1:length(unique_categories)]

      are_there_missings <- any(levels(geodata$cat)== "missing" )
      if ( are_there_missings  ) {
        geodata$cat <- forcats::fct_relevel(geodata$cat,
                                            c(unique_categories,
                                            "missing"))
        color_palette <- c(color_palette, na_color)
      }
      names(color_palette) <- levels(geodata$cat)
    }


    base_plot_cat <- ggplot2::ggplot(data=geodata)

    base_plot_cat <- base_plot_cat +
      ggplot2::geom_sf( data= geodata,
               aes(fill=cat),
               color="white", size=.05
               )  +
      guides(fill = guide_legend(reverse=FALSE,
                                 title = unit_text)) +
      theme_light() +
      theme(legend.position='right',
            axis.text = element_blank(),
            axis.ticks = element_blank())

    #plot ( base_plot_cat)

    if (are_there_missings) {
      base_plot_cat <-  base_plot_cat +
        scale_fill_manual(values = color_palette,
                          na.value = na_color,
                          drop = drop_levels)
    } else {
      base_plot_cat <-  base_plot_cat +
        scale_fill_manual(values = color_palette,
                          breaks = names(color_palette),
                          drop = drop_levels )
    }

    if ( iceland ) {
      p <- base_plot_cat +
        coord_sf(xlim = c(-23,34), ylim = c(34.5,71.5))
    } else {
      p <- base_plot_cat +
        coord_sf(xlim = c(-11.7, 32.3), ylim = c(34.5,71.5))
    }

  } else {
    base_plot_num <- geodata %>%
      ggplot2::ggplot(data=.) +
      geom_sf(data=.,
              aes(fill=values),
              color="white", size=.05) +
      ggplot2::scale_fill_continuous(
        ggplot2::scale_fill_gradient(low =  min_color,
                                      high = max_color,
                                      na.value = na_color )
      ) +
      guides(fill = guide_legend(reverse=FALSE,
                                 title = unit_text)) +
      theme_light() +
      theme(legend.position='right',
            axis.text = element_blank(),
            axis.ticks = element_blank())

    if ( iceland ) {
      p <- base_plot_num +
        coord_sf(xlim = c(-23,34), ylim = c(34.5,71.5))
    } else {
      p <- base_plot_num +
        coord_sf(xlim = c(-11.7, 32.3), ylim = c(34.5,71.5))
    }
  }
  p
}

