library(shiny)
library(shinydashboard)
library(fresh)
library(htmltools)
library(shinyjs)
library(DT)
library(shinythemes)
library(plotly)

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
        "))
      ),
      tabItems(
        tabItem(tabName = "home",
                h1("Home dashboard"),
                fluidRow(
                  column(6,
                        plotlyOutput("player_donut")
                         ),
                  column(6,
                         plotlyOutput("team_donut")
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
                         hidden(div(id = "team_grid_div", uiOutput("team_grid"))),
                         hidden(div(id = "team_map_div", tags$iframe(src = "us_nba_teams_map.html", height = "600px", width = "100%", frameborder = "0"))),
                         hidden(div(id = "datatable_div", DT::dataTableOutput("team_datatable")))
                  )
                )
        ),
        tabItem(tabName = "players",
                h1("Players dashboard")
        ),
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
