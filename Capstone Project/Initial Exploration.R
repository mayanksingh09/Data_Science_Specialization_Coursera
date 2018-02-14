## Reading in the data


setwd("/Users/mayank/Documents/Coursera/Data Science Specialization/Capstone Material")

# con <- file("./data/final/en_US/en_US.blogs.txt", "r") 
# readLines(con, 1)
# close(con)

eng_blogs <- readLines("./data/final/en_US/en_US.blogs.txt")
eng_twitter <- readLines("./data/final/en_US/en_US.twitter.txt")
eng_news <- readLines("./data/final/en_US/en_US.news.txt")

length(eng_twitter)
sample_blogs <- eng_blogs[floor(runif(n = 100, min = 1, max = 899280))]

rm(eng_blogs)

library(stringr)

strlengths_twitter <- str_length(eng_twitter)
strlengths_blogs <- str_length(eng_blogs)
strlengths_news <- str_length(eng_news)
max(strlengths_news)

# Week 1 Quiz

# 1. 200Mb

# 2. 2,360,148

# 3. 40K blogs

# 4. 



