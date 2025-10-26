library(shiny)
library(shinyWidgets)
library(ggplot2)
library(nukeR)

ui <- fluidPage(
  titlePanel("nukeR — Educational Blast Zone Visualizer"),
  sidebarLayout(
    sidebarPanel(
      helpText("Illustrative only. Does NOT represent real-world blast effects."),
      numericInput("yield", "Yield (megatons)", 1.5, min = 0.01, step = 0.1),
      numericInput("hob", "Height of Burst (meters)", 1800, min = 0, step = 100),
      actionButton("plotBtn", "Update Plot")
    ),
    mainPanel(
      plotOutput("zonePlot", height = "700px"),
      br(),
      uiOutput("zoneInfo")     # <— add this line
    )
  )
)

server <- function(input, output) {
  # Compute once per button press
  plotData <- eventReactive(input$plotBtn, {
    compute_zones_local(input$yield, input$hob)
  })

  output$zonePlot <- renderPlot({
    result <- plotData()  # use cached reactive value

    # Inspect structure in console for debugging
    print(str(result))

    # result$zones is your tidy data frame
    plot_zones(result$zones) +
      ggtitle(
        if (result$fireball_touches_ground)
          sprintf(
            "Groundburst — Fireball touches ground (%.0f m radius)",
            result$fireball_radius_m
          )
        else
          sprintf(
            "Airburst — Fireball above ground (%.0f m radius)",
            result$fireball_radius_m
          )
      )
  })

  # Optional: display zone table below the plot
  output$zoneInfo <- renderUI({
    result <- plotData()
    zones <- result$zones

    tagList(
      h4("Zone Information"),
      tableOutput("zoneTable")
    )
  })

  output$zoneTable <- renderTable({
    result <- plotData()
    result$zones[, c("description", "overpressure_psi", "radius_km")]
  })
}


shinyApp(ui, server)
