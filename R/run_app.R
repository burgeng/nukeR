#' Run nukeR demo app
#' @export
run_app <- function() {
  app_dir <- system.file("shiny-examples/nukeViz", package = "nukeR")
  if (app_dir == "") stop("App directory not found. Try reinstalling nukeR.")
  shiny::runApp(app_dir, display.mode = "normal")
}
