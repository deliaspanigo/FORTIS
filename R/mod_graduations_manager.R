mod_graduations_manager_ui <- function(id) {
  ns <- NS(id)

  page_sidebar(
    title = NULL,
    fillable = TRUE,
    sidebar = sidebar(
      # --- AGREGAMOS BOTÓN DE VOLVER ---
      actionButton(ns("btn_back"), " VOLVER AL MENÚ",
                   icon = icon("chevron-left"),
                   style = "background: #444; color: white; border: none; margin-bottom: 15px; font-size: 0.7rem;"),

      title = div(icon("graduation-cap"), " Cinturones",
                  style = "font-family: 'Impact', sans-serif; color: #00f2fe;"),
      width = 300,
      bg = "#252525",
      tags$style(HTML(paste0("
        .btn-grad {
          background: #333; color: #ccc; border: 1px solid #444; margin-bottom: 5px;
          text-align: left; width: 100%; padding: 10px; font-size: 0.8rem;
          font-weight: 600; transition: 0.3s;
        }
        .btn-grad:hover { background: #444; color: #00f2fe; border-color: #00f2fe; }
        .btn-grad-active {
          background: #00f2fe !important; color: #000 !important; font-weight: 800;
        }
      "))),
      uiOutput(ns("menu_ui"))
    ),
    div(style = "background: #000; height: 100%;",
        mod_special_one_show_pdf_ui(ns("viewer"))
    )
  )
}

mod_graduations_manager_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # --- ESTADO PARA EL RETORNO ---
    back_event <- reactiveVal(FALSE)

    base_path <- system.file("www", "pack05_graduations", "pdf_material", package = "FORTIS")
    yaml_path <- file.path(base_path, "stone_files.yml")

    config_data <- reactive({
      req(file.exists(yaml_path))
      yml <- read_yaml(yaml_path)
      df <- do.call(rbind, lapply(yml$files, as.data.frame))
      df$full_path <- file.path(base_path, df$file_name)
      return(df)
    })

    selected_pdf <- reactiveVal(NULL)
    selected_label <- reactiveVal("")

    observe({
      df <- config_data()
      if(nrow(df) > 0 && is.null(selected_pdf())) {
        selected_pdf(df$full_path[1])
        selected_label(df$label_tab[1])
      }
    })

    output$menu_ui <- renderUI({
      df <- config_data()
      req(nrow(df) > 0)
      lapply(1:nrow(df), function(i) {
        active_class <- if(!is.null(selected_pdf()) && selected_pdf() == df$full_path[i]) " btn-grad-active" else ""
        actionButton(
          ns(df$id[i]),
          label = df$label_menu[i],
          class = paste0("btn-grad", active_class),
          onclick = sprintf("Shiny.setInputValue('%s', '%s', {priority: 'event'})", ns("file_click"), df$id[i])
        )
      })
    })

    observeEvent(input$file_click, {
      df <- config_data()
      row <- df[df$id == input$file_click, ]
      selected_pdf(row$full_path)
      selected_label(row$label_tab)
    })

    # Evento para capturar el botón de volver
    observeEvent(input$btn_back, {
      back_event(TRUE)
    })

    mod_special_one_show_pdf_server("viewer", file_path = selected_pdf, label = selected_label, zoom = "FitH")

    # --- RETORNO CRÍTICO PARA EL APP.R ---
    return(list(
      goto_back = reactive({ back_event() }),
      reset     = function() { back_event(FALSE) }
    ))
  })
}


# library(shiny)
# library(bslib)
# library(yaml)
# library(shinyjs)
#
# # 1. Definir UI de prueba
# ui_test <- page_fillable(
#   useShinyjs(),
#   # Fondo negro para mantener la estética de FORTIS
#   tags$style("body { background-color: #000; color: white; }"),
#
#   mod_graduations_manager_ui("test_grad")
# )
#
# # 2. Definir Server de prueba
# server_test <- function(input, output, session) {
#
#   # Llamamos al servidor del módulo
#   grad_logic <- mod_graduations_manager_server("test_grad")
#
#   # Observador para probar la señal de "VOLVER"
#   observeEvent(grad_logic$goto_back(), {
#     req(grad_logic$goto_back())
#
#     showNotification(
#       "Señal de RETORNO detectada. El App.R principal cerraría este panel.",
#       type = "message",
#       duration = 5
#     )
#
#     # Reseteamos la señal
#     grad_logic$reset()
#   })
# }
#
# # 3. Ejecutar
# shinyApp(ui_test, server_test)
