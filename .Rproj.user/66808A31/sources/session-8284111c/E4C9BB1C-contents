library(shiny)
library(shinyjs)

# ==============================================================================
# MÓDULO 01: HOME (FORTIS) - VERSIÓN FINAL CON DEBUG OVERLAY
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
    addResourcePath("top_img_home", file.path(path_www, "fn01_top_img"))
    addResourcePath("tkd_imgs_home", file.path(path_www, "fn05_tkd"))
    addResourcePath("fortis_imgs", file.path(path_www, "fn08_fortis"))
    addResourcePath("home_assets_home", file.path(path_www, "fn10_home"))

    tkd_files <- list.files(file.path(path_www, "fn05_tkd"),
                            pattern = "\\.(png|jpg|jpeg|webp)$",
                            ignore.case = TRUE)

    vector_top_files  <- list.files(file.path(path_www, "fn01_top_img"),
                                    pattern = "\\.(png|jpg|jpeg|webp)$",
                                    ignore.case = TRUE)
  } else {
    tkd_files <- character(0)
    vector_top_files <- character(0)
  }

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

        /* --- BARRA DE LOGOS TOP --- */
        .top-logos-static {
          position: absolute;
          top: 30px;
          left: 0;
          width: 100%;
          height: 8vh;
          z-index: 150;
          background: transparent;
          display: flex;
          justify-content: center;
          align-items: center;
          gap: 50px;
        }

        .top-logos-static img {
          height: 6vh;
          width: auto;
          opacity: 1;
          transition: transform 0.3s ease;
        }

        .top-logos-static img:hover {
          transform: scale(1.3);
        }

        /* CAPA 1: BANDA DE FONDO */
        .bg-flag-static {
          position: absolute;
          inset: 0;
          width: 100%;
          height: 100%;
          object-fit: contain;
          z-index: 10;
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

        .logo-fortis-top { width: 160px; height: auto; margin-bottom: -5px; }

        .title-text {
          font-family: var(--f-header);
          font-size: 6.5rem;
          color: white;
          margin: 0;
          letter-spacing: -1px;
          text-shadow: 0px 0px 20px rgba(0,0,0,1);
          line-height: 0.9;
        }

        .btn-enter {
          margin-top: 20px;
          border: 2px solid var(--c-fortis);
          background: rgba(0,0,0,0.8);
          color: white;
          padding: 10px 40px;
          font-family: var(--f-header);
          font-size: 1.4rem;
          cursor: pointer;
          transition: 0.3s;
          z-index: 120;
        }
        .btn-enter:hover { background: var(--c-fortis); color: black; box-shadow: 0 0 25px var(--c-fortis); }

        .footer-olympic {
          position: absolute;
          bottom: 25px;
          display: flex;
          flex-direction: column;
          align-items: center;
          z-index: 110;
        }

        .olympic-logo { width: 130px; margin-bottom: 8px; }
        .latin-quote {
          color: white;
          font-family: var(--f-header);
          font-size: 1.2rem;
          letter-spacing: 4px;
        }

        /* ANIMACIONES FONDO */
        @keyframes ", ns("scroll_left"), " { 0% { transform: translateX(0); } 100% { transform: translateX(-50%); } }
        .anim-slow { animation: ", ns("scroll_left"), " 180s linear infinite; }
        .anim-fast { animation: ", ns("scroll_left"), " 120s linear infinite; }
      ")))
    ),

    div(class = "home-main-container",

        # Overlay de Debug (Igual al Módulo 02)
        uiOutput(ns("debug_overlay")),

        # Barra Superior de Logos
        div(class = "top-logos-static",
            lapply(vector_top_files, function(img) {
              tags$img(src = paste0("top_img_home/", img))
            })
        ),

        # Carruseles
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

        tags$img(src = "home_assets_home/flag_korea_south_transparent.png", class = "bg-flag-static"),

        div(class = "ui-foreground",
            tags$img(src = "fortis_imgs/fortis_logo_transparent.png", class = "logo-fortis-top"),
            h1(class = "title-text", "FORTIS"),
            actionButton(ns("enter_btn"), "ENTRAR", class = "btn-enter"),

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

    click_data <- reactiveValues(status = FALSE)

    observeEvent(input$enter_btn, {
      click_data$status <- TRUE
    })

    # Lógica del Debug Overlay
    output$debug_overlay <- renderUI({
      req(debug)
      div(style="position:absolute; top:10px; left:10px; z-index:999; color:#00f2fe; font-family:monospace; font-size:10px; pointer-events:none;",
          "HOME_MODE: ACTIVE")
    })

    return(list(clicked = reactive({ click_data$status })))
  })
}
