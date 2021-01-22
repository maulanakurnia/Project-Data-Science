# @author
# 123180176 - Maulana Kurnia Fiqih Ainul Yaqin
# 123180143 - Nityasa Sasikirana Putri Sutiono

# Setup Package
  library(DT)
  library(shinyWidgets)
  library(shinydashboard)
  library(shinydashboardPlus)
  library(tm)
  library(tidytext) 
  library(ggplot2)
  library(dplyr) # Manipulasi Data

# Import Source 
  source("./scrap.R")
  source("classifier/naive_bayes.R")
  
# Setup Env
  URL_Scrapping = "https://www.tripadvisor.com/Attraction_Review-g34515-d143395-Reviews-Magic_Kingdom_Park-Orlando_Florida.html"

# Server of Shiny
server <- function(input, output) {
  data <- reactive({
    withProgress({
      setProgress(message = "Sedang mengumpulkan data", value = 0)
      result <- get_reviews(URL_Scrapping, input$size, incProgress)
    })
    
    return(result)
  })
  
  prediction_data <- reactive({
    withProgress({
      setProgress(message = "Memprediksi sentimen", value = 0)
      
      reviews <- data()$review
      incProgress(1/2)
      prediction <- predict_sentiment(reviews)
      incProgress(1/2)
    })
    prediction$reviewer <- data()$reviewer
    
    return(prediction)
  })

  dataWord <- reactive({
      corpus <- clean_data(data()$review)
    features <- readRDS("classifier/features.rds")
      v <- sort(colSums(as.matrix(convert_term_matrix(corpus,features))), decreasing = TRUE)
      data.frame(Kata=names(v), Jumlah=as.integer(v), row.names=NULL, stringsAsFactors = FALSE) %>%
        filter(Jumlah > 0)
  })
  
  
  output$table_review <- renderDataTable(datatable({
    prediction_data()
  }))
  
  output$total_review <- renderInfoBox({
    
    infoBox(
      "Total", 
      paste0(nrow(prediction_data()), " review"),
      
    )
  })
  
  output$positive_review <- renderInfoBox({
    infoBox(
      "Positif", 
      paste0(nrow(prediction_data() %>% 
                    filter(sentiment == "Positive")), " review"), 
      icon = icon("thumbs-up", lib = "glyphicon")
    )
  })
  
  output$negative_review <- renderInfoBox({
    infoBox(
      "Negatif",
      paste0(nrow(prediction_data() %>% 
                    filter(sentiment == "Negative")), " review"), 
      icon = icon("thumbs-down", lib = "glyphicon")
    )
  })
  
  output$kontribusi_sentimen <- renderPlot({
    sentiments <- dataWord() %>% 
      inner_join(get_sentiments("bing"), by = c("Kata" = "word"))
    
    positive <- sentiments %>% filter(sentiment == "positive") %>% top_n(10, Jumlah) 
    negative <- sentiments %>% filter(sentiment == "negative") %>% top_n(10, Jumlah)
    sentiments <- rbind(positive, negative)
    
    sentiments <- sentiments %>%
      mutate(Jumlah=ifelse(sentiment == "negative", -Jumlah, Jumlah))%>%
      mutate(Kata = reorder(Kata, Jumlah))
    
    ggplot(sentiments, aes(Kata, Jumlah, fill=sentiment))+
      geom_bar(stat = "identity")+
      scale_fill_manual(values = c("#be1558", "#0da128"))+
      theme(axis.text.x = element_text(angle = 90, hjust = 1))+
      ylab("Kontibusi Sentimen")
  })
  
  output$wordcloud <- renderPlot({
    data.corpus <- clean_data(data()$review)
    wordcloud(data.corpus, min.freq = 30, max.words = 50, rot.per = 0.35, colors = brewer.pal(8,"Dark2"))
  })
}