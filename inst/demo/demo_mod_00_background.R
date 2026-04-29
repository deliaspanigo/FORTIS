# # app.R principal
# library(shiny)
# library(shinyjs)
# library(jsonlite)
#
devtools::load_all()
#
library(shiny)
library(shinyjs)

# ==============================================================================
# SCRIPT DE EJECUCIÓN AISLADA: MOD_00 BACKGROUND
# ==============================================================================

ui <- fluidPage(
  # Estilos base para asegurar que el fondo ocupe todo el espacio
  tags$head(
    tags$style(HTML("
      body, html { margin: 0; padding: 0; overflow: hidden; background: #000; }
    "))
  ),

  # Llamada a la UI del módulo
  mod_00_background_ui("bg_test")
)

server <- function(input, output, session) {
  # Llamada al servidor del módulo
  bg_control <- mod_00_background_server("bg_test", debug = TRUE)

  # Ejemplo de interacción: cambiar opacidad a los 5 segundos
  observe({
    invalidateLater(5000)
    # bg_control$set_opacity(0.5) # Si implementaste las funciones de retorno
  })
}

shinyApp(ui, server)
