

load_package_data <- function(dataset) {

  .new_data_environment <- new.env(parent=emptyenv()) # a new environment

  if (! exists(x = dataset, envir = .new_data_environment) ) {
    data(list = dataset,
         package = "satellitereport",
         envir=.new_data_environment)
  }
  .new_data_environment[[dataset]]
}

load_package_data('geodata_nuts1')
