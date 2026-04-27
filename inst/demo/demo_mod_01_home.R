# # app.R principal
# library(shiny)
# library(shinyjs)
# library(jsonlite)
#
devtools::load_all()
#
# --- Test ---
ui <- fluidPage(mod_01_home_ui("home"))
server <- function(input, output, session) { mod_01_home_server("home", debug = TRUE) }
shinyApp(ui, server)
