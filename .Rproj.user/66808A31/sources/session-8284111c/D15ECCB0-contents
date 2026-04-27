library(shiny)
library(shinyjs)
library(bslib)

# 1. Cargar la librería
devtools::load_all()

# 2. UI
ui <- page_fillable(
  useShinyjs(),
  navset_hidden(
    id = "main_nav",
    nav_panel_hidden("page_home", mod_01_home_ui("home")),
    nav_panel_hidden("page_options", mod_02_options_ui("options"))
  )
)

# 3. Server
server <- function(input, output, session) {

  # 1. Inicializar servidores de módulos
  home_logic    <- mod_01_home_server("home", debug = TRUE)
  options_logic <- mod_02_options_server("options", debug = TRUE)

  # --- NAVEGACIÓN: HOME -> OPTIONS ---
  observeEvent(home_logic$goto(), {
    req(home_logic$goto()) # Solo si no es NULL

    # Cambiamos de pestaña
    nav_select("main_nav", "page_options")

    # IMPORTANTE: Limpiamos la señal en el origen para que el pró`ximo clic se detecte
    home_logic$reset()
  }, ignoreInit = TRUE)

  # --- NAVEGACIÓN: OPTIONS -> HOME ---
  observeEvent(options_logic$goto(), {
    req(options_logic$goto())

    # Cambiamos de pestaña
    nav_select("main_nav", "page_home")

    # IMPORTANTE: Limpiamos la señal en el origen
    options_logic$reset()
  }, ignoreInit = TRUE)

  # --- Debug opcional para ver que las señales viajan ---
  observe({
    print(paste("Señal Home:", home_logic$goto()))
    print(paste("Señal Options:", options_logic$goto()))
  })
}

shinyApp(ui, server)
