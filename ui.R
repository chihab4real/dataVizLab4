library(shiny)
library(shinydashboard)
library(fresh)
library(shinyjs)

# my own theme using fresh
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
  dashboardHeader(title = "NBA",
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
      menuItem(HTML('<i class="fas fa-users"></i> Team'), tabName = "team"),
      menuItem(HTML('<i class="fas fa-basketball-ball"></i> Players'), tabName = "players"),
      menuItem(HTML('<i class="fa-solid fa-question"></i> Help'), tabName = "qa")
    )
  ),
  dashboardBody(
    use_theme(my_theme),
    useShinyjs(),  # Użyj shinyjs
    tabItems(
      tabItem(tabName = "home",
              h1("Home dashboard")
      ),
      tabItem(tabName = "history",
              h1("History dashboard")
      ),
      tabItem(tabName = "team",
              h1("Team dashboard")
      ),
      tabItem(tabName = "players",
              h1("Players dashboard")
      ),
      tabItem(tabName = "qa",
              h2("Questions and Answers"),
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