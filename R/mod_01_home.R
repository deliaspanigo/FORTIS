mod_01_home_ui <- function(id, bg_color = "#000", bg_opacity = 0) {
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
    addResourcePath("fortis_imgs", file.path(path_www, "fn08_fortis"))
    addResourcePath("home_assets_home", file.path(path_www, "fn10_home"))
    vector_top_files <- list.files(file.path(path_www, "fn01_top_img"), pattern = "\\.(png|jpg|jpeg|webp)$", ignore.case = TRUE)
  } else {
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

        #", ns("home_container"), " {
          width: 100vw; height: 100vh; position: relative;
          display: flex; flex-direction: column; overflow: hidden;
          background: transparent !important; /* CRÍTICO: Debe ser transparente */
        }

        .bg-overlay {
          position: absolute; inset: 0;
          background: ", bg_color, ";
          opacity: ", bg_opacity, ";
          z-index: 1;
        }

        .split-screen { display: flex; width: 100vw; height: 100vh; position: relative; z-index: 100; }
        .left-side, .right-side { flex: 0 0 50%; display: flex; flex-direction: column; align-items: center; justify-content: center; }

        .hover-scale { transition: transform 0.3s ease; cursor: pointer; }
        .hover-scale:hover { transform: scale(1.1); }

        .bg-flag-static { width: 60%; height: auto; filter: drop-shadow(0 0 20px rgba(0,0,0,0.5)); }
        .top-logos-static {
          position: absolute; top: 30px; left: 0; width: 100%; height: 8vh;
          z-index: 150; display: flex; justify-content: center; align-items: center; gap: 50px;
        }
        .top-logos-static img { height: 6vh; width: auto; }

        .title-text {
          font-family: var(--f-header); font-size: 7.5rem; color: white; margin: 0;
          letter-spacing: -2px; line-height: 0.85; text-shadow: 2px 2px 15px rgba(0,0,0,0.9);
        }

        .btn-enter {
          margin-top: 30px; border: 2px solid var(--c-fortis); background: rgba(0,0,0, 0.4);
          color: white; padding: 12px 60px; font-family: var(--f-header); font-size: 1.6rem;
          cursor: pointer; transition: 0.3s; letter-spacing: 3px;
        }
        .btn-enter:hover { background: var(--c-fortis); color: black; box-shadow: 0 0 30px var(--c-fortis); }

        .global-footer {
          position: absolute; bottom: 40px; left: 50%; transform: translateX(-50%);
          display: flex; flex-direction: column; align-items: center; z-index: 200;
        }
        .latin-quote { color: white; font-family: var(--f-header); font-size: 1.2rem; letter-spacing: 5px; text-shadow: 1px 1px 5px black;}
      ")))
    ),

    div(id = ns("home_container"),
        div(class = "bg-overlay"),

        div(class = "top-logos-static",
            lapply(vector_top_files, function(img) {
              tags$img(src = paste0("top_img_home/", img), class = "hover-scale")
            })
        ),

        div(class = "split-screen",
            div(class = "left-side",
                tags$img(src = "home_assets_home/flag_korea_south_transparent.png", class = "bg-flag-static hover-scale"),
                div(class = "logos-row", style="display:flex; gap:40px; margin-top:30px;",
                    tags$img(src = "home_assets_home/logo_WT_transparent.png", style="width:100px;", class="hover-scale"),
                    tags$img(src = "home_assets_home/logo_mistoerer_transparent.png", style="width:130px;", class="hover-scale")
                )
            ),
            div(class = "right-side",
                tags$img(src = "fortis_imgs/fortis_logo_transparent.png", style="width:140px; margin-bottom:10px;", class="hover-scale"),
                h1(class = "title-text", "FORTIS"),
                actionButton(ns("enter_btn"), "ENTRAR", class = "btn-enter")
            )
        ),

        div(class = "global-footer",
            tags$img(src = "home_assets_home/olympic_ring_transparent_png.png", style="width:100px; margin-bottom:10px;", class="hover-scale"),
            div(class = "latin-quote", "CITIUS • ALTIUS • FORTIUS")
        )
    )
  )
}

mod_01_home_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    navegar_a <- reactiveVal(NULL)
    observeEvent(input$enter_btn, { navegar_a("page_options") })
    return(list(goto = navegar_a, reset = function() { navegar_a(NULL) }))
  })
}

# ==============================================================================
# TEST STAND-ALONE (Con fondo negro visible)
# ==============================================================================
if (interactive()) {
  library(shiny)
  # Aquí lo probamos con fondo negro sólido (opacidad 1)
  ui <- fluidPage(mod_01_home_ui("test", bg_color = "#000", bg_opacity = 1))
  server <- function(input, output, session) { mod_01_home_server("test") }
  shinyApp(ui, server)
}
