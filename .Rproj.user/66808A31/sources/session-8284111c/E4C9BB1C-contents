# ==============================================================================
# MÓDULO 01: HOME (FORTIS) - SPLIT-SCREEN CON EFECTOS HOVER EN LOGOS
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

    vector_top_files <- list.files(file.path(path_www, "fn01_top_img"),
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
          --transition-speed: 0.3s;
        }

        body, .container-fluid { padding: 0 !important; margin: 0 !important; background: #000; overflow: hidden; }

        .home-main-container {
          width: 100vw; height: 100vh; position: relative; display: flex; flex-direction: column; overflow: hidden;
          background: #000;
        }

        /* --- EFECTO GENERAL HOVER PARA LOGOS --- */
        .hover-scale {
          transition: transform var(--transition-speed) ease;
          cursor: pointer;
        }
        .hover-scale:hover {
          transform: scale(1.2);
        }

        /* --- FONDO: CARRUSELES --- */
        .carousel-overlay {
          position: absolute; inset: 0; display: flex; flex-direction: column; justify-content: space-around;
          z-index: 5; opacity: 0.3;
        }
        .track-row { width: 100%; overflow: hidden; white-space: nowrap; }
        .track-content { display: inline-flex; width: max-content; }
        .track-content img { height: 13vh; margin-right: 10px; border-radius: 5px; }

        /* --- ESTRUCTURA SPLIT --- */
        .split-screen {
          display: flex; width: 100vw; height: 100vh; position: relative; z-index: 100;
        }
        .left-side {
          flex: 0 0 50%; display: flex; flex-direction: column;
          align-items: center; justify-content: center; gap: 30px;
        }
        .logos-row {
          display: flex; flex-direction: row; align-items: center; justify-content: center;
          gap: 40px; width: 100%;
        }
        .right-side {
          flex: 0 0 50%; display: flex; flex-direction: column;
          align-items: center; justify-content: center;
        }

        /* --- TAMAÑOS --- */
        .bg-flag-static { width: 70%; height: auto; }
        .logo-wt { width: 100px; height: auto; opacity: 0.9; }
        .logo-mistoerer { width: 130px; height: auto; opacity: 0.9; }

        /* --- UI SUPERIOR --- */
        .top-logos-static {
          position: absolute; top: 30px; left: 0; width: 100%; height: 8vh;
          z-index: 150; display: flex; justify-content: center; align-items: center; gap: 50px;
        }
        .top-logos-static img { height: 6vh; width: auto; }

        /* --- UI DERECHA --- */
        .logo-fortis-top { width: 140px; height: auto; margin-bottom: 10px; }
        .title-text {
          font-family: var(--f-header); font-size: 7.5rem; color: white; margin: 0;
          letter-spacing: -2px; text-shadow: 0px 5px 15px rgba(0,0,0,0.5); line-height: 0.85;
        }
        .btn-enter {
          margin-top: 30px; border: 2px solid var(--c-fortis); background: transparent;
          color: white; padding: 12px 60px; font-family: var(--f-header); font-size: 1.6rem;
          cursor: pointer; transition: 0.3s; letter-spacing: 3px;
        }
        .btn-enter:hover { background: var(--c-fortis); color: black; box-shadow: 0 0 30px var(--c-fortis); }

        /* --- FOOTER GLOBAL --- */
        .global-footer {
          position: absolute; bottom: 40px; left: 50%; transform: translateX(-50%);
          display: flex; flex-direction: column; align-items: center; z-index: 200;
        }
        .olympic-logo { width: 100px; margin-bottom: 10px; opacity: 0.9; }
        .latin-quote {
          color: white; font-family: var(--f-header); font-size: 1.2rem; letter-spacing: 5px; text-align: center;
        }

        /* ANIMACIONES */
        @keyframes ", ns("scroll_left"), " { 0% { transform: translateX(0); } 100% { transform: translateX(-50%); } }
        .anim-slow { animation: ", ns("scroll_left"), " 180s linear infinite; }
        .anim-fast { animation: ", ns("scroll_left"), " 120s linear infinite; }
      ")))
    ),

    div(class = "home-main-container",
        uiOutput(ns("debug_overlay")),

        # Logos superiores (con hover)
        div(class = "top-logos-static",
            lapply(vector_top_files, function(img) {
              tags$img(src = paste0("top_img_home/", img), class = "hover-scale")
            })
        ),

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

        div(class = "split-screen",
            # IZQUIERDA
            div(class = "left-side",
                tags$img(src = "home_assets_home/flag_korea_south_transparent.png", class = "bg-flag-static hover-scale"),
                div(class = "logos-row",
                    tags$img(src = "home_assets_home/logo_WT_transparent.png", class = "logo-wt hover-scale"),
                    tags$img(src = "home_assets_home/logo_mistoerer_transparent.png", class = "logo-mistoerer hover-scale")
                )
            ),
            # DERECHA
            div(class = "right-side",
                tags$img(src = "fortis_imgs/fortis_logo_transparent.png", class = "logo-fortis-top hover-scale"),
                h1(class = "title-text", "FORTIS"),
                actionButton(ns("enter_btn"), "ENTRAR", class = "btn-enter")
            )
        ),

        # Footer Global (con hover en anillos)
        div(class = "global-footer",
            tags$img(src = "home_assets_home/olympic_ring_transparent_png.png", class = "olympic-logo hover-scale"),
            div(class = "latin-quote", "CITIUS • ALTIUS • FORTIUS")
        )
    )
  )
}

mod_01_home_server <- function(id, debug = TRUE) {
  moduleServer(id, function(input, output, session) {
    navegar_a <- reactiveVal(NULL)
    observeEvent(input$enter_btn, { navegar_a("page_options") })

    output$debug_overlay <- renderUI({
      req(debug)
      div(style="position:absolute; top:10px; left:10px; z-index:999; color:#00f2fe; font-family:monospace; font-size:10px; pointer-events:none;",
          "INTERFACE: HOME_MODE")
    })

    return(list(
      goto = navegar_a,
      reset = function() { navegar_a(NULL) }
    ))
  })
}
