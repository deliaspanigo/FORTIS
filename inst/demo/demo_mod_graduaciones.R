# # app.R principal
# library(shiny)
# library(shinyjs)
# library(jsonlite)
#
devtools::load_all()
#
# --- Test ---
library(shiny)
library(bslib)
library(yaml)
library(shinyjs)

# 1. Definir UI de prueba
ui_test <- page_fillable(
  useShinyjs(),
  # Fondo negro para mantener la estética de FORTIS
  tags$style("body { background-color: #000; color: white; }"),

  mod_graduations_manager_ui("test_grad")
)

# 2. Definir Server de prueba
server_test <- function(input, output, session) {

  # Llamamos al servidor del módulo
  grad_logic <- mod_graduations_manager_server("test_grad")

  # Observador para probar la señal de "VOLVER"
  observeEvent(grad_logic$goto_back(), {
    req(grad_logic$goto_back())

    showNotification(
      "Señal de RETORNO detectada. El App.R principal cerraría este panel.",
      type = "message",
      duration = 5
    )

    # Reseteamos la señal
    grad_logic$reset()
  })
}

# 3. Ejecutar
shinyApp(ui_test, server_test)
