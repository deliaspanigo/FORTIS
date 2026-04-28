# ==============================================================================
# FORTIS SYSTEM - MAIN APPLICATION (app.R)
# ==============================================================================

library(shiny)
library(shinyjs)
library(bslib)
library(yaml)

# 1. CARGAR LIBRERÍA (Asegura que todos tus módulos estén disponibles)
devtools::load_all()

# 2. INTERFAZ DE USUARIO (UI)
# Usamos un contenedor que llene toda la pantalla y oculte la navegación
ui <- page_fillable(
  useShinyjs(),

  # Estilo global para asegurar el look "full-screen"
  tags$style("body { padding: 0 !important; margin: 0 !important; overflow: hidden; }"),

  navset_hidden(
    id = "main_nav",

    # PESTAÑA 01: HOME (Módulo 01)
    nav_panel_hidden("page_home",
                     mod_01_home_ui("home")
    ),

    # PESTAÑA 02: OPCIONES / LANZADOR (Módulo 02)
    nav_panel_hidden("page_options",
                     mod_02_options_ui("options")
    ),

    # PESTAÑA 03: GRADUACIONES (Módulo PDF Manager)
    nav_panel_hidden("option01_graduaciones",
                     mod_graduations_manager_ui("graduaciones")
    )

    # Aquí puedes seguir agregando más paneles ocultos para otros packs
  )
)

# 3. LÓGICA DEL SERVIDOR (SERVER)
server <- function(input, output, session) {

  # --- INICIALIZACIÓN DE SERVIDORES DE MÓDULOS ---
  home_logic    <- mod_01_home_server("home", debug = TRUE)
  options_logic <- mod_02_options_server("options", debug = TRUE)
  grad_logic    <- mod_graduations_manager_server("graduaciones")

  # --- FLUJO 01: HOME -> OPTIONS ---
  observeEvent(home_logic$goto(), {
    req(home_logic$goto())

    nav_select("main_nav", "page_options")

    # Limpieza de señal en el origen
    home_logic$reset()
  }, ignoreInit = TRUE)


  # --- FLUJO 02: RUTEADOR CENTRALIZADO (OPTIONS -> PACKS) ---
  observeEvent(options_logic$value(), {
    # Validamos que haya un valor y que se haya pulsado INITIALIZE (is_executed)
    req(options_logic$value(), options_logic$is_executed())

    target <- options_logic$value()

    # Decidimos el destino según el ID que emite el módulo de opciones
    switch(target,
           "home" = {
             nav_select("main_nav", "page_home")
           },
           "pack05_graduations" = {
             nav_select("main_nav", "option01_graduaciones")
           },
           "pack01_history" = {
             # Ejemplo: nav_select("main_nav", "page_history")
             showNotification("Módulo de Historia en desarrollo", type = "message")
           },
           "fn05_tkd" = {
             showNotification("Fortis Engine Iniciado", type = "warning")
           }
    )

    # REGLA DE ORO: Siempre resetear después de ejecutar la acción
    options_logic$reset()
  }, ignoreInit = TRUE)


  # --- FLUJO 03: RETORNO (Cualquier Pack -> OPTIONS) ---
  # Escuchamos la señal de volver del manager de graduaciones
  observeEvent(grad_logic$goto_back(), {
    req(grad_logic$goto_back())

    nav_select("main_nav", "page_options")

    # Limpiamos la señal del manager
    grad_logic$reset()
  }, ignoreInit = TRUE)


  # --- MONITOR DE SISTEMA (DEBUG EN CONSOLA) ---
  observe({
    # Usamos isolate para evitar ciclos reactivos en el print
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
