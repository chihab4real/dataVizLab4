library(shiny)
library(shinydashboard)
library(shinyjs)
library(dplyr)
library(shinythemes)
server <- function(input, output, session) {
  team <- read.csv("csv files/team.csv", header = TRUE, stringsAsFactors = FALSE)
  team <- team %>% select(-id) 
  colnames(team) <- c("Team Name", "Abbreviation", "Nickname", "City", "State", "Year Established")

  output$team <- DT::renderDataTable({
    DT::datatable(team, 
                  style = "bootstrap",
                  options = list(pageLength = 10,
                                 lengthMenu = c(5,10,20),
                                 searching = TRUE,
                                 ordering = TRUE,
                                 dom = 'Bfrtip',
                                 buttons = list(
                                   list(extend = 'copy', text = '<i class="fa fa-copy"></i>'),
                                   list(extend = 'csv', text = '<i class="fa fa-file-csv"></i>'),
                                   list(extend = 'excel', text = '<i class="fa fa-file-excel"></i>')
                                   ),
                                 class = 'stripe hover'),
                  extensions = c('Buttons')
                  )
  })
  
  
  observeEvent(input$q1, {
    toggle("a1")
  })
  
  observeEvent(input$q2, {
    toggle("a2")
  })
  
  observeEvent(input$q3, {
    toggle("a3")
  })
  
  observeEvent(input$q4, {
    toggle("a4")
  })

}