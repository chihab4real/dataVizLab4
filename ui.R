library(shiny)
library(shinydashboard)
library(fresh)

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


