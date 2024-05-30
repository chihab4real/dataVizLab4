library(shiny)
library(shinydashboard)
library(shinyjs)
library(dplyr)
library(shinythemes)
library(DT)
library(ggplot2)
library(plotly)


server <- function(input, output, session) {
  players <- read.csv("csv files/player.csv", header = TRUE, stringsAsFactors = FALSE)
  team_history <- read.csv("csv files/team_history.csv", header = TRUE, stringsAsFactors = FALSE)
  
  
  players$is_active <- as.logical(players$is_active)
  
  player_summary <- players %>%
    mutate(status = ifelse(is_active == 1, "Active players", "Not Active players")) %>%
    group_by(status) %>%
    summarise(count = n())
  
  team_summary <- team_history %>%
    mutate(status = ifelse(year_active_till == "2019", "Active teams", "Not Active teams")) %>%
    group_by(status) %>%
    summarise(count = n())
  
  output$player_donut <- renderPlotly({
    plot_ly(player_summary, labels = ~status, values = ~count, text = ~paste(count, "Players"), type = 'pie', hole = 0.6) %>%
      layout(title = "Player Status", showlegend = TRUE, hoverinfo = "label+text") %>%
      add_trace(marker = list(colors = c("#C8102E", "#1B3770")))
  })
  
  output$team_donut <- renderPlotly({
    plot_ly(team_summary, labels = ~status, values = ~count, text = ~paste(count, "Teams"), type = 'pie', hole = 0.6) %>%
      layout(title = "Team Status", showlegend = TRUE, hoverinfo = "label+text") %>%
      add_trace(marker = list(colors = c("#C8102E", "#1B3770")))
  })
  
  
  team <- read.csv("csv files/team.csv", header = TRUE, stringsAsFactors = FALSE)
  team <- team %>% select(-id)
  team_datatable <- team %>% select(-logo)
  #team$logo <- paste0('<img src="', team$logo, '" height="50" />')
  team$logo_path <- team$logo
  colnames(team_datatable) <- c("Team Name", "Abbreviation", "Nickname", "City", "State", "Year Established")
  
  
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
  
  output$team_datatable <- DT::renderDataTable({
    DT::datatable(team_datatable, 
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
  
  output$team_grid <- renderUI({
    fluidRow(
      lapply(1:nrow(team), function(i) {
        column(
          width = 3, # Adjust the width as per your preference
          align = "center",
          style = "margin-bottom: 20px;", # Increase vertical space between items
          div(
            style = "position: relative; width: 250px; height: 250px; border-radius: 15px; overflow: hidden; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
            img(
              src = team$logo_path[i],
              height = 150,
              style = "position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); max-width: 100%; max-height: 100%;"
            ),
            
            div(
              style = "position: absolute; bottom: 8px; left: 2px;margin: 1px; font-weight: bold",
              img(src = "city.png", height = 30),
              br(),
              team$city[i]
            ),
            div(
              style = "position: absolute; bottom: 8px; right: 2px;margin:1px; font-weight: bold",
              img(src = "state.png", height = 30), 
              br(),
              team$state[i]
            )
          ),
          div(
            style = "padding: 8px; color: #000; text-align: center; font-size: 18px; font-weight: bold;",
            team$full_name[i]
          )
        )
      })
    )
  })
  
  observeEvent(input$show_grid, {
    show("team_grid_div")
    hide("team_map_div")
    hide("datatable_div")
  })
  
  observeEvent(input$show_map, {
    show("team_map_div")
    hide("team_grid_div")
    hide("datatable_div")
  })
  
  observeEvent(input$show_datatable, {
    show("datatable_div")
    hide("team_grid_div")
    hide("team_map_div")
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