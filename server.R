library(shiny)
library(shinydashboard)
library(shinyjs)
library(dplyr)
library(shinythemes)
library(DT)
library(ggplot2)
library(plotly)


server <- function(input, output, session) {
  team <- read.csv("csv files/team.csv", header = TRUE, stringsAsFactors = FALSE)
  team <- team %>% select(-id)
  team$logo <- paste0('<img src="', team$logo, '" height="50" />')
  colnames(team) <- c("Team Name", "Abbreviation", "Nickname", "City", "State", "Year Established", "Logo")
  
  
  history = read.csv("csv files/team_history.csv", sep = ",")
  history$year_group <- cut(history$year_founded, breaks = 5, labels = c("1946-1958", "1959-1971", "1972-1984", "1985-1997", "1998-2014"))
  data <- history%>% 
    group_by(year_group) %>% summarise(n_founded=n())
  
  history_till <- read.csv("csv files/team_history.csv", sep=",")
  history_till$year_group <- cut(history$year_active_till, breaks = 5, labels = c("1946-1958", "1959-1971", "1972-1984", "1985-1997", "1998-2014"))
  data_till <- history_till%>% 
    group_by(year_group) %>% summarise(n_till=n())  
  initial_data <- data_till
  initial_data$n_till <- rep(0, length(data_till$n_till))  
  
  
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
  output$history_plot <- renderPlotly({
    plot_ly(data, x = ~year_group, y = ~n_founded, type = 'bar', 
            marker = list(color = ~n_founded)) %>%
      layout(
        xaxis = list(title = "Year Founded", tickangle = 45),
        yaxis = list(title = "Number of Teams"),
        barmode = 'group',
        margin = list(t = 20, r = 20),
        showlegend = FALSE
      )
  })
  
  output$history_plot2 <- renderPlotly({
    plot_ly(data_till, x = ~year_group, y = ~n_till, type = 'bar', 
            marker = list(color = ~n_till)) %>%
      layout(
        xaxis = list(title = "Year Founded", tickangle = 45),
        yaxis = list(title = "Number of Teams"),
        barmode = 'group',
        margin = list(t = 20, r = 20),
        showlegend = FALSE
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