# ==============================================================================
# MÓDULO 00: DYNAMIC BACKGROUND (CARRUSELES)
# ==============================================================================

# ------------------------------------------------------------------------------
# UI: Renderizado del fondo y estilos CSS
# ------------------------------------------------------------------------------
mod_00_background_ui <- function(id) {
  ns <- NS(id)

  # --- Gestión Automatizada de Recursos ---
  find_tkd_path <- function() {
    # Busca la carpeta de imágenes en las rutas estándar de Shiny/Packages
    posibles <- system.file("www", "fn05_tkd", package="FORTIS")
    posibles <- normalizePath(posibles)

    # posibles <- c("www/fn05_tkd", "inst/www/fn05_tkd", "fn05_tkd")
    for (p in posibles) if (dir.exists(p)) return(p)
    return(NULL)
  }

  path_fn05 <- find_tkd_path()

  if (!is.null(path_fn05)) {
    # Mapeamos el recurso con un nombre único para evitar colisiones
    addResourcePath(ns("tkd_bg_res"), path_fn05)
    tkd_files <- list.files(path_fn05,
                            pattern = "\\.(png|jpg|jpeg|webp)$",
                            ignore.case = TRUE)
  } else {
    tkd_files <- character(0)
  }

  tagList(
    tags$style(HTML(paste0("
      /* Contenedor Raíz: Fijo detrás de toda la interfaz */
      #", ns("bg_wrapper"), " {
        position: fixed;
        top: 0;
        left: 0;
        width: 100vw;
        height: 100vh;
        background: #000;
        z-index: 0;
        overflow: hidden;
        pointer-events: none;
      }

      /* Overlay para controlar opacidad general del fondo */
      #", ns("bg_wrapper"), " .carousel-overlay {
        position: absolute;
        inset: 0;
        display: flex;
        flex-direction: column;
        justify-content: space-around;
        opacity: 0.3;
        z-index: 1;
        transition: opacity 1s ease;
      }

      /* Estructura de Filas de Imágenes */
      #", ns("bg_wrapper"), " .track-row {
        width: 100%;
        overflow: hidden;
        white-space: nowrap;
      }

      #", ns("bg_wrapper"), " .track-content {
        display: inline-flex;
        width: max-content;
      }

      #", ns("bg_wrapper"), " .track-content img {
        height: 13vh;
        margin-right: 12px;
        border-radius: 4px;
        filter: brightness(0.8);
      }

      /* Keyframes para el scroll infinito (Seamless) */
      @keyframes ", ns("scroll_left_bg"), " {
        0% { transform: translateX(0); }
        100% { transform: translateX(-50%); }
      }

      #", ns("bg_wrapper"), " .anim-slow {
        animation: ", ns("scroll_left_bg"), " 160s linear infinite;
      }

      #", ns("bg_wrapper"), " .anim-fast {
        animation: ", ns("scroll_left_bg"), " 110s linear infinite;
      }
    "))),

    div(id = ns("bg_wrapper"),
        div(class = "carousel-overlay",
            lapply(1:7, function(i) {
              if(length(tkd_files) > 0) {
                # Aleatorizar imágenes por fila
                pool_imgs <- sample(tkd_files)
                # Asegurar suficientes elementos para el ancho de pantalla
                if(length(pool_imgs) < 15) pool_imgs <- rep(pool_imgs, 3)

                # Duplicamos el pool para crear el bucle infinito visual
                display_pool <- c(pool_imgs, pool_imgs)

                div(class = "track-row",
                    div(class = paste0("track-content ", ifelse(i %% 2 == 0, "anim-slow", "anim-fast")),
                        lapply(display_pool, function(img_name) {
                          tags$img(src = paste0(ns("tkd_bg_res"), "/", img_name))
                        })
                    )
                )
              } else {
                div(style="color: #222; font-family: Impact; font-size: 2rem; text-align:center;", "ASSETS NOT FOUND")
              }
            })
        )
    )
  )
}

# ------------------------------------------------------------------------------
# SERVER: Control de estado y lógica del fondo
# ------------------------------------------------------------------------------
mod_00_background_server <- function(id, debug = TRUE) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Estado reactivo por si se desea controlar desde el exterior
    bg_state <- reactiveValues(
      opacity = 0.3,
      speed = 1
    )

    if(debug) {
      observe({
        cat(paste0("[MOD_00] Background Engine Initialized on ID: ", id, "\n"))
      })
    }

    # Retorno de funciones de control (API del módulo)
    return(list(
      update_opacity = function(val) { bg_state$opacity <- val },
      update_speed   = function(val) { bg_state$speed <- val }
    ))
  })
}

# ------------------------------------------------------------------------------
# TEST APP: Sentencias de ejecución stand-alone
# ------------------------------------------------------------------------------
# if (interactive()) {
#   library(shiny)
#
#   ui <- fluidPage(
#     tags$head(
#       tags$style(HTML("body, html { margin: 0; padding: 0; background: #000; overflow: hidden; }"))
#     ),
#
#     # Capa de Fondo
#     mod_00_background_ui("bg_standalone"),
#
#     # Capa de Contenido (Prueba de transparencia)
#     div(style = "position: relative; z-index: 100; color: white; text-align: center; padding-top: 40vh; pointer-events: none;",
#         h1("FORTIS BACKGROUND SYSTEM", style = "font-family: 'Impact'; font-size: 4rem; letter-spacing: 15px;"),
#         p("STAND-ALONE MODULE RUNNING", style = "letter-spacing: 5px; color: #00f2fe;")
#     )
#   )
#
#   server <- function(input, output, session) {
#     mod_00_background_server("bg_standalone", debug = TRUE)
#   }
#
#   shinyApp(ui, server)
# }
