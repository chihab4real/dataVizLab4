library(shiny)
library(shinydashboard)
library(shinyjs)
library(dplyr)
library(shinythemes)
library(DT)
library(ggplot2)


server <- function(input, output, session) {
  team <- read.csv("../csv files/team.csv", header = TRUE, stringsAsFactors = FALSE)
  team <- team %>% select(-id)
  team$logo <- paste0('<img src="', team$logo, '" height="50" />')
  colnames(team) <- c("Team Name", "Abbreviation", "Nickname", "City", "State", "Year Established", "Logo")
  
  
  history = read.csv("../csv files/team_history.csv", sep = ",")
  history$year_group <- cut(history$year_founded, breaks = 5, labels = c("1946-1958", "1959-1971", "1972-1984", "1985-1997", "1998-2014"))
  data <- history%>% 
    group_by(year_group) %>% summarise(n_founded=n())
  
  
  
  output$team <- DT::renderDataTable({
    DT::datatable(team, 
                  style = "bootstrap",
                  options = list(pageLength = 5,
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
                  extensions = c('Buttons'),
                  escape = FALSE
    ) 
  })
  output$history_plot <- renderPlot({
    ggplot(data, aes(x = factor(year_group), y = n_founded, fill=n_founded)) +
      geom_bar(stat = "identity") +
      labs(x = "Year Founded", y = "Number of Teams") +
      theme_minimal() +  
      theme(
            axis.text.x = element_text(angle = 45, size = 11, hjust=1),
            axis.text.y = element_text(size = 11, face = "bold"),            axis.title.x = element_text(margin = margin(t = 20)),  
            axis.title.y = element_text(margin = margin(r = 20))
      )+
      theme(legend.position = "none")
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