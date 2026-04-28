# ==============================================================================
# FORTIS SYSTEM - MAIN APPLICATION (app.R)
# ==============================================================================

library(shiny)
library(shinyjs)
library(bslib)
library(yaml)

# 1. CARGAR LIBRERÍA
devtools::load_all()

# 2. INTERFAZ DE USUARIO (UI)
ui <- page_fillable(
  useShinyjs(),
  tags$style("body { padding: 0 !important; margin: 0 !important; overflow: hidden; }"),

  navset_hidden(
    id = "main_nav",

    # --- PANELES PRINCIPALES ---
    nav_panel_hidden("page_home", mod_01_home_ui("home")),
    nav_panel_hidden("page_options", mod_02_options_ui("options")),

    # --- PANELES DE CONTENIDO (PACKS) ---
    nav_panel_hidden("option_history",    mod_special_one_filler_ui("history")),
    nav_panel_hidden("option_sparring",   mod_special_one_filler_ui("sparring")),
    nav_panel_hidden("option_forms",      mod_special_one_filler_ui("forms")),
    nav_panel_hidden("option_refereeing", mod_special_one_filler_ui("refereeing")),
    nav_panel_hidden("option_graduations", mod_graduations_manager_ui("graduaciones")),
    nav_panel_hidden("option_engine",     mod_special_one_filler_ui("engine"))
  )
)

# 3. LÓGICA DEL SERVIDOR (SERVER)
server <- function(input, output, session) {

  # --- INICIALIZACIÓN DE SERVIDORES ---

  # Core
  home_logic    <- mod_01_home_server("home", debug = TRUE)
  options_logic <- mod_02_options_server("options", debug = TRUE)

  # Contenido Real
  grad_logic    <- mod_graduations_manager_server("graduaciones")

  # Contenido de Relleno (Special One)
  history_logic  <- mod_special_one_filler_server("history",    "CRONOLOGÍA Y FILOSOFÍA")
  sparring_logic <- mod_special_one_filler_server("sparring",   "TÁCTICAS DE COMBATE WT")
  forms_logic    <- mod_special_one_filler_server("forms",      "ESTRUCTURA DE POOMSAE")
  referee_logic  <- mod_special_one_filler_server("refereeing", "REGLAMENTO INTERNACIONAL")
  engine_logic   <- mod_special_one_filler_server("engine",     "FORTIS ANALYTICS ENGINE")


  # --- FLUJO 01: HOME -> OPTIONS ---
  observeEvent(home_logic$goto(), {
    req(home_logic$goto())
    nav_select("main_nav", "page_options")
    home_logic$reset()
  }, ignoreInit = TRUE)


  # --- FLUJO 02: RUTEADOR CENTRALIZADO (OPTIONS -> PACKS) ---
  observeEvent(options_logic$value(), {
    req(options_logic$value(), options_logic$is_executed())
    target <- options_logic$value()

    switch(target,
           "home"               = nav_select("main_nav", "page_home"),
           "pack01_history"     = nav_select("main_nav", "option_history"),
           "pack02_sparring"    = nav_select("main_nav", "option_sparring"),
           "pack03_forms"       = nav_select("main_nav", "option_forms"),
           "pack04_refereeing"  = nav_select("main_nav", "option_refereeing"),
           "pack05_graduations" = nav_select("main_nav", "option_graduations"),
           "fn05_tkd"           = nav_select("main_nav", "option_engine")
    )

    options_logic$reset()
  }, ignoreInit = TRUE)


  # --- FLUJO 03: GESTIÓN DE RETORNOS (TODOS -> OPTIONS) ---

  # Creamos una lista con todos los logics que tienen botón "Volver"
  all_back_signals <- list(
    grad = grad_logic, hist = history_logic, spar = sparring_logic,
    form = forms_logic, ref = referee_logic, eng = engine_logic
  )

  # Creamos un observador para cada uno de forma dinámica
  lapply(all_back_signals, function(logic) {
    observeEvent(logic$goto_back(), {
      req(logic$goto_back())
      nav_select("main_nav", "page_options")
      logic$reset()
    }, ignoreInit = TRUE)
  })


  # --- MONITOR DE SISTEMA (DEBUG) ---
  observe({
    isolate({
      menu_sel <- options_logic$menu_selection()
      exec_st  <- options_logic$is_executed()
      val_out  <- if(is.null(options_logic$value())) "NULL" else options_logic$value()

      cat("\n[FORTIS LOG]",
          "\n> Previsualizando :", menu_sel,
          "\n> Click Ejecución :", exec_st,
          "\n> Destino App    :", val_out,
          "\n--------------------------------")
    })
  })
}

# 4. LANZAR LA APP
shinyApp(ui, server)
# shiny::runApp(launch.browser = TRUE)
