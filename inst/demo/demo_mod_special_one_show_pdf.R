library(shiny)
library(bslib)

devtools::load_all()


# 1. Definimos una UI mínima para la prueba
ui_test <- page_fillable(
  # Llamamos a la UI del módulo
  mod_special_one_filler_ui("test_id")
)

# 2. Definimos un Server mínimo
server_test <- function(input, output, session) {
  # Llamamos al Server del módulo con los argumentos que quieras probar
  mod_special_one_filler_server("test_id", display_text = "MODO PRUEBA: ESTO FUNCIONA")
}

# 3. Ejecutamos la App de prueba
shinyApp(ui_test, server_test)
