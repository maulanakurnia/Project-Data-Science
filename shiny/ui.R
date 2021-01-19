# @author
# 123180176 - Maulana Kurnia Fiqih Ainul Yaqin
# 123180143 - Nityasa Sasikirana Putri Sutiono

# Setup Package
  library(shiny)
  library(shinycssloaders)
  library(RColorBrewer)
  library(shinydashboard)
  library(dplyr)
  library(DT)
  library(wordcloud)
  
# UI Of the Shiny
  
  ui <- shinyUI(
    fluidPage(theme = "paper",
      fluidRow(
        valueBoxOutput("total_review"),
        valueBoxOutput("positive_review"),
        valueBoxOutput("negative_review"),
      ),
      
      br(),
      hr(),
      
      fluidRow(
        tabBox(
          width = 12,
          tabPanel(
            title = "Sentimen Analisis",
            div(DT::dataTableOutput("table_review") %>% withSpinner(color="#1167b1"), style = "font-size: 70%;")
          ),
          tabPanel(title = "Wordcloud",
                   plotOutput("wordcloud") %>% withSpinner(color="#1167b1")
          )
        )
      )
    )
  )