
library(ggplot2)
dat
n = 5
geo_var = 'geo'
values_var = 'values'
type = 'discrete'
show_all_missing = TRUE
unit_text = NULL
color_palette = NULL
na_color = 'grey93'
drop_levels = FALSE
reverse_scale = FALSE
style = 'pretty'
print_style = 'min-max'
iceland = "if_present"
dat = nuts_with_missings
dat$values[c(100,200,300,400,500,600,700,800)] <- NA_real_

dat$country = dat$geo

create_choropleth(dat = dat)

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
    select ( all_of(c("geo", "values") ))

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

  ## Adding the values to the shapefile of Europe-----------------
  choropleth_data <- choropleth_map %>%
    rename ( geo = NUTS_ID) %>%
    dplyr::left_join(add_to_map, by = 'geo')

  ## Make 'missing' a category ----------------------------
  if ( 'cat' %in% names (choropleth_data)) {
    choropleth_data <- choropleth_data  %>%
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


  ## If necessary, zoom out to include Iceland ---------------------
  if ( class (iceland) == "character" ) {
    if (  ! any( c("true", "false") %in% tolower(iceland)) ) {
      iceland <- ifelse ( "IS" %in% dat$geo, TRUE, FALSE )
    } else if (tolower(iceland) == 'true') {
      iceland <- TRUE
    }  else  if ( tolower (iceland) == 'false') {
      iceland <- FALSE
    }
  }

  ## Coloring for discrete map -----------------------
  if ( type == 'discrete' ) {

      unique_cats <- levels(choropleth_data$cat)[levels(choropleth_data$cat)!= "missing"]

  if ( is.null(color_palette)) {
        color_palette <- create_color_palette( n=length(unique_cats) )
    }

  color_palette <- c(color_palette, na_color )
  names (color_palette) <- c(unique_cats, "missing")

  are_there_missings <- any(levels(choropleth_data$cat)== "missing" )

  p <- create_base_plot_cat(choropleth_data = choropleth_data,
                              iceland = iceland,
                              are_there_missings = are_there_missings )
  } else {
    ## Create the numeric map -----------------------------------
    p <- create_base_plot_num(
      choropleth_data = choropleth_data,
      iceland = iceland )
  }
  ## Return choropleth ------------------------------------------
 p
}

