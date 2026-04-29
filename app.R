library(shiny)
library(shinyjs)
library(bslib)
library(yaml)
library(shiny)
library(shinyjs) # <--- ESTO ES LO QUE TE FALTA
# 1. CARGAR RECURSOS Y MÓDULOS
devtools::load_all()

# Definición de IDs de los packs para automatizar el relleno
cat_ids <- c("pack01_history", "pack02_sparring", "pack03_forms",
             "pack04_refereeing", "pack05_graduations", "fn05_tkd")

# 2. INTERFAZ DE USUARIO (UI)
ui <- page_fillable(
  shinyjs::useShinyjs(),

  tags$head(
    tags$style(HTML("
      body, html, .container-fluid, .page-fillable {
        background: transparent !important;
        padding: 0 !important;
        margin: 0 !important;
        overflow: hidden;
      }
      .tab-content, .tab-pane, .navset-hidden {
        background: transparent !important;
        border: none !important;
        height: 100vh !important;
      }
      #global_bg-bg_container { z-index: -1 !important; }
    "))
  ),

  # CAPA 0: FONDO
  mod_00_background_ui("global_bg"),

  # CAPA 1: NAVEGACIÓN
  navset_hidden(
    id = "main_nav",
    nav_panel_hidden("page_home", mod_01_home_ui("home", bg_opacity = 0)),
    nav_panel_hidden("page_options", mod_02_options_ui("options", bg_opacity = 0)),

    # Módulo Real: Graduaciones
    nav_panel_hidden("page_pack05_graduations", mod_graduations_manager_ui("graduations")),

    # Módulos de Relleno para el resto (se generan dinámicamente)
    nav_panel_hidden("page_pack01_history",   mod_special_one_filler_ui("filler_history")),
    nav_panel_hidden("page_pack02_sparring",  mod_special_one_filler_ui("filler_sparring")),
    nav_panel_hidden("page_pack03_forms",     mod_special_one_filler_ui("filler_forms")),
    nav_panel_hidden("page_pack04_refereeing", mod_special_one_filler_ui("filler_refereeing")),
    nav_panel_hidden("page_fn05_tkd",         mod_special_one_filler_ui("filler_tkd"))
  )
)

# 3. LÓGICA DEL SERVIDOR (SERVER)
server <- function(input, output, session) {

  # --- INICIALIZACIÓN DE MÓDULOS BASE ---
  bg_engine     <- mod_00_background_server("global_bg")
  home_logic    <- mod_01_home_server("home")
  options_logic <- mod_02_options_server("options")

  # --- INICIALIZACIÓN DE MÓDULOS DE CONTENIDO ---

  # 1. Graduaciones (Real)
  grad_logic <- mod_graduations_manager_server("graduations")

  # 2. Fillers (Independientes)
  filler_hist <- mod_special_one_filler_server("filler_history",    "HISTORIA Y FILOSOFÍA")
  filler_spar <- mod_special_one_filler_server("filler_sparring",   "SPARRING & COMBATE")
  filler_form <- mod_special_one_filler_server("filler_forms",      "POOMSAE & FORMAS")
  filler_refe <- mod_special_one_filler_server("filler_refereeing", "REGLAMENTO DE ARBITRAJE")
  filler_tkde <- mod_special_one_filler_server("filler_tkd",        "FORTIS ANALYTICS ENGINE")

  # --- GESTIÓN DE NAVEGACIÓN ---

  # Inicio
  observe({ nav_select("main_nav", "page_home") })

  # HOME -> OPTIONS
  observeEvent(home_logic$goto(), {
    req(home_logic$goto())
    nav_select("main_nav", "page_options")
    home_logic$reset()
  }, ignoreInit = TRUE)

  # OPTIONS -> HOME
  observeEvent(options_logic$value(), {
    req(options_logic$value() == "home")
    nav_select("main_nav", "page_home")
    options_logic$reset()
  })

  # OPTIONS -> MÓDULOS ESPECÍFICOS
  observeEvent(options_logic$value(), {
    val <- options_logic$value()
    req(val, val != "home", val != "init")

    # Navegamos a la página correspondiente
    nav_select("main_nav", paste0("page_", val))
  })

  # --- GESTIÓN DE RETORNO (VOLVER) ---

  # Creamos una lista con todas las lógicas de módulos que tienen botón volver
  logics <- list(
    grad_logic, filler_hist, filler_spar,
    filler_form, filler_refe, filler_tkde
  )

  # Observador universal para la señal 'goto_back' de cualquier módulo
  lapply(logics, function(lgc) {
    observeEvent(lgc$goto_back(), {
      req(lgc$goto_back())

      # Volver al menú de opciones
      nav_select("main_nav", "page_options")

      # Resetear el estado del lanzador y del propio módulo
      options_logic$reset()
      lgc$reset()
    })
  })
}

# 4. LANZAR LA APP
shinyApp(ui, server)
