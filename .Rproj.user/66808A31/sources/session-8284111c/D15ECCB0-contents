library(shiny)
library(shinyjs)
library(bslib)

# 1. Cargar las funciones de tu librería (Módulos)
# Si estás dentro del proyecto de la librería, usa:
devtools::load_all()

# 2. Configuración de Rutas (Parche para desarrollo)
# Esto asegura que Shiny encuentre las fotos aunque no hayas instalado el paquete
if (interactive()) {
  # Busca la carpeta www localmente
  path_www <- "inst/www"
  if (!dir.exists(path_www)) path_www <- "www"

  # if (dir.exists(path_www)) {
  #   # Usamos los alias que definimos en los módulos
  #   addResourcePath("top_img_home", file.path(path_www, "fn01_top_img"))
  #   addResourcePath("home_assets_home", file.path(path_www, "fn10_home"))
  #   addResourcePath("tkd_imgs_home", file.path(path_www, "fn05_tkd"))
  # }
}

ui <- page_fillable(
  useShinyjs(),
  navset_hidden(
    id = "main_nav",
    nav_panel_hidden("page_home", mod_01_home_ui("home")),
    nav_panel_hidden("page_options", mod_02_options_ui("options"))
  )
)

server <- function(input, output, session) {
  # Lógica del Módulo 01
  home_logic <- mod_01_home_server("home", debug = TRUE)

  # Lógica del Módulo 02
  mod_02_options_server("options", debug = TRUE)

  # Cambio de página al hacer click en ENTRAR
  observe({
    # Usamos el valor reactivo que devuelve el módulo
    if (home_logic$clicked()) {
      nav_select("main_nav", "page_options")
    }
  })
}

shinyApp(ui, server)
