library(shiny)
library(shinydashboard)
library(fresh)

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
    dashboardHeader(title = "NBA"),
    dashboardSidebar(
      sidebarMenu(
        menuItem(HTML('<i class="fas fa-home"></i> Home'), tabName = "home"),      
        menuItem(HTML('<i class="fas fa-history"></i> History'), tabName = "history"),      
        menuItem(HTML('<i class="fas fa-users"></i> Team'), tabName = "team"),
        menuItem(HTML('<i class="fas fa-basketball-ball"></i> Players'), tabName = "players")      
    )),
    dashboardBody(
      use_theme(my_theme),
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
                )
        )
      )
    )
)


