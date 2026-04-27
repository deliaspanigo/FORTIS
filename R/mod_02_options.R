# ==============================================================================
# MÓDULO 02: OPTIONS (LAUNCHER) - MUESTREO DE 20 IMÁGENES POR FILA
# ==============================================================================

mod_02_options_ui <- function(id) {
  ns <- NS(id)

  cat_ids <- c("init", "pack01_history", "pack02_sparring", "pack03_forms",
               "pack04_refereeing", "pack05_graduations", "fn05_tkd")
  cat_labels <- c("Welcome", "History", "Sparring", "Forms",
                  "Refereeing", "Graduations", "Fortis Engine")

  cat_descriptions <- c(
    "init" = "Awaiting selection...",
    "pack01_history" = "Explora los orígenes, la filosofía y la evolución del Taekwondo a través del tiempo.",
    "pack02_sparring" = "Workshop de combate: Tácticas, análisis de distancia y entrenamiento de alta intensidad.",
    "pack03_forms" = "Perfeccionamiento técnico de Poomsae: Precisión, equilibrio y control de la energía.",
    "pack04_refereeing" = "Reglamentación oficial y criterios de puntuación para arbitraje internacional.",
    "pack05_graduations" = "Guía completa de requisitos y programas para exámenes de pase de grado.",
    "fn05_tkd" = "Fortis Engine: Procesamiento de datos y analítica avanzada aplicada al alto rendimiento deportivo."
  )

  tagList(
    useShinyjs(),
    tags$style(HTML(paste0("
      #fortis-mod-02-root {
        margin: 0; padding: 0; height: 100vh; width: 100vw;
        overflow: hidden; background: #000; display: flex; flex-direction: column;
      }

      #fortis-mod-02-root .main-body { display: flex; height: 75vh; width: 100vw; background: #fff; font-family: 'Segoe UI', sans-serif; }
      #fortis-mod-02-root .panel-left { flex: 0 0 20%; padding: 15px; border-right: 1px solid #f0f0f0; display: flex; flex-direction: column; background: #fff; z-index: 10; }
      #fortis-mod-02-root .panel-center { flex: 0 0 20%; padding: 15px; border-right: 2px solid #00f2fe; text-align: center; z-index: 10; background: #fff; }
      #fortis-mod-02-root .panel-right { flex: 0 0 60%; padding: 0; background: #000; overflow: hidden; display: flex; flex-direction: column; justify-content: space-around; }

      #fortis-mod-02-root .track-row { width: 100%; overflow: hidden; white-space: nowrap; border-bottom: 1px solid #111; }
      #fortis-mod-02-root .track-content { display: inline-flex; width: max-content; animation: ", ns("scroll_left_02"), " linear infinite; }

      #fortis-mod-02-root .track-content img { height: 14vh; width: 220px; object-fit: cover; margin-right: 10px; border-radius: 4px; filter: grayscale(50%); transition: 0.4s; }
      #fortis-mod-02-root .track-content img:hover { filter: grayscale(0%); transform: scale(1.05); }

      @keyframes ", ns("scroll_left_02"), " { 0% { transform: translateX(0); } 100% { transform: translateX(-50%); } }

      #fortis-mod-02-root .btn-nav { background: #f8f9fa; border: 1px solid #e9ecef; font-weight: 700; padding: 10px; margin-bottom: 5px; font-size: 0.7rem; width: 100%; text-align: left; transition: 0.2s; }
      #fortis-mod-02-root .selected-btn { background: #00f2fe !important; color: #000 !important; border-color: #00f2fe !important; }
      #fortis-mod-02-root .btn-logout { margin-top: auto; color: #ff4d4d; border-color: #ffcccc; font-weight: 800; }
      #fortis-mod-02-root .desc-text { margin-top: 25px; color: #666; font-size: 0.85rem; font-style: italic; padding: 0 10px; line-height: 1.3; }

      #fortis-mod-02-root .footer-area { height: 25vh; width: 100vw; display: flex; align-items: center; justify-content: center; border-top: 1px solid #eee; background: #fff; }
      #fortis-mod-02-root .footer-text { font-family: 'Impact', sans-serif; letter-spacing: 10px; color: #eee; font-size: 2rem; margin:0; }
    "))),

    div(id = "fortis-mod-02-root",
        div(class = "main-body",
            div(class = "panel-left",
                tags$h6("SYSTEM MODULES", style="color:#adb5bd; font-weight:800; margin: 40px 0 25px 0;"),
                lapply(seq_along(cat_ids), function(i) actionButton(ns(paste0("btn_", cat_ids[i])), cat_labels[i], class = "btn-nav")),
                actionButton(ns("btn_logout"), "BACK / LOGOUT", icon = icon("power-off"), class = "btn-nav btn-logout")
            ),

            div(class = "panel-center",
                navset_hidden(
                  id = ns("nav_center"),
                  nav_panel_hidden("init", div(style="padding-top:60px; opacity:0.2;", icon("terminal", "fa-4x"), p("Awaiting..."))),
                  !!!lapply(2:length(cat_ids), function(i) {
                    nav_panel_hidden(cat_ids[i],
                                     div(style="height:100%; display:flex; flex-direction:column; justify-content:center;",
                                         h1("FORTIS", style="font-weight:900; font-family: 'Impact', sans-serif; font-size: 2.5rem; margin:0;"),
                                         div(cat_labels[i], style="color: #00b4d8; font-weight:800; letter-spacing: 2px;"),
                                         hr(style="width:40%; margin:20px auto;"),
                                         actionButton(ns(paste0("launch_", cat_ids[i])), "INITIALIZE", style="background: black; color: white; padding: 10px 40px; border:none; font-family: 'Impact', sans-serif;"),
                                         div(class = "desc-text", cat_descriptions[cat_ids[i]])
                                     )
                    )
                  })
                )
            ),

            div(class = "panel-right",
                uiOutput(ns("repository_ui"))
            )
        ),
        div(class = "footer-area", tags$h4(class="footer-text", "CITIUS • ALTIUS • FORTIUS"))
    )
  )
}

mod_02_options_server <- function(id, debug = TRUE) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    cat_ids <- c("init", "pack01_history", "pack02_sparring", "pack03_forms", "pack04_refereeing", "pack05_graduations", "fn05_tkd")
    current_cat <- reactiveVal("init")
    target_page <- reactiveVal(NULL)

    output$repository_ui <- renderUI({
      cat <- current_cat()
      if(cat == "init") return(div(style="color:#333; padding:40px; text-align:center; opacity:0.1;", icon("shield-alt", "fa-5x")))

      # Resolución de ruta
      www_path <- "www"
      if (!dir.exists(www_path)) www_path <- system.file("www", package = "FORTIS")
      path_cat <- file.path(www_path, cat)

      files <- list.files(path_cat, pattern = "\\.(png|jpg|jpeg|webp)$", ignore.case = TRUE)
      if(length(files) == 0) return(NULL)

      addResourcePath(cat, path_cat)

      # --- LÓGICA DE MUESTREO: 20 IMÁGENES POR FILA (100 TOTAL) ---
      total_needed <- 100
      n_available <- length(files)

      if(n_available >= total_needed) {
        # Si sobran imágenes, tomamos 100 únicas
        master_pool <- sample(files, total_needed, replace = FALSE)
      } else {
        # Si faltan, tomamos todas las únicas y rellenamos con repetición el resto
        master_pool <- c(files, sample(files, total_needed - n_available, replace = TRUE))
        master_pool <- sample(master_pool) # Mezclar para que no queden las repetidas al final
      }

      # Parámetros de velocidad
      sec_per_img_fast <- 5
      sec_per_img_slow <- 9

      tagList(
        lapply(1:5, function(row_idx) {
          # Extraer segmento de 20 imágenes para esta fila
          start_idx <- ((row_idx - 1) * 20) + 1
          end_idx <- row_idx * 20
          row_base <- master_pool[start_idx:end_idx]

          # Duplicamos para el efecto de scroll infinito (CSS requiere n + n)
          full_track <- c(row_base, row_base)

          # Cálculo de duración lineal basado en 40 imágenes totales (20 base + 20 clonadas)
          speed_val <- if(row_idx %% 2 == 0) sec_per_img_slow else sec_per_img_fast
          duration_val <- (length(full_track) * speed_val) / 2

          div(class = "track-row",
              div(class = "track-content",
                  style = paste0("animation-duration: ", duration_val, "s;"),
                  lapply(full_track, function(f) tags$img(src = paste0(cat, "/", f)))
              )
          )
        })
      )
    })

    lapply(cat_ids, function(cat) {
      observeEvent(input[[paste0("btn_", cat)]], {
        current_cat(cat)
        nav_select("nav_center", cat)
        lapply(cat_ids, function(id) shinyjs::removeClass(paste0("btn_", id), "selected-btn"))
        shinyjs::addClass(paste0("btn_", cat), "selected-btn")
      })
    })

    observeEvent(input$btn_logout, { target_page("page_home") })

    return(list(
      goto = reactive({ target_page() }),
      reset = function() { target_page(NULL) }
    ))
  })
}
