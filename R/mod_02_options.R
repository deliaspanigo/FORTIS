# ==============================================================================
# MÓDULO 02: OPTIONS (LAUNCHER) - CON TEXTOS DINÁMICOS Y EFECTOS
# ==============================================================================

mod_02_options_ui <- function(id) {
  ns <- NS(id)

  # --- Configuración de Categorías y Textos ---
  cat_ids <- c("init", "pack01_history", "pack02_sparring", "pack03_forms",
               "pack04_refereeing", "pack05_graduations", "fn05_tkd")

  cat_labels <- c("Welcome", "History", "Sparring", "Forms",
                  "Refereeing", "Graduations", "Fortis Engine")

  # Textos descriptivos para cada Workshop/Módulo
  cat_descriptions <- c(
    "init" = "Awaiting selection...",
    "pack01_history" = "Explora los orígenes, la filosofía y la evolución del Taekwondo a través del tiempo.",
    "pack02_sparring" = "Workshop de combate: Tácticas, análisis de distancia y entrenamiento de alta intensidad.",
    "pack03_forms" = "Perfeccionamiento técnico de Poomsae: Precisión, equilibrio y control de la energía.",
    "pack04_refereeing" = "Reglamentación oficial y criterios de puntuación para arbitraje internacional.",
    "pack05_graduations" = "Guía completa de requisitos y programas para exámenes de pase de grado.",
    "fn05_tkd" = "Fortis Engine: Procesamiento de datos y analítica avanzada aplicada al alto rendimiento deportivo."
  )

  # --- Lógica de rutas de recursos ---
  find_www <- function() {
    posibles <- system.file("www", package = "FORTIS")
    if (posibles == "") {
      for (r in c("inst/www", "www")) if (dir.exists(r)) return(r)
    }
    return(posibles)
  }
  www_path <- find_www()

  tagList(
    useShinyjs(),
    tags$style(HTML(paste0("
      html, body {
        margin: 0 !important; padding: 0 !important;
        height: 100vh !important; width: 100vw !important;
        overflow: hidden !important;
      }

      :root {
        --f-header: 'Impact', 'Arial Black', sans-serif;
        --f-body: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        --c-fortis: #00d4ff;
        --c-logout: #ff4d4d;
      }

      .main-body {
        display: flex; height: 75vh; width: 100vw;
        position: relative; background: #fff; overflow: hidden;
        font-family: var(--f-body); box-sizing: border-box;
      }

      /* PANELES */
      .panel-left   { flex: 0 0 20%; padding: 15px; border-right: 1px solid #f0f0f0; background: #fff; z-index: 10; display: flex; flex-direction: column; }
      .panel-center { flex: 0 0 20%; padding: 15px; border-right: 2px solid var(--c-fortis); background: #fff; }
      .panel-right  { flex: 0 0 60%; padding: 20px; background: #fcfcfc; overflow-y: auto; }

      /* DEBUG CONSOLE */
      .debug-console {
        position: absolute; top: 5px; left: 5px; z-index: 999;
        background: rgba(0, 212, 255, 0.05); border: 1px solid var(--c-fortis);
        color: var(--c-fortis); padding: 8px; font-family: 'Consolas', monospace;
        font-size: 9px; border-radius: 4px; pointer-events: none;
      }

      /* BOTONES NAVEGACIÓN */
      .btn-nav {
         background: #f8f9fa; border: 1px solid #e9ecef; color: #495057;
         font-weight: 700; padding: 10px; border-radius: 6px; margin-bottom: 5px;
         text-transform: uppercase; font-size: 0.7rem; text-align: left; width: 100%;
         transition: 0.2s;
      }
      .btn-nav:hover { background: #e9ecef; border-color: var(--c-fortis); }
      .selected-btn { background: var(--c-fortis) !important; color: white !important; border-color: var(--c-fortis) !important; }

      .btn-logout { margin-top: auto; background: white; border: 1px solid #ffcccc; color: var(--c-logout); }
      .btn-logout:hover { background: var(--c-logout); color: white; border-color: var(--c-logout); }

      /* EFECTO HOVER EN IMÁGENES */
      .img-card {
        width: 120px; height: 120px; object-fit: cover; border-radius: 8px;
        border: 1px solid #ddd; transition: 0.3s ease; cursor: pointer;
      }
      .img-card:hover { transform: scale(1.15); border-color: var(--c-fortis); z-index: 100; box-shadow: 0 10px 20px rgba(0,0,0,0.2); }

      /* TEXTO DESCRIPTIVO */
      .desc-text {
        margin-top: 25px; color: #666; font-size: 0.9rem; line-height: 1.4;
        padding: 0 15px; font-style: italic;
      }

      /* FOOTER */
      .footer-area {
        height: 25vh; width: 100vw; display: flex; align-items: center; justify-content: center;
        background: #fff; border-top: 1px solid #eee;
      }
      .footer-text { font-family: var(--f-header); letter-spacing: 10px; color: #eee; margin: 0; font-size: 2rem; }

      .container-fluid { padding: 0 !important; }
    "))),

    div(class = "main-body",
        uiOutput(ns("debug_overlay")),

        # COLUMNA 1: NAVIGATION
        div(class = "panel-left",
            tags$h6("SYSTEM MODULES", style="color:#adb5bd; font-weight:800; margin-bottom:25px; margin-top:40px;"),
            lapply(seq_along(cat_ids), function(i) {
              actionButton(ns(paste0("btn_", cat_ids[i])), cat_labels[i], class = "btn-nav")
            }),
            actionButton(ns("btn_logout"), "LOGOUT / BACK", icon = icon("power-off"), class = "btn-nav btn-logout")
        ),

        # COLUMNA 2: LAUNCHER + DESCRIPCIÓN
        div(class = "panel-center",
            navset_hidden(
              id = ns("nav_center"),
              nav_panel_hidden("init",
                               div(style="text-align:center; padding-top:60px; opacity:0.2;",
                                   icon("terminal", class="fa-4x"),
                                   p(cat_descriptions["init"], style="font-weight:700; margin-top:10px;"))
              ),
              !!!lapply(2:length(cat_ids), function(i) {
                nav_panel_hidden(cat_ids[i],
                                 div(style="text-align:center; height:100%; display:flex; flex-direction:column; justify-content:center;",
                                     tags$h1("FORTIS", style="font-weight:900; margin:0; font-family: var(--f-header); font-size: 3rem;"),
                                     tags$div(cat_labels[i], style="color: var(--c-fortis); font-weight:800; text-transform: uppercase; letter-spacing: 2px;"),
                                     hr(style="width:40%; margin:20px auto;"),
                                     actionButton(ns(paste0("launch_", cat_ids[i])), "INITIALIZE",
                                                  style="background: black; color: white; font-family: var(--f-header); border: none; padding: 10px 40px;"),
                                     # AQUÍ EL TEXTO DEBAJO DEL BOTÓN
                                     div(class = "desc-text", cat_descriptions[cat_ids[i]])
                                 )
                )
              })
            )
        ),

        # COLUMNA 3: REPOSITORY
        div(class = "panel-right",
            navset_hidden(
              id = ns("nav_right"),
              nav_panel_hidden("init",
                               div(h2("Repository Area", style="font-family: var(--f-header); opacity:0.5;"),
                                   p("Select a system module from the left to explore resources."))),
              !!!lapply(2:length(cat_ids), function(i) {
                nav_panel_hidden(cat_ids[i],
                                 h3(cat_labels[i], style="font-family: var(--f-header); margin-bottom:20px; border-bottom: 2px solid #eee; padding-bottom:10px;"),
                                 div(style = "display: flex; flex-wrap: wrap; gap: 15px;",
                                     if(!is.null(www_path)) {
                                       files <- list.files(file.path(www_path, cat_ids[i]), pattern = "\\.(png|jpg|jpeg|webp)$", ignore.case = TRUE)
                                       if(length(files) > 0) {
                                         addResourcePath(cat_ids[i], file.path(www_path, cat_ids[i]))
                                         lapply(files, function(f) tags$img(src = paste0(cat_ids[i], "/", f), class = "img-card"))
                                       } else {
                                         p("No resource files found in this directory.", style="font-style:italic; color:#bbb;")
                                       }
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
    cat_ids <- c("init", "pack01_history", "pack02_sparring", "pack03_forms",
                 "pack04_refereeing", "pack05_graduations", "fn05_tkd")

    current_cat <- reactiveVal("init")
    target_page <- reactiveVal(NULL)
    launcher_state <- reactiveValues(time = NULL, count = 0)

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

    observeEvent(input$btn_logout, { target_page("page_home") })

    output$debug_overlay <- renderUI({
      req(debug)
      time_string <- if (is.null(launcher_state$time)) "N/A" else format(launcher_state$time, "%H:%M:%S")
      div(class = "debug-console",
          div(style = "font-weight: 800; border-bottom: 1px solid var(--c-fortis); margin-bottom: 5px;", "Fortis Core System"),
          div(paste("ACTIVE MODULE :", current_cat())),
          div(paste("LAST TRIGGER  :", time_string)),
          div(paste("INTERFACE     : OPTIONS_MODE"))
      )
    })

    return(list(
      goto = reactive({ target_page() }),
      active_tab = reactive({ current_cat() }),
      reset = function() { target_page(NULL) }
    ))
  })
}
