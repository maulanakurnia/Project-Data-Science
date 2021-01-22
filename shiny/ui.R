# @author
# 123180176 - Maulana Kurnia Fiqih Ainul Yaqin
# 123180143 - Nityasa Sasikirana Putri Sutiono

# Setup Package
  library(shiny)
  library(shinycssloaders)
  library(RColorBrewer)
  library(shinydashboard)
  library(shinydashboardPlus)
  library(shinyWidgets)
  library(dplyr)
  library(DT)
  library(wordcloud)
  
# UI Of the Shiny
 library(shinyWidgets)
 library(shinydashboard)
 library(shinydashboardPlus)
 
  ui <- dashboardPagePlus(
     header = dashboardHeaderPlus(disable = T),
     sidebar = dashboardSidebar(disable = T),
     body = dashboardBody(
       fluidRow(
         infoBoxOutput("total_review"),
         infoBoxOutput("positive_review"),
         infoBoxOutput("negative_review"),
       ),
       fluidRow(
         box(
           width = 12,
           sliderInput(
             "size",
             "Total reviews",
             min = 0,
             max = 1000,
             value = 20,
           ),
           submitButton("Submit",width = "100%"),
         ),
       ),
       fluidRow(
         tabBox(
           width = 12,
           tabPanel(
             title = "Tabel Analisis Sentimen",
             div(DT::dataTableOutput("table_review") %>% 
                   withSpinner(color="#1167b1",type = 5), 
                 style = "font-size: 70%;")
           ),
           
           tabPanel(title = "Wordcloud",
                    plotOutput("wordcloud") %>% 
                      withSpinner(color="#1167b1", type = 5)
           ),
           tabPanel(title = "Sentiment Positive vs Negative",
                    plotOutput("kontribusi_sentimen") %>%
                      withSpinner(color="#1167b1",type = 5) 
           )
         )
       )
       
     ),
     title = "DashboardPage"
  )