library(shiny)
library(shinyjs)

# ==============================================================================
# MÓDULO 01: HOME (FORTIS) - VERSIÓN FINAL CON ELEMENTOS OLÍMPICOS
# ==============================================================================

mod_01_home_ui <- function(id) {
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
    addResourcePath("tkd_imgs_home", file.path(path_www, "fn05_tkd"))
    addResourcePath("home_assets_home", file.path(path_www, "fn10_home"))
    tkd_files <- list.files(file.path(path_www, "fn05_tkd"),
                            pattern = "\\.(png|jpg|jpeg|webp)$",
                            ignore.case = TRUE)
  } else { tkd_files <- character(0) }

  tagList(
    useShinyjs(),
    tags$head(
      tags$style(HTML(paste0("
        :root {
          --f-header: 'Impact', sans-serif;
          --c-fortis: #00f2fe;
        }

        body, .container-fluid { padding: 0 !important; margin: 0 !important; background: #000; overflow: hidden; }

        .home-main-container {
          width: 100vw; height: 100vh; position: relative; display: flex; flex-direction: column; overflow: hidden;
          background: #000;
        }

        /* CAPA 1: BANDA DE FONDO */
        .bg-flag {
          position: absolute;
          inset: 0;
          width: 100%;
          height: 100%;
          object-fit: contain;
          z-index: 10;
          opacity: 1 !important;
          visibility: visible !important;
          pointer-events: none;
        }

        /* CAPA 2: CARRUSELES */
        .carousel-overlay {
          position: absolute;
          inset: 0;
          display: flex;
          flex-direction: column;
          justify-content: space-around;
          z-index: 5;
          padding: 1vh 0;
        }

        .track-row { width: 100%; overflow: hidden; white-space: nowrap; }
        .track-content { display: inline-flex; width: max-content; }
        .track-content img { height: 13vh; margin-right: 10px; border-radius: 5px; opacity: 0.8; }

        /* CAPA 3: UI PRINCIPAL */
        .ui-foreground {
          position: relative;
          z-index: 100;
          height: 100%;
          width: 100%;
          display: flex;
          flex-direction: column;
          align-items: center;
          justify-content: center;
          background: transparent;
        }

        .title-text {
          font-family: var(--f-header);
          font-size: 9rem;
          color: white;
          margin: 0;
          letter-spacing: -2px;
          text-shadow: 0px 0px 20px rgba(0,0,0,1);
        }

        .btn-enter {
          margin-top: 30px;
          border: 3px solid var(--c-fortis);
          background: rgba(0,0,0,0.8);
          color: white;
          padding: 15px 50px;
          font-family: var(--f-header);
          font-size: 1.8rem;
          cursor: pointer;
          transition: 0.3s;
          z-index: 110;
        }
        .btn-enter:hover { background: var(--c-fortis); color: black; box-shadow: 0 0 30px var(--c-fortis); }

        /* FOOTER OLÍMPICO */
        .footer-olympic {
          position: absolute;
          bottom: 30px;
          display: flex;
          flex-direction: column;
          align-items: center;
          z-index: 110;
        }

        .olympic-logo { width: 180px; margin-bottom: 10px; opacity: 0.9; }

        .latin-quote {
          color: white;
          font-family: var(--f-header);
          font-size: 1.6rem;
          letter-spacing: 5px;
          text-shadow: 2px 2px 4px rgba(0,0,0,0.8);
        }

        @keyframes ", ns("scroll_left"), " { 0% { transform: translateX(0); } 100% { transform: translateX(-50%); } }
        .anim-slow { animation: ", ns("scroll_left"), " 180s linear infinite; }
        .anim-fast { animation: ", ns("scroll_left"), " 120s linear infinite; }
      ")))
    ),

    div(class = "home-main-container",
        # 1. Carruseles (Fondo real)
        div(class = "carousel-overlay",
            lapply(1:7, function(i) {
              if(length(tkd_files) > 0) {
                pool <- rep(sample(tkd_files), 5)
                div(class = "track-row",
                    div(class = paste0("track-content ", ifelse(i %% 2 == 0, "anim-slow", "anim-fast")),
                        lapply(pool, function(img) tags$img(src = paste0("tkd_imgs_home/", img)))
                    )
                )
              }
            })
        ),

        # 2. Bandera (Tapando carruseles)
        tags$img(src = "home_assets_home/flag_korea_south_transparent.png", class = "bg-flag"),

        # 3. UI Principal
        div(class = "ui-foreground",
            h1(class = "title-text", "FORTIS"),
            actionButton(ns("enter_btn"), "ENTRAR", class = "btn-enter"),

            # Logo y Frase (Integrados en el foreground para solidez)
            div(class = "footer-olympic",
                tags$img(src = "home_assets_home/olympic_ring_transparent_png.png", class = "olympic-logo"),
                div(class = "latin-quote", "CITIUS • ALTIUS • FORTIUS • COMMUNITER")
            )
        )
    )
  )
}

mod_01_home_server <- function(id, debug = TRUE) {
  moduleServer(id, function(input, output, session) {
    click_data <- reactiveValues(status = FALSE, time = NULL)
    observeEvent(input$enter_btn, {
      click_data$status <- TRUE
      click_data$time <- Sys.time()
    })
    output$debug_overlay <- renderUI({
      req(debug)
      div(style="position:absolute; top:10px; left:10px; z-index:999; color:#00f2fe; font-family:monospace; font-size:10px;",
          "HOME_MODE: ACTIVE")
    })
    return(list(clicked = reactive({ click_data$status })))
  })
}
