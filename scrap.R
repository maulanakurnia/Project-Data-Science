# @author
# 123180176 - Maulana Kurnia Fiqih Ainul Yaqin
# 123180143 - Nityasa Sasikirana Putri Sutiono

library(rvest)

get_reviews <- function(url, size = -1, incProgress = NULL) {
  reviews <- character()
  reviewers <- character()
  
  reviewPage <- read_html(url)
  review <- reviewPage %>%
    html_nodes('.IRsGHoPm') %>%
    html_text()
  
  reviewer <- reviewPage %>%
    html_nodes('._1r_My98y') %>%
    html_text()
  
  reviews <- c(reviews, review)
  reviewers <- c(reviewers, reviewer)
  
  if(!is.null(incProgress)) {
    incProgress(10/size) 
  }
  
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
    
    reviews <- c(reviews, review)
    reviewers <- c(reviewers, reviewer)
    
    nextPage <- reviewPage %>%
      html_nodes('.next') %>%
      html_attr('href')
    
    if(is_empty(nextPage)) {
      nextPage = NA
    }
    
    if(!is.null(incProgress)) {
      incProgress(10/size) 
    }
  }
  
  totalReviews <- length(reviews)
  if(totalReviews < size || size == -1) {
    size = totalReviews
  }
  
  print(paste(length(reviews), "data", "berhasil discrap"))
  
  return(data.frame(reviewer = reviewers, review = reviews, stringsAsFactors = FALSE)[1 : size,])
}
