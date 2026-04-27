# mod_02_options.R

library(shiny)
library(shinyjs)
library(bslib)

# ==============================================================================
# MÓDULO 02: OPTIONS (LAUNCHER) - OFFLINE & SYNCED DEBUG
# ==============================================================================

mod_02_options_ui <- function(id) {
  ns <- NS(id)

  # --- Configuración de Categorías ---
  cat_ids <- c("init", "pack01_history", "pack02_sparring", "pack03_forms", "pack04_refereeing", "pack05_graduations", "fn05_tkd")
  cat_labels <- c("Welcome", "History", "Sparring", "Forms", "Refereeing", "Graduations", "Fortis Engine")

  # --- Lógica de rutas ---
  find_www <- function() {
    # posibles <- c(file.path(getwd(), "inst", "www"), file.path(getwd(), "www"), file.path(dirname(getwd()), "inst", "www"))
    posibles <- system.file("www", package = "FORTIS")

    for (r in posibles) if (dir.exists(r)) return(r)
    return(NULL)
  }
  www_path <- find_www()

  tagList(
    useShinyjs(),
    tags$style(HTML(paste0("
  /* FUERZA ELIMINACIÓN DE SCROLL EN EL BODY DE SHINY */
  html, body {
    margin: 0 !important;
    padding: 0 !important;
    height: 100vh !important;
    width: 100vw !important;
    overflow: hidden !important;
  }

  :root {
    --f-header: 'Impact', 'Arial Black', sans-serif;
    --f-body: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    --c-fortis: #00d4ff;
  }

  /* CONTENEDOR PRINCIPAL AL 100% */
  .main-body {
    display: flex;
    height: 75vh; /* Ocupa el 75% de la pantalla */
    width: 100vw;
    position: relative;
    background: #fff;
    overflow: hidden;
    font-family: var(--f-body);
    box-sizing: border-box;
    margin: 0 !important;
    padding: 0 !important;
  }

  /* PANELES SIN PADDING EXTRA QUE GENERE SCROLL */
  .panel-left   { flex: 0 0 20%; padding: 15px; border-right: 1px solid #f0f0f0; background: #fff; z-index: 10; box-sizing: border-box; }
  .panel-center { flex: 0 0 20%; padding: 15px; border-right: 2px solid var(--c-fortis); background: #fff; box-sizing: border-box; }
  .panel-right  { flex: 0 0 60%; padding: 20px; background: #fcfcfc; overflow-y: auto; box-sizing: border-box; }

  /* AJUSTE PARA QUE EL CONTENIDO DEL TAB NO GENERE OVERFLOW */
  .tab-content, .tab-pane { height: 100%; width: 100%; overflow: hidden; }

  /* DEBUG CONSOLE */
  .debug-console {
    position: absolute; top: 5px; left: 5px; z-index: 999;
    background: rgba(0, 212, 255, 0.1); border: 1px solid var(--c-fortis);
    color: var(--c-fortis); padding: 8px; font-family: 'Consolas', monospace;
    font-size: 9px; border-radius: 4px; pointer-events: none;
  }

  .btn-nav {
     background: #f8f9fa; border: 1px solid #e9ecef; color: #495057;
     font-weight: 700; padding: 10px; border-radius: 6px; margin-bottom: 5px;
     text-transform: uppercase; font-size: 0.7rem; text-align: left; width: 100%;
  }

  /* FOOTER AL 25% EXACTO */
  .footer-area {
    height: 25vh;
    width: 100vw;
    display: flex;
    align-items: center;
    justify-content: center;
    background: #fff;
    border-top: 1px solid #eee;
    margin: 0 !important;
    padding: 0 !important;
    box-sizing: border-box;
  }

  .footer-text { font-family: var(--f-header); letter-spacing: 10px; color: #ddd; margin: 0; }

  /* REGLA DE ORO: Quitar paddings de bslib/bootstrap */
  .container-fluid { padding: 0 !important; }
"))),

    div(class = "main-body",
        uiOutput(ns("debug_overlay")),

        # COLUMNA 1: NAVIGATION
        div(class = "panel-left",
            tags$h6("SYSTEM MODULES", style="color:#adb5bd; font-weight:800; margin-bottom:25px; margin-top:50px;"),
            lapply(seq_along(cat_ids), function(i) {
              actionButton(ns(paste0("btn_", cat_ids[i])), cat_labels[i], class = "btn-nav")
            })
        ),

        # COLUMNA 2: INFO
        div(class = "panel-center",
            navset_hidden(
              id = ns("nav_center"),
              nav_panel_hidden("init",
                               div(style="text-align:center; padding-top:60px; opacity:0.3;",
                                   icon("hand-pointer", class="fa-4x"),
                                   p("Select a module", style="font-weight:700; margin-top:10px;"))
              ),
              !!!lapply(2:length(cat_ids), function(i) {
                nav_panel_hidden(cat_ids[i],
                                 div(style="text-align:center; height:100%; display:flex; flex-direction:column; justify-content:center;",
                                     tags$h1("FORTIS", style="font-weight:900; margin:0; font-family: var(--f-header); font-size: 3.5rem;"),
                                     tags$div(cat_labels[i], style="color: var(--c-fortis); font-weight:800; text-transform: uppercase; letter-spacing: 2px;"),
                                     hr(style="width:40%; margin:25px auto;"),
                                     actionButton(ns(paste0("launch_", cat_ids[i])), "INITIALIZE", class = "btn-launch-active")
                                 )
                )
              })
            )
        ),

        # COLUMNA 3: REPOSITORY
        div(class = "panel-right",
            navset_hidden(
              id = ns("nav_right"),
              nav_panel_hidden("init", div(h2("Repository Area", style="font-family: var(--f-header);"), p("Standing by for selection..."))),
              !!!lapply(2:length(cat_ids), function(i) {
                nav_panel_hidden(cat_ids[i],
                                 h3(cat_labels[i], style="font-family: var(--f-header); margin-bottom:20px;"),
                                 div(style = "display: flex; flex-wrap: wrap; gap: 15px;",
                                     if(!is.null(www_path)) {
                                       files <- list.files(file.path(www_path, cat_ids[i]), pattern = "\\.(png|jpg|jpeg|webp)$", ignore.case = TRUE)
                                       addResourcePath(cat_ids[i], file.path(www_path, cat_ids[i]))
                                       lapply(files, function(f) tags$img(src = paste0(cat_ids[i], "/", f), class = "img-card"))
                                     }
                                 )
                )
              })
            )
        )
    ),
    div(class = "footer-area", tags$h4(class="footer-text", "CITIUS • ALTIUS • FORTIUS"))
  )
}

mod_02_options_server <- function(id, debug = TRUE) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    cat_ids <- c("init", "pack01_history", "pack02_sparring", "pack03_forms", "pack04_refereeing", "pack05_graduations", "fn05_tkd")
    current_cat <- reactiveVal("init")
    launcher_state <- reactiveValues(time = NULL, count = 0)

    # Navegación Sincronizada
    lapply(cat_ids, function(cat) {
      observeEvent(input[[paste0("btn_", cat)]], {
        current_cat(cat)
        nav_select("nav_center", cat)
        nav_select("nav_right", cat)

        lapply(cat_ids, function(id) shinyjs::removeClass(paste0("btn_", id), "selected-btn"))
        shinyjs::addClass(paste0("btn_", cat), "selected-btn")
      })

      observeEvent(input[[paste0("launch_", cat)]], {
        launcher_state$time <- Sys.time()
        launcher_state$count <- launcher_state$count + 1
      })
    })

    output$debug_overlay <- renderUI({
      req(debug)
      time_string <- if (is.null(launcher_state$time)) "N/A" else format(launcher_state$time, "%d/%m/%Y %H:%M:%S")

      div(class = "debug-console",
          div(style = "font-weight: 800; border-bottom: 1px solid var(--c-fortis); margin-bottom: 5px;", "Fortis Core System"),
          div(paste("ACTIVE   :", current_cat())),
          div(paste("TIMESTAMP:", time_string)),
          div(paste("INTERFACE: OPTIONS_MODE"))
      )
    })
  })
}

# # --- Ejecución ---
# ui <- page_fillable(theme = bs_theme(version = 5),mod_02_options_ui("options"))
# server <- function(input, output, session) { mod_02_options_server("options") }
# shinyApp(ui, server)
