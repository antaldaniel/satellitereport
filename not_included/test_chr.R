dat = this; level = 2;
values_var = 'values';
geo_var = 'code16';
unit_text = "unit";
color_palette = as.character(sr_palette());
type = 'discrete'; n=6;
style = 'quantile'; drop_levels = TRUE
are_there_missings = TRUE
na_color = 'grey93'
iceland = "if_present"
show_all_missing = TRUE
reverse_scale = FALSE
style = 'pretty'
print_style = 'min-max'

plot ( t )

saveRDS(t, file= "t.rds")
readRDS("not_included/tt.rds")
t <- readRDS("t.rds")

plot ( t)
this_tt <- readRDS("this_tt.rds")
plot (this_tt)
r <- readRDS('plot2.rds')
plot ( r)


r$data$geometry == t$data$geometry
r$layers
t$layers

r$data$geometry == t$data$geometry
