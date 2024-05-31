library(shiny)
library(shinydashboard)
library(fresh)
library(htmltools)
library(shinyjs)
library(DT)
library(shinythemes)
library(plotly)

players_common <- read.csv("csv files/common_player_info.csv", header = TRUE, stringsAsFactors = FALSE)
players_common_active <- players_common[players_common$rosterstatus == 'Active', ]

# My own theme using fresh
my_theme <- create_theme(
  adminlte_color(
    light_blue = "#C8102E"
  ),
  adminlte_sidebar(
    dark_bg = "#1D428A",
    dark_hover_bg = "#1B3770",
    dark_color = "#ffffff"
  ),
  adminlte_global(
    content_bg = "#f4f6f9",
    box_bg = "#ffffff",
    info_box_bg = "#f0f0f5"
  )
)

shinyUI(
  dashboardPage(
    dashboardHeader(
      title = div("NBA",
                  tags$img(src = "nba_logo.png", height = "50px")
      ),
      dropdownMenu(type = "messages",
                   messageItem(
                     from = "New User",
                     message = "How do I register?",
                     icon = icon("question"),
                     time = "13:45"
                   ),
                   messageItem(
                     from = "Support",
                     message = "The new server is ready.",
                     icon = icon("life-ring")
                   )
      ),
      dropdownMenu(type = "notifications",
                   notificationItem(
                     text = "5 new users today",
                     icon("users")
                   ),
                   notificationItem(
                     text = "Server load at 86%",
                     icon = icon("exclamation-triangle"),
                     status = "warning"
                   )
      )
    ),
    dashboardSidebar(
      sidebarMenu(
        menuItem(HTML('<i class="fas fa-home"></i> Home'), tabName = "home"),
        menuItem(HTML('<i class="fas fa-history"></i> History'), tabName = "history"),
        menuItem(HTML('<i class="fas fa-users"></i> Teams'), tabName = "teams"),
        menuItem(HTML('<i class="fas fa-basketball-ball"></i> Players'), tabName = "players"),
        menuItem(HTML('<i class="fa-solid fa-question"></i> Help'), tabName = "qa")
      )
    ),
    dashboardBody(
      use_theme(my_theme),
      useShinyjs(),
      tags$head(
        tags$style(HTML("
          /* Custom CSS for DataTable */
          .dataTables_wrapper .dt-buttons {
            float: right;
          }
          .dataTables_filter {
            float: left !important;
            text-align: left !important;
          }
          .dt-button {
            padding: 6px;
            margin: 2px;
            font-size: 14px;
          }
          .dt-button .fa {
            margin-right: 0;
          }
        .centered-subtitle {
        text-align: center;
        background-color: #C8102E;
        color: white;
        padding: 10px;
        margin-bottom: 10px;
        }
      
      .custom-text {
            font-family: 'Arial', sans-serif;
            font-weight: bold; 
            
      }
          
          .center-image {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100%;
          }
          
          .center-content {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100%;
          }
          
          .image-margin {
            margin-bottom: 20px;
            margin-top: 20px;
            margin-left: 50px;
            margin-right: 50px;
          }
          
          .custom-margin{
          margin-bottom: 20px;
          }
          
          .txt-margin {
            margin-bottom: 30px;
            margin-top: 30px;
            margin-left: 30px;
            margin-right: 30px;
          }
          
          .footer {
            position: fixed;
            bottom: 0;
            width: 100%;
            background-color: #f0f0f5;
            padding: 10px;
            text-align: center;
          }
        "))
      ),
      tabItems(
        tabItem(tabName = "home",
                h1("Home dashboard"),
                fluidRow(
                  column(8,
                         box(
                           title = "Welcome to NBA DashBoard",
                           status = "primary",
                           solidHeader = TRUE,
                           collapsible = FALSE,
                           img(src = "MJ.jpg", height = 550, width = "100%"),
                           h4(class = "custom-text", "There is no 'I' in the team but there is in WIN"),
                           h4("MJ"),
                           width = 18,
                         )
                  ),
                  column(4,
                         box(
                           title = " ",
                           status = "primary",
                           solidHeader = TRUE,
                           collapsible = FALSE,
                           width = 15,
                           fluidRow(
                             column(12,
                                    div(class = "center-content",
                                        img(src = "dashboard_logo_s.png", class = c("center-image","custom-margin"), width = "70%"),
                                        
                                    )
                             ),
                             h4(class = "txt-margin", "This is a simple dashboard for National Basketball Association fans. You can find here information about NBA history, teams, players and more."),
                             fluidRow(
                               
                               column(6,
                                      img(src = "nba_west_dark.png", class = c("center-image","image-margin"), width = "60%"),
                                      
                               ),
                               column(6,
                                      img(src = "nba_east_dark.png", class = c("center-image","image-margin"), width = "60%"),
                                      
                               )
                             )
                             
                             
                           )
                           
                           
                           
                         )
                         
                  )
                ),
                fluidRow(
                  column(12,
                         div(class = "footer",
                             h4("This application was created by:", strong(" Wiktoria Szarzyńska "), "& ", strong(" ChihabEddine Zitouni ")),
                         )
                  )
                )
                
        ),
        tabItem(tabName = "history",
                h1("National Basketball Association History"),
                h3("Here you can learn about foundation of given team and it's resignation"),
                fluidRow(
                  column(6,
                         h3("Teams Year Foundation", class = "centered-subtitle"),
                         plotlyOutput("history_plot"),
                         br()
                  ),
                  column(6,
                         h3("Teams Year Resignation", class = "centered-subtitle"),
                         plotlyOutput("history_plot2"),
                         br()
                  )                  
                )
                
        ),
        tabItem(tabName = "teams",
                h1("National Basketball Association League Teams"),
                h4("Choose visualization and get to know your favourite team better"),
                fluidRow(
                  theme = shinytheme("cyborg"),
                  column(width = 12, class = "col-custom",
                         actionButton("show_grid", "Grid"),
                         actionButton("show_map", "Map"),
                         actionButton("show_datatable", "Datatable"),
                         hidden(div(id = "team_grid_div",
                                    selectInput("conference_filter", "Select Conference:",
                                                choices = c("Show All", "Show Eastern", "Show Western"),
                                                selected = "Show All"),
                                    uiOutput("team_grid"))),
                         hidden(div(id = "team_map_div", tags$iframe(src = "us_nba_teams_map.html", height = "600px", width = "100%", frameborder = "0"))),
                         hidden(div(id = "datatable_div", DT::dataTableOutput("team_datatable")))
                  )
                )
        ),
        tabItem(tabName = "players",
                fluidRow(
                  theme = shinytheme("cyborg"),
                  column(width = 12, class = "col-custom",
                         actionButton("show_grid", "Show All Players Grid"),
                         actionButton("compare_players", "Compare 2 Players")
                  )
                ),
                fluidRow(
                  column(width = 12, class = "col-custom",
                         conditionalPanel(
                           condition = "input.show_grid >= input.compare_players",
                           selectInput("team", "Select a team:", c("Show All", unique(players_common_active$team_name))),
                           textInput("search", "Search player:"),
                           uiOutput("players_grid")
                         )
                  ),
                  column(width = 6, class = "col-custom",
                         conditionalPanel(
                           condition = "input.compare_players > input.show_grid",
                           selectInput("team1", "Select team for first player:", unique(players_common_active$team_name)),
                           selectInput("player1", "Select first player:", NULL),
                           selectInput("team2", "Select team for second player:", unique(players_common_active$team_name)),
                           selectInput("player2", "Select second player:", NULL),
                           actionButton("compare", "Compare")
                         )
                  ),
                  column(width = 6, class = "col-custom",
                         conditionalPanel(
                           condition = "input.compare_players >= input.show_grid",
                           uiOutput("comparison"),
                           DT::dataTableOutput("comparison_table")
                           
                         )
                  )
                )
        )
        
        
        
        ,
        
        
        
        
        
        tabItem(tabName = "qa",
                h1("FQA"),
                h4("Questions you asked most recently:"),
                div(
                  style = "margin-bottom: 20px;", 
                  actionButton("q1", "What is this application about?"),
                  hidden(
                    div(id = "a1",
                        p("This application provides various information about NBA teams and players, including historical data and player statistics.")
                    )
                  )
                ),
                div(
                  style = "margin-bottom: 20px;",
                  actionButton("q2", "What kind of information I can get from this app?"),
                  hidden(
                    div(id = "a2",
                        p("You can get information about NBA teams, player statistics, historical data, and more.")
                    )
                  )
                ),
                div(
                  style = "margin-bottom: 20px;",
                  actionButton("q3", "How to navigate the tabs to explore different sections?"),
                  hidden(
                    div(id = "a3",
                        p("Use the sidebar menu to navigate between different sections: Home, History, Team, Players, and Help.")
                    )
                  )
                ),
                div(
                  style = "margin-bottom: 20px;",
                  actionButton("q4", "How can I contact you?"),
                  hidden(
                    div(id = "a4",
                        p("You can contact us via email at support@example.com.")
                    )
                  )
                )
        )
      )
    )
  )
)
