# @author
# 123180176 - Maulana Kurnia Fiqih Ainul Yaqin
# 123180143 - Nityasa Sasikirana Putri Sutiono

# Setup Package
  library(DT)

# Import Source 
  source("./scrap.R")
  source("classifier/naive_bayes.R")
  
# Setup Env
  URL_Scrapping = "https://www.tripadvisor.com/Hotel_Review-g5074492-d13008958-Reviews-Yogyakarta_Marriott_Hotel-Depok_Sleman_District_Yogyakarta_Region_Java.html"

# Server of Shiny
server <- function(input, output) {
  data <- reactive({
    withProgress({
      setProgress(message = "Sedang mengumpulkan data", value = 0)
      
      result <- get_reviews(URL_Scrapping, 100, incProgress)
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
  
  output$table_review <- renderDataTable(datatable({
    prediction_data()
  }))
  
  output$total_review <- renderValueBox({
    
    valueBox(
      "Total", 
      paste0(nrow(prediction_data()), " review"),
      
    )
  })
  
  output$positive_review <- renderValueBox({
    valueBox(
      "Positif", 
      paste0(nrow(prediction_data() %>% filter(sentiment == "Positive")), " review"),
    )
  })
  
  output$negative_review <- renderValueBox({
    valueBox(
      "Negatif",
      paste0(nrow(prediction_data() %>% filter(sentiment == "Negative")), " review"), 
    )
  })
  
  output$wordcloud <- renderPlot({
    data.corpus <- clean_data(data()$review)
    wordcloud(data.corpus, min.freq = 30, max.words = 50)
  })
}