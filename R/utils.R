

check_dat_input <- function(dat, geo_var, values_var) {

  if ( ! 'data.frame' %in% class(dat) ) {
    stop ("Parameter 'dat' must be a data.frame-like object.")
  }

  if ( ! values_var %in% names(dat) ) {
    stop ("Parameter 'values_var='", values_var, "' is not present in 'dat'")
  }

  if ( ! geo_var %in% names(dat) ) {
    stop ("Parameter 'geo_var='", geo_var, "' is not present in 'dat'")
  }
}

create_base_plot_num <- function (choropleth_data, iceland) {
  base_plot_num <- choropleth_data  %>%
    ggplot2::ggplot(data=.) +
    ggplot2::geom_sf(data=.,
                     ggplot2::aes(fill=values),
                     color="white", size=.05) +
    ggplot2::scale_fill_continuous(
      ggplot2::scale_fill_gradient(low =  min_color,
                                   high = max_color,
                                   na.value = na_color )
    ) +
    ggplot2::guides(fill = ggplot2::guide_legend(reverse=FALSE,
                                                 title = unit_text)) +
    ggplot2::theme_light() +
    ggplot2::theme(legend.position='right',
                   axis.text = element_blank(),
                   axis.ticks = element_blank())

  if ( iceland ) {
    p <- base_plot_num  +
      ggplot2::coord_sf(xlim = c(-23,34), ylim = c(34.5,71.5))
  } else {
    p <- base_plot_num  +
      ggplot2::coord_sf(xlim = c(-11.7, 32.3), ylim = c(34.5,71.5))
  }

}

create_base_plot_cat <- function(choropleth_data,
                                 iceland,
                                 are_there_missings) {

  base_plot_cat <- ggplot2::ggplot(data=choropleth_data)

  base_plot_cat <- base_plot_cat +
    ggplot2::geom_sf( data= choropleth_data,
                      ggplot2::aes(fill=cat),
                      color="white", size=.05
    )  +
    ggplot2::guides(fill = ggplot2::guide_legend(reverse=FALSE,
                                                 title = unit_text)) +
    ggplot2::theme_light() +
    ggplot2::theme(legend.position='right',
                   axis.text = ggplot2::element_blank(),
                   axis.ticks = ggplot2::element_blank())

  #plot ( base_plot_cat)

  if (are_there_missings) {
    base_plot_cat <-  base_plot_cat +
      ggplot2::scale_fill_manual(values = color_palette,
                                 na.value = na_color,
                                 drop = drop_levels)
  } else {
    base_plot_cat <-  base_plot_cat +
      ggplot2::scale_fill_manual(values = color_palette,
                                 breaks = names(color_palette),
                                 drop = drop_levels )
  }

  if ( iceland ) {
    p <- base_plot_cat  +
      ggplot2::coord_sf(xlim = c(-23,34), ylim = c(34.5,71.5))
  } else {
    p <- base_plot_cat  +
      ggplot2::coord_sf(xlim = c(-11.7, 32.3), ylim = c(34.5,71.5))
  }

  p
}
