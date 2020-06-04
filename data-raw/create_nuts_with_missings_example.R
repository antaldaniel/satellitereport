library(regions)
library(dplyr)
data ( "all_valid_nuts_codes")
head (all_valid_nuts_codes, 10)

nuts_sample <- all_valid_nuts_codes %>%
  filter ( nuts == "code_2016" ) %>%
  sample_n (900)

nuts_with_missings <- nuts_sample %>%
  select ( geo  ) %>%
  mutate ( values  = runif(nrow(.), 1,100))

usethis::use_data(nuts_with_missings, internal=FALSE)
