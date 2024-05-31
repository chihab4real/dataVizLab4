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
  #
  players_common <- read.csv("csv files/common_player_info.csv", header = TRUE, stringsAsFactors = FALSE)
  
  players_common_active <- players_common[players_common$rosterstatus == 'Active', ]
  #
  players$is_active <- as.logical(players$is_active)
  
  
  player_comparison <- players_common_active %>% select( first_name, last_name, birthdate, school, country, height, weight, position)
  player_comparison$birthdate <- as.Date(player_comparison$birthdate)
  player_comparison$birthdate <- format(player_comparison$birthdate, "%d.%m.%Y")
  
  colnames(player_comparison) <- c("First Name", "Last name", "Birthday", "School", "Country", "Height", "Weight", "Position")
  
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
  team_datatable <- team %>% select(-logo) %>% select(-conf_sec) %>% select(-conference)
  team$logo_path <- team$logo
  colnames(team_datatable) <- c("Team Name", "Abbreviation", "Nickname", "City", "State", "Year Established")
  
  history <- read.csv("csv files/team_history.csv", sep = ",")
  history$year_group <- cut(history$year_founded, breaks = 5, labels = c("1946-1958", "1959-1971", "1972-1984", "1985-1997", "1998-2014"))
  data <- history %>% 
    group_by(year_group) %>% summarise(n_founded = n())
  
  history_till <- read.csv("csv files/team_history.csv", sep = ",")
  history_till$year_group <- cut(history_till$year_active_till, breaks = 5, labels = c("1946-1958", "1959-1971", "1972-1984", "1985-1997", "1998-2014"))
  data2 <- history_till %>% 
    group_by(year_group) %>% summarise(n_resigned = n())
  
  output$history_plot <- renderPlotly({
    plot_ly(
      data = data, x = ~year_group, y = ~n_founded, type = 'bar', color = I("#C8102E")
    ) %>%
      layout(
        xaxis = list(title = "Year Group",
                     tickangle = 45),
        yaxis = list(title = "Number of Teams"),
        barmode = 'group',
        margin = list(t = 20, r = 20),
        showlegend = FALSE
      )
  })
  
  output$history_plot2 <- renderPlotly({
    plot_ly(
      data = data2, x = ~year_group, y = ~n_resigned, type = 'bar', color = I("#1D428A")
    ) %>%
      layout(
        xaxis = list(title = "Year Group",
                     tickangle = 45),
        yaxis = list(title = "Number of Teams"),
        barmode = 'group',
        margin = list(t = 20, r = 20),
        showlegend = FALSE
      )
  })
  
  output$team_datatable <- DT::renderDataTable({
    DT::datatable(team_datatable, 
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
                  extensions = c('Buttons'),
                  escape = FALSE
    ) 
  })
  
  filtered_teams <- reactive({
    if (input$conference_filter == "Show All") {
      return(team)
    } else if (input$conference_filter == "Show Eastern") {
      return(team %>% filter(conference == "Eastern"))
    } else if (input$conference_filter == "Show Western") {
      return(team %>% filter(conference == "Western"))
    }
  })
  
  output$players_grid <- renderUI({
    
    selected_team_players <- if (input$team == "Show All") {
      players_common_active
    } else {
      players_common_active[players_common_active$team_name == input$team, ]
    }
    
    
    if (input$search != "") {
      selected_team_players <- selected_team_players[grep(input$search, selected_team_players$display_first_last), ]
    }
    
    
    if (nrow(selected_team_players) > 0) {
      fluidRow(
        lapply(1:nrow(selected_team_players), function(i) {
          column(
            width = 2, 
            align = "center",
            style = "margin-bottom: 20px;", 
            div(
              style = "position: relative; width: 100px; height: 100px; border-radius: 15px; overflow: hidden; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
              img(
                src = paste0("img_players/", selected_team_players$person_id[i], ".png"),  # Adjust the file extension if it's different
                height = 80,
                style = "position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); max-width: 100%; max-height: 100%;"
              )
            ),
            div(
              style = "padding: 8px; color: #000; text-align: center; font-size: 18px; font-weight: bold;",
              selected_team_players$display_first_last[i]
            )
          )
        })
      )
    } else {
      
      p("No players found.")
    }
  })
  
  
  output$player1 <- renderUI({
    selectInput("player1", "Select first player to compare:", 
                players_common_active[players_common_active$team_name == input$team1, ]$display_first_last)
  })
  
  output$player2 <- renderUI({
    selectInput("player2", "Select second player to compare:", 
                players_common_active[players_common_active$team_name == input$team2, ]$display_first_last)
  })
  
  
  
  output$comparison <- renderUI({
    
    if (!is.null(input$player1) && !is.null(input$player2)) {
      
      player1_data <- players_common_active[players_common_active$display_first_last == input$player1, ]
      player2_data <- players_common_active[players_common_active$display_first_last == input$player2, ]
      
      
      fluidRow(
        column(
          width = 6,
          align = "center",
          div(
            style = "position: relative; width: 100px; height: 100px; border-radius: 15px; overflow: hidden; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
            img(
              src = paste0("img_players/", player1_data$person_id, ".png"),
              height = 80,
              style = "position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); max-width: 100%; max-height: 100%;"
            )
          ),
          div(
            style = "padding: 8px; color: #000; text-align: center; font-size: 18px; font-weight: bold;",
            player1_data$display_first_last
          )
        ),
        column(
          width = 6,
          align = "center",
          div(
            style = "position: relative; width: 100px; height: 100px; border-radius: 15px; overflow: hidden; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
            img(
              src = paste0("img_players/", player2_data$person_id, ".png"),
              height = 80,
              style = "position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); max-width: 100%; max-height: 100%;"
            )
          ),
          div(
            style = "padding: 8px; color: #000; text-align: center; font-size: 18px; font-weight: bold;",
            player2_data$display_first_last
          )
        )
      )
    }
  })
  
  
  
  
  
  
  output$team_grid <- renderUI({
    teams_1 <- filtered_teams()
    team_logos <- teams_1$logo_path
    team_names <- teams_1$team_name
    
    fluidRow(
      lapply(1:nrow(teams_1), function(i) {
        column(
          width = 2, 
          align = "center",
          style = "margin-bottom: 10px;", 
          div(
            style = "position: relative; width: 250px; height: 200px; border-radius: 20px; overflow: hidden; box-shadow: 0 10px 10px rgba(0, 0, 0, 0.2);background-color: white;",
            img(
              src = teams_1$logo_path[i],
              height = 120,
              style = "position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); max-width: 100%; max-height: 100%;"
            ),
            
            div(
              style = "position: absolute; bottom: 8px; left: 2px;margin: 1px; font-weight: bold",
              img(src = "city.png", height = 30),
              br(),
              teams_1$city[i]
            ),
            div(
              style = "position: absolute; bottom: 8px; right: 2px;margin:1px; font-weight: bold",
              img(src = "state.png", height = 30), 
              br(),
              teams_1$state[i]
            )
          ),
          div(
            style = "padding: 8px; color: #000; text-align: center; font-size: 18px; font-weight: bold;",
            teams_1$full_name[i]
          )
        )
      })
    )
    
    
  })
  
  observeEvent(input$show_grid, {
    hide("team_map_div")
    hide("datatable_div")
    show("team_grid_div")
  })
  
  observeEvent(input$show_map, {
    hide("team_grid_div")
    hide("datatable_div")
    show("team_map_div")
  })
  
  observeEvent(input$show_datatable, {
    hide("team_grid_div")
    hide("team_map_div")
    show("datatable_div")
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
  view <- reactiveVal("grid")
  
  observeEvent(input$show_grid, {
    view("grid")
  })
  
  observeEvent(input$compare_players, {
    view("compare")
  }) 
  

  
  observe({
    updateSelectInput(session, "player1", choices = unique(players_common_active$display_first_last[players_common_active$team_name == input$team1]))
  })
  
  observe({
    updateSelectInput(session, "player2", choices = unique(players_common_active$display_first_last[players_common_active$team_name == input$team2]))
  })
  
  # Observe the compare button click
  observeEvent(input$compare, {

    player1_data <- player_comparison[players_common_active$display_first_last == input$player1, ]
    player2_data <- player_comparison[players_common_active$display_first_last == input$player2, ]
    
    
    comparison_data  <- data.frame(
      Attribute = names(player1_data),
      Player1 = as.character(player1_data[1, ]),
      Player2 = as.character(player2_data[1, ])
    )
    # Render the combined data table
    output$comparison_table <- DT::renderDataTable({
      DT::datatable(comparison_data, 
                    options = list(
                      searching = FALSE,  # Disable search
                      lengthMenu = list(c(5, 10, -1), c('5', '10', 'All')),  # Remove length menu
                      pageLength = 10,  # Set default page length
                      dom = 't'  # Display only table without other controls
                      ))
    })
  })
  

}