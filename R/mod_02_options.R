# ==============================================================================
# MÓDULO 02: OPTIONS (LAUNCHER) - VERSIÓN ORIGINAL RESTAURADA CON PADDING LATERAL
# ==============================================================================

mod_02_options_ui <- function(id, bg_color = "#000", bg_opacity = 0) {
  ns <- NS(id)

  # --- Gestión de Recursos ---
  find_www <- function() {
    posibles <- system.file("www", package = "FORTIS")
    if (posibles == "") {
      for (r in c("inst/www", "www")) if (dir.exists(r)) return(r)
    }
    return(posibles)
  }

  path_www <- find_www()
  if(!is.null(path_www) && path_www != "") {
    addResourcePath("top_img_opts", file.path(path_www, "fn01_top_img"))
    addResourcePath("home_assets_opts", file.path(path_www, "fn10_home"))
    vector_top_files <- list.files(file.path(path_www, "fn01_top_img"), pattern = "\\.(png|jpg|jpeg|webp)$", ignore.case = TRUE)
  } else {
    vector_top_files <- character(0)
  }

  cat_ids <- c("init", "pack01_history", "pack02_sparring", "pack03_forms",
               "pack04_refereeing", "pack05_graduations", "fn05_tkd")
  cat_labels <- c("Welcome", "History", "Sparring", "Forms",
                  "Refereeing", "Graduations", "Fortis Engine")

  tagList(
    useShinyjs(),
    tags$style(HTML(paste0("
      #", ns("options_container"), " {
        width: 100vw; height: 100vh; position: relative;
        display: flex; flex-direction: column; overflow: hidden;
        background: transparent !important;
      }

      .bg-overlay-opts {
        position: absolute; inset: 0; background: ", bg_color, "; opacity: ", bg_opacity, "; z-index: 1;
      }

      .top-logos-static {
        position: absolute; top: 30px; left: 0; width: 100%; height: 8vh;
        z-index: 150; display: flex; justify-content: center; align-items: center; gap: 50px;
      }
      .top-logos-static img { height: 6vh; width: auto; }

      /* AJUSTE DE PADDING LATERAL EN EL BODY */
      .options-body {
        position: relative; z-index: 100;
        display: flex;
        width: 96vw;             /* Reducido para dar aire a los lados */
        margin: 15vh auto 0 auto; /* Centrado horizontalmente */
        height: 70vh;
      }

      .panel-left {
        flex: 0 0 20%; padding: 25px; display: flex; flex-direction: column;
        background: rgba(5,5,5,0.7); backdrop-filter: blur(10px);
        border-right: 1px solid #1a1a1a;
        border-radius: 15px 0 0 15px; /* Bordes redondeados a la izquierda */
      }

      .panel-center {
        flex: 0 0 25%; padding: 30px; text-align: center; color: white;
        background: rgba(10,10,10,0.8); border-right: 2px solid #00f2fe;
        display: flex; flex-direction: column; justify-content: center;
      }

      .panel-right {
        flex: 0 0 55%; padding: 0; background: rgba(0,0,0,0.4); overflow: hidden;
        display: flex; flex-direction: column; justify-content: space-around;
        border-radius: 0 15px 15px 0; /* Bordes redondeados a la derecha */
      }

      .btn-nav {
        background: #111; border: 1px solid #222; color: #666;
        font-weight: 700; padding: 12px; margin-bottom: 8px; font-size: 0.75rem;
        width: 100%; text-align: left; transition: all 0.3s ease;
      }
      .selected-btn {
        background: #00f2fe !important; color: #000 !important; border-color: #00f2fe !important;
        box-shadow: 0 0 15px rgba(0, 242, 254, 0.4);
      }
      .btn-logout { margin-top: auto; color: #ff4d4d !important; border: 1px solid #400 !important; background: #100; }

      .track-row { width: 100%; overflow: hidden; white-space: nowrap; border-bottom: 1px solid #111; }
      .track-content { display: inline-flex; width: max-content; animation: ", ns("scroll_left_02"), " linear infinite; }
      .track-content img { height: 14vh; width: 220px; object-fit: cover; margin-right: 10px; border-radius: 4px; }

      @keyframes ", ns("scroll_left_02"), " { 0% { transform: translateX(0); } 100% { transform: translateX(-50%); } }

      .global-footer {
        position: absolute; bottom: 40px; left: 50%; transform: translateX(-50%);
        display: flex; flex-direction: column; align-items: center; z-index: 200;
      }
      .latin-quote { color: white; font-family: 'Impact'; font-size: 1.2rem; letter-spacing: 5px; text-shadow: 1px 1px 5px black;}
    "))),

    div(id = ns("options_container"),
        div(class = "bg-overlay-opts"),

        div(class = "top-logos-static",
            lapply(vector_top_files, function(img) {
              tags$img(src = paste0("top_img_opts/", img))
            })
        ),

        div(class = "options-body",
            div(class = "panel-left",
                tags$h6("SYSTEM MODULES", style="color:#333; font-weight:800; margin-bottom:20px; letter-spacing:3px;"),
                lapply(seq_along(cat_ids), function(i) actionButton(ns(paste0("btn_", cat_ids[i])), cat_labels[i], class = "btn-nav")),
                actionButton(ns("btn_logout"), "BACK / LOGOUT", icon = icon("power-off"), class = "btn-nav btn-logout")
            ),

            div(class = "panel-center",
                uiOutput(ns("center_ui"))
            ),

            div(class = "panel-right",
                uiOutput(ns("repository_ui"))
            )
        ),

        div(class = "global-footer",
            tags$img(src = "home_assets_opts/olympic_ring_transparent_png.png", style="width:100px; margin-bottom:10px;"),
            div(class = "latin-quote", "CITIUS • ALTIUS • FORTIUS")
        )
    )
  )
}

mod_02_options_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    cat_ids <- c("init", "pack01_history", "pack02_sparring", "pack03_forms",
                 "pack04_refereeing", "pack05_graduations", "fn05_tkd")

    cat_labels <- setNames(c("Welcome", "History", "Sparring", "Forms", "Refereeing", "Graduations", "Fortis Engine"), cat_ids)

    cat_descriptions <- c(
      "init" = "Awaiting selection...",
      "pack01_history" = "Explora los orígenes, la filosofía y la evolución del Taekwondo a través del tiempo.",
      "pack02_sparring" = "Workshop de combate: Tácticas, análisis de distancia y entrenamiento de alta intensidad.",
      "pack03_forms" = "Perfeccionamiento técnico de Poomsae: Precisión, equilibrio y control de la energía.",
      "pack04_refereeing" = "Reglamentación oficial y criterios de puntuación para arbitraje internacional.",
      "pack05_graduations" = "Guía completa de requisitos y programas para exámenes de pase de grado.",
      "fn05_tkd" = "Fortis Engine: Procesamiento de datos y analítica avanzada aplicada al alto rendimiento deportivo."
    )

    current_sel <- reactiveVal("init")
    final_val   <- reactiveVal(NULL)

    output$center_ui <- renderUI({
      sel <- current_sel()
      if(sel == "init") return(div(style="opacity:0.2; padding-top:20px;", icon("shield-alt", "fa-5x"), p("READY")))

      tagList(
        h1("FORTIS", style="font-weight:900; font-family: 'Impact'; font-size: 3.2rem; margin:0;"),
        div(cat_labels[sel], style="color: #00f2fe; font-weight:800; letter-spacing: 4px; margin-bottom:10px;"),
        hr(style="width:50%; margin:15px auto; border-color:#333;"),
        div(style="margin-bottom:25px; color:#bbb; font-size:0.95rem; line-height:1.4; padding: 0 10px;",
            cat_descriptions[sel]),
        actionButton(ns(paste0("launch_", sel)), "INITIALIZE",
                     style="background:#00f2fe; color:black; font-family:'Impact'; padding:12px 45px; border:none; font-size:1.3rem; cursor:pointer;")
      )
    })

    output$repository_ui <- renderUI({
      cat <- current_sel()
      if(cat == "init") return(div(style="color:#111; padding-top:20vh; text-align:center;", icon("terminal", "fa-6x")))

      www_path <- "www"
      if (!dir.exists(www_path)) www_path <- system.file("www", package = "FORTIS")
      path_cat <- file.path(www_path, cat)
      files <- list.files(path_cat, pattern = "\\.(png|jpg|jpeg|webp)$", ignore.case = TRUE)

      if(length(files) == 0) return(NULL)
      addResourcePath(cat, path_cat)

      total_needed <- 100
      n_available <- length(files)
      master_pool <- if(n_available >= total_needed) sample(files, total_needed) else c(files, sample(files, total_needed - n_available, replace = TRUE))

      tagList(
        lapply(1:5, function(row_idx) {
          start_idx <- ((row_idx - 1) * 20) + 1
          row_base <- master_pool[start_idx:(row_idx * 20)]
          full_track <- c(row_base, row_base)
          duration_val <- (length(full_track) * (if(row_idx %% 2 == 0) 8 else 5)) / 2
          div(class = "track-row",
              div(class = "track-content", style = paste0("animation-duration: ", duration_val, "s;"),
                  lapply(full_track, function(f) tags$img(src = paste0(cat, "/", f)))
              )
          )
        })
      )
    })

    lapply(cat_ids, function(cat) {
      observeEvent(input[[paste0("btn_", cat)]], {
        current_sel(cat)
        lapply(cat_ids, function(id) shinyjs::removeClass(paste0("btn_", id), "selected-btn"))
        shinyjs::addClass(paste0("btn_", cat), "selected-btn")
      })

      observeEvent(input[[paste0("launch_", cat)]], { final_val(cat) })
    })

    observeEvent(input$btn_logout, { final_val("home") })

    return(list(value = final_val, reset = function() { final_val(NULL) }))
  })
}

if (interactive()) {
  library(shiny)
  library(shinyjs)
  ui <- fluidPage(mod_02_options_ui("test", bg_color = "#000", bg_opacity = 1))
  server <- function(input, output, session) { mod_02_options_server("test") }
  shinyApp(ui, server)
}
