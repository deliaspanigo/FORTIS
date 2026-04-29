# ==============================================================================
# MÓDULO 02: OPTIONS - FIX HOVER EN OPCIÓN SELECCIONADA
# ==============================================================================

# ==============================================================================
# MÓDULO 02: OPTIONS (LAUNCHER) - VERSIÓN FINAL CONSOLIDADA
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
    vector_top_files <- list.files(file.path(path_www, "fn01_top_img"),
                                   pattern = "\\.(png|jpg|jpeg|webp)$",
                                   ignore.case = TRUE)
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
      :root {
        --fortis-border-width: 6px;
        --fortis-blue-electric: #0044ff; /* Azul para el borde */
        --fortis-red-electric:  #ff0000; /* Rojo para el borde */
        --fortis-cyan:          #00ffff; /* Cyan para texto y botones */
      }

      #", ns("options_container"), " {
        width: 100vw; height: 100vh; position: relative;
        display: flex; flex-direction: column; overflow: hidden;
        background: transparent !important;
      }

      .bg-overlay-opts {
        position: absolute; inset: 0; background: ", bg_color, "; opacity: ", bg_opacity, "; z-index: 1;
      }

      /* --- CUERPO CON EFECTO SNAKE --- */
      .options-body {
        position: relative;
        z-index: 100;
        display: flex;
        width: 92vw;
        margin: 16vh auto 0 auto;
        height: 68vh;
        padding: var(--fortis-border-width);
        background: transparent;
        border-radius: 20px;
        overflow: hidden;
      }

      .options-body::before {
        content: '';
        position: absolute;
        inset: -150%;
        background: conic-gradient(
          from 0deg,
          var(--fortis-blue-electric) 0deg,
          var(--fortis-blue-electric) 180deg,
          var(--fortis-red-electric) 180deg,
          var(--fortis-red-electric) 360deg
        );
        animation: ", ns("rotate_snake"), " 10s cubic-bezier(0.68, -0.55, 0.27, 1.55) infinite;
        z-index: 50;
      }

      .options-body::after {
        content: '';
        position: absolute;
        inset: var(--fortis-border-width);
        background: #000;
        border-radius: 16px;
        z-index: 60;
      }

      .panel-container {
         display: flex;
         width: 100%;
         height: 100%;
         position: relative;
         z-index: 200;
         border-radius: 15px;
         overflow: hidden;
      }

      @keyframes ", ns("rotate_snake"), " {
        from { transform: rotate(0deg); }
        to { transform: rotate(360deg); }
      }

      /* --- PANELES --- */
      .panel-left {
        flex: 0 0 20%; padding: 25px; display: flex; flex-direction: column;
        background: rgba(5,5,5,0.9); backdrop-filter: blur(15px); border-right: 1px solid #222;
      }

      .panel-center {
        flex: 0 0 25%; padding: 30px; text-align: center; color: white;
        background: rgba(10,10,10,0.95); border-right: 1px solid #222;
        display: flex; flex-direction: column; justify-content: center;
      }

      .panel-right {
        flex: 0 0 55%; padding: 0; background: rgba(0,0,0,0.6); overflow: hidden;
        display: flex; flex-direction: column; justify-content: space-around;
      }

      /* --- BOTONES DINÁMICOS --- */
      .btn-nav {
        background: transparent;
        border: 1px solid var(--fortis-cyan);
        color: var(--fortis-cyan) !important;
        font-weight: 700; padding: 12px; margin-bottom: 10px; font-size: 0.75rem;
        width: 100%; text-align: left;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        border-radius: 4px;
        position: relative;
        left: 0;
      }

      .btn-nav:not(.selected-btn):hover {
        background: rgba(0, 255, 255, 0.1);
        box-shadow: 0 0 10px rgba(0, 255, 255, 0.2);
        color: #fff !important;
      }

      .selected-btn, .selected-btn:hover {
        background: var(--fortis-cyan) !important;
        color: #000 !important;
        border-color: var(--fortis-cyan) !important;
        transform: translateX(15px);
        box-shadow: 0 0 20px rgba(0, 255, 255, 0.5);
      }

      .btn-logout {
        margin-top: auto; color: #ff4d4d !important; border: 1px solid #400 !important;
        background: #100; transform: none !important;
      }

      /* --- CARRUSELES --- */
      .track-row { width: 100%; overflow: hidden; white-space: nowrap; border-bottom: 1px solid #111; }

      .track-content {
        display: inline-flex;
        width: max-content;
        animation-name: ", ns("scroll_left_02"), ";
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-duration: 20s;
      }

      .track-content img { height: 13.5vh; width: 220px; object-fit: cover; margin-right: 10px; border-radius: 4px; }

      @keyframes ", ns("scroll_left_02"), " {
        0% { transform: translateX(0); }
        100% { transform: translateX(-50%); }
      }

      .top-logos-static {
        position: absolute; top: 40px; left: 0; width: 100%; height: 8vh;
        z-index: 150; display: flex; justify-content: center; align-items: center; gap: 50px;
      }
      .top-logos-static img { height: 6vh; width: auto; }

      .global-footer {
        position: absolute; bottom: 50px; left: 50%; transform: translateX(-50%);
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
            div(class = "panel-container",
                div(class = "panel-left",
                    tags$h6("RESOURCES", style="color:#444; font-weight:800; margin-bottom:20px; letter-spacing:3px;"),
                    lapply(seq_along(cat_ids), function(i) {
                      actionButton(ns(paste0("btn_", cat_ids[i])), cat_labels[i], class = "btn-nav")
                    }),
                    actionButton(ns("btn_logout"), "BACK / EXIT", icon = icon("power-off"), class = "btn-nav btn-logout")
                ),
                div(class = "panel-center", uiOutput(ns("center_ui"))),
                div(class = "panel-right", uiOutput(ns("repository_ui")))
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

    # --- CAMBIO: Sparring como selección por defecto ---
    current_sel <- reactiveVal("pack02_sparring")  # Antes era "init"
    final_val   <- reactiveVal(NULL)

    # --- Aplicar la clase 'selected-btn' al botón de Sparring al iniciar ---
    observe({
      # Pequeño delay para asegurar que los botones están renderizados
      shinyjs::runjs(paste0("
        setTimeout(function() {
          var sparringBtn = document.getElementById('", ns("btn_pack02_sparring"), "');
          if(sparringBtn) {
            sparringBtn.classList.add('selected-btn');
          }
        }, 100);
      "))
    })

    output$center_ui <- renderUI({
      sel <- current_sel()
      # Ya no mostramos el mensaje de "Awaiting selection..." porque siempre hay algo seleccionado

      tagList(
        h1("FORTIS", style="font-weight:900; font-family: 'Impact'; font-size: 3.2rem; margin:0;"),
        h1("-TKD-",  style="font-weight:900; font-family: 'Impact'; font-size: 1.2rem; margin:0;"),

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
      # Ya no necesitamos el caso "init" porque siempre hay una categoría seleccionada

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

# if (interactive()) {
#   library(shiny)
#   library(shinyjs)
#   ui <- fluidPage(mod_02_options_ui("test", bg_color = "#000", bg_opacity = 1))
#   server <- function(input, output, session) { mod_02_options_server("test") }
#   shinyApp(ui, server)
# }
