# ==============================================================================
# MÓDULO: PDF VIEWER - ENCAPSULADO Y PARAMETRIZADO (CORREGIDO)
# ==============================================================================

mod_special_one_show_pdf_ui <- function(id) {
  ns <- NS(id)

  tagList(
    tags$style(HTML(paste0("
      #", id, "-container {
        width: 100%; height: 100%;
        background: #f4f4f4; border-radius: 8px;
        overflow: hidden; display: flex; flex-direction: column;
      }
      .pdf-toolbar {
        padding: 12px 20px; background: #333; color: white;
        display: flex; align-items: center; border-bottom: 2px solid #00f2fe;
      }
      .pdf-iframe {
        flex-grow: 1; border: none; width: 100%; height: 85vh;
      }
      .pdf-empty {
        padding: 50px; text-align: center; color: #999;
      }
    "))),

    div(id = paste0(id, "-container"),
        div(class = "pdf-toolbar",
            uiOutput(ns("pdf_title_ui"))
        ),
        uiOutput(ns("pdf_frame_ui"))
    )
  )
}

mod_special_one_show_pdf_server <- function(id, file_path = NULL, label = "DOCUMENTO", zoom = 100) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Renderizar el título: Maneja tanto string fijo como reactivo
    output$pdf_title_ui <- renderUI({
      # Si label es reactivo, lo evaluamos; si no, lo usamos directo
      txt_label <- if (is.reactive(label)) label() else label
      req(txt_label)

      span(icon("file-pdf"), paste0(" ", toupper(as.character(txt_label))),
           style="font-weight:800; letter-spacing:1px; color: #00f2fe;")
    })

    pdf_resource <- reactive({
      # file_path DEBE ser un reactivo para que esto funcione dinámicamente
      req(file_path())
      path <- file_path()

      if (!file.exists(path)) return(NULL)

      dir_name <- dirname(path)
      base_name <- basename(path)
      resource_prefix <- paste0("pdf_res_", id)

      # Registrar el prefijo de recurso
      addResourcePath(resource_prefix, dir_name)

      return(paste0(resource_prefix, "/", base_name, "?t=", as.numeric(Sys.time()), "#zoom=", zoom))
    })

    output$pdf_frame_ui <- renderUI({
      url <- pdf_resource()
      if (is.null(url)) {
        return(div(class = "pdf-empty", icon("circle-notch", "fa-spin fa-3x"),
                   p("Cargando visor...", style="margin-top:15px;")))
      }

      tags$iframe(
        src = url,
        class = "pdf-iframe",
        type = "application/pdf"
      )
    })
  })
}

# ==============================================================================
# EJECUCIÓN DIRECTA (APP DE PRUEBA)
# ==============================================================================


if (interactive()) {
  library(shiny)

  #library(shiny)

  ui <- fluidPage(
    tags$style("body { margin: 0; background: #222; }"),
    div(style = "padding: 20px;",
        mod_special_one_show_pdf_ui("pdf_demo")
    )
  )

  server <- function(input, output, session) {

    # Iniciamos con la ruta directamente
    ruta_pdf <- reactiveVal("C:/Users/Legion/bulk/MyInstallers/FORTIS_TKD_installer/FORTIS/inst/www/pack05_graduations/pdf_material/pdf01_CINTURE_BIANCHE_E_BIANCHA_GIALLA.pdf")

    # Invocación del servidor
    # Nota: pasamos 'ruta_pdf' (el reactivo) sin paréntesis
    mod_special_one_show_pdf_server(
      id = "pdf_demo",
      file_path = ruta_pdf,
      label = "Manual Prueba - Demo PDF",
      zoom = 100
    )

  }

  shinyApp(ui, server)
}
