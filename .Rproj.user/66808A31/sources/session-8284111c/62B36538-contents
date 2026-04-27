# # app.R principal
# library(shiny)
# library(shinyjs)
# library(jsonlite)
#
devtools::load_all()
#
# --- Test ---
ui <- fluidPage(mod_02_options_ui("options"))
server <- function(input, output, session) { mod_02_options_server("options", debug = TRUE) }
shinyApp(ui, server)
