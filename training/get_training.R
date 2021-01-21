# Setup Package
  library(tidyverse) # General-purpose data wrangling
  library(rvest)     # Parsing of HTML/XML files  
  library(stringr)   # String manipulation
  library(rebus)     # Verbose regular expressions

# func get training
  get_training_data <- function(url, size = -1) {
    reviews <- character()
    reviewers <- character()
    score <- numeric()
    
    pattern = 'bubble_'%R% capture(DIGIT) 
    
    reviewPage <- read_html(url)
    review <- reviewPage %>%
      html_nodes('.IRsGHoPm') %>%
      html_text()
    
    reviewer <- reviewPage %>%
      html_nodes('._1r_My98y') %>%
      html_text()
    
    ratings <-  reviewPage %>% 
      html_nodes('._2UEC-y30 > div > .ui_bubble_rating') %>% 
      html_attrs() %>% 
      # Apply the pattern match to all attributes
      map(str_match, pattern = pattern) %>%
      # str_match[1] is the fully matched string, the second entry
      # is the part you extract with the capture in your pattern  
      map(2) %>%                             
      
      unlist()
    
    
    reviews <- c(reviews, review)
    reviewers <- c(reviewers, reviewer)
    score <- c(score, ratings)
    
    nextPage <- reviewPage %>%
      html_nodes('.next') %>%
      html_attr('href')
    
    if(is_empty(nextPage)) {
      nextPage = NA
    }
    
    while (!is.na(nextPage) & (length(reviews) < size | size == -1)) {
      print(paste(length(reviews), "data", "berhasil discrap"))
      
      reviewUrl <- paste(url, nextPage, sep = "")
      reviewPage <- read_html(reviewUrl)
      
      review <- reviewPage %>%
        html_nodes('.IRsGHoPm') %>%
        html_text()
      
      reviewer <- reviewPage %>%
        html_nodes('._1r_My98y') %>%
        html_text()
      
      ratings <-  reviewPage %>% 
        html_nodes('._2UEC-y30 > div > .ui_bubble_rating') %>% 
        html_attrs() %>% 
        # Apply the pattern match to all attributes
        map(str_match, pattern = pattern) %>%
        # str_match[1] is the fully matched string, the second entry
        # is the part you extract with the capture in your pattern  
        map(2) %>%                             
        
        unlist()
      
      reviews <- c(reviews, review)
      reviewers <- c(reviewers, reviewer)
      score <- c(score, ratings)
      
      nextPage <- reviewPage %>%
        html_nodes('.next') %>%
        html_attr('href')
      
      if(is_empty(nextPage)) {
        nextPage = NA
      }
      
    }
    
    totalReviews <- length(reviews)
    if(totalReviews < size || size == -1) {
      size = totalReviews
    }
    
    print(paste(length(reviews), "data", "berhasil discrap"))
    
    
    return(data.frame(score = score, review = reviews, stringsAsFactors = FALSE)[1 : size,])
  }

URL_Scrapping = "https://www.tripadvisor.com/Hotel_Review-g5074492-d13008958-Reviews-Yogyakarta_Marriott_Hotel-Depok_Sleman_District_Yogyakarta_Region_Java.html"

write.table(get_training_data(URL_Scrapping, 445), 
            file = "C:/Users/mufrad/Berkas Kuliah/Praktikum Data Science/Project/training/training.txt",
            sep = "\t",
            row.names = FALSE,
            quote = FALSE)