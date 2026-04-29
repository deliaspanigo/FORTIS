# ==============================================================================
# FORTIS SYSTEM - APP CORE (app.R) - INTEGRACIÓN MOD 01 Y MOD 02
# ==============================================================================

library(shiny)
library(shinyjs)
library(bslib)

# 1. CARGAR RECURSOS Y MÓDULOS
devtools::load_all()

# 2. INTERFAZ DE USUARIO (UI)
ui <- page_fillable(
  useShinyjs(),

  # CSS MAESTRO DE TRANSPARENCIA PARA CAPAS FLOTANTES
  tags$head(
    tags$style(HTML("
      /* Reset global de bslib */
      body, html, .container-fluid, .page-fillable {
        background: transparent !important;
        padding: 0 !important;
        margin: 0 !important;
        overflow: hidden;
      }

      /* Perforar los contenedores de navegación de Shiny */
      .tab-content, .tab-pane, .navset-hidden {
        background: transparent !important;
        background-color: transparent !important;
        border: none !important;
        height: 100vh !important;
      }

      /* El motor de fondo (Módulo 00) siempre al fondo absoluto */
      #global_bg-bg_container {
        z-index: -1 !important;
      }
    "))
  ),

  # CAPA 0: EL MOTOR DE FONDO (Módulo 00)
  mod_00_background_ui("global_bg"),

  # CAPA 1: NAVEGACIÓN (Contenido que flota sobre el motor)
  navset_hidden(
    id = "main_nav",

    # HOME: Opacidad 0 para ver el carrusel completo
    nav_panel_hidden("page_home", mod_01_home_ui("home", bg_opacity = 0)),

    # OPTIONS: Opacidad 0 (usa sus propios fondos rgba internos para legibilidad)
    nav_panel_hidden("page_options", mod_02_options_ui("options", bg_opacity = 0))
  )
)

# 3. LÓGICA DEL SERVIDOR (SERVER)
server <- function(input, output, session) {

  # --- INICIALIZACIÓN DE MÓDULOS ---

  # Motor de fondo
  bg_engine  <- mod_00_background_server("global_bg", debug = TRUE)

  # Módulo Home (Bienvenida)
  home_logic <- mod_01_home_server("home")

  # Módulo Options (Launcher)
  options_logic <- mod_02_options_server("options")


  # --- CONTROLADOR DE NAVEGACIÓN ---

  # 1. Al iniciar la app, mostrar el Home
  observe({
    nav_select("main_nav", "page_home")
  })

  # 2. Flujo: HOME -> OPTIONS (Al presionar ENTRAR)
  observeEvent(home_logic$goto(), {
    req(home_logic$goto())
    nav_select("main_nav", "page_options")
    home_logic$reset() # Limpiar estado para permitir re-entrada
  }, ignoreInit = TRUE)

  # 3. Flujo: OPTIONS -> HOME (Al presionar BACK / LOGOUT)
  observeEvent(options_logic$value(), {
    req(options_logic$value() == "home")
    nav_select("main_nav", "page_home")
    options_logic$reset() # Limpiar estado
  })

  # 4. (Opcional) Lanzador de módulos específicos
  observeEvent(options_logic$value(), {
    val <- options_logic$value()
    req(val)
    if(val != "home") {
      print(paste("SISTEMA: Inicializando módulo ->", val))
      # Aquí iría la lógica para abrir pack01, pack02, etc.
    }
  })

}

# 4. LANZAR LA APP
shinyApp(ui, server)
