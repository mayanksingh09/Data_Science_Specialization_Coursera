## Reading in the data

library(tm)
library(NLP)
library(dplyr)
library(stringr)
library(ggplot2)

setwd("/Users/mayank/Documents/Coursera/Data Science Specialization/Capstone Material")

# con <- file("./data/final/en_US/en_US.blogs.txt", "r") 
# readLines(con, 1)
# close(con)

eng_blogs <- readLines("./data/final/en_US/en_US.blogs.txt")
eng_twitter <- readLines("./data/final/en_US/en_US.twitter.txt")
eng_news <- readLines("./data/final/en_US/en_US.news.txt")

# Lengths of strings in the data
strlengths_blogs <- str_length(eng_blogs)
strlengths_twitter <- str_length(eng_twitter)
strlengths_news <- str_length(eng_news)

summary(strlengths_blogs)
summary(strlengths_twitter)
summary(strlengths_news)

hist(strlengths_twitter)

qplot(strlengths_blogs,
      geom="histogram",
      main = "Histogram for Blogs", 
      xlab = "No. of Words",  
      fill=I("blue"), 
      col=I("red"), 
      alpha=I(.2),
      xlim=c(0,2000))

x <- as.data.frame(strlengths_blogs)
x$name <- 1

ggplot(data = x, aes(x = name, y = strlengths_blogs)) + 
    geom_boxplot()

# Distribution of string lengths in the files



# sample_blogs <- eng_blogs[floor(runif(n = 100, min = 1, max = 899280))]
# rm(eng_blogs)
# 
# print(sample_blogs)
# 
# corpus_blogs <- Corpus(VectorSource(sample_blogs))
# 
# tdm_blogs <- TermDocumentMatrix(corpus_blogs)


eng_blogs <- paste(eng_blogs, collapse = " ")
eng_blogs <- as.String(eng_blogs)

# Creating Annotators for words and sentences
word_ann <- Maxent_Word_Token_Annotator() 
sent_ann <- Maxent_Sent_Token_Annotator()
