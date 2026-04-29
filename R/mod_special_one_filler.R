# ==============================================================================
# MÓDULO GENÉRICO DE RELLENO (BOILERPLATE)
# ==============================================================================

# --- UI ---
mod_special_one_filler_ui <- function(id) {
  ns <- NS(id)

  page_sidebar(
    title = NULL,
    fillable = TRUE,

    # Panel Lateral
    sidebar = sidebar(
      title = div(icon("layer-group"), " OPCIONES MÓDULO",
                  style = "font-family: 'Impact', sans-serif; color: #00f2fe;"),
      width = 250,
      bg = "#1a1a1a",

      # Botón de volver genérico
      actionButton(ns("btn_back"), " VOLVER",
                   icon = icon("arrow-left"),
                   style = "background: #333; color: white; border: none; width: 100%;"),

      hr(style = "border-top: 1px solid #444;"),
      p("Configuraciones adicionales...", style = "color: #666; font-size: 0.8rem; padding: 10px;")
    ),

    # Contenido Principal
    card(
      full_screen = TRUE,
      card_header(
        uiOutput(ns("header_title"))
      ),
      layout_column_wrap(
        width = 1,
        div(
          style = "height: 60vh; display: flex; align-items: center; justify-content: center; text-align: center;",
          uiOutput(ns("main_content"))
        )
      )
    )
  )
}

# --- SERVER ---
mod_special_one_filler_server <- function(id, display_text = "Módulo en Construcción") {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Estado para el retorno a la app principal
    back_event <- reactiveVal(FALSE)

    # Renderizar el título dinámico
    output$header_title <- renderUI({
      tags$b(paste("VISTA:", toupper(id)))
    })

    # Renderizar el texto pasado por argumento
    output$main_content <- renderUI({
      div(
        icon("tools", class = "fa-4x", style = "color: #00f2fe; margin-bottom: 20px;"),
        h2(display_text, style = "font-family: 'Impact', sans-serif; color: #fff;"),
        p("Este es un módulo de relleno. Pronto se conectará el contenido real.",
          style = "color: #888;")
      )
    })

    # Capturar clic en volver
    observeEvent(input$btn_back, {
      back_event(TRUE)
    })

    # Retorno estructurado para el app.R
    return(list(
      goto_back = reactive({ back_event() }),
      reset     = function() { back_event(FALSE) }
    ))
  })
}


if (interactive()) {

    library(shiny)
    library(bslib)

   # devtools::load_all()


    # 1. Definimos una UI mínima para la prueba
    ui_test <- page_fillable(
      # Llamamos a la UI del módulo
      mod_special_one_filler_ui("test_id")
    )

    # 2. Definimos un Server mínimo
    server_test <- function(input, output, session) {
      # Llamamos al Server del módulo con los argumentos que quieras probar
      mod_special_one_filler_server("test_id", display_text = "MODO PRUEBA: ESTO FUNCIONA")
    }

    # 3. Ejecutamos la App de prueba
    shinyApp(ui_test, server_test)

}
