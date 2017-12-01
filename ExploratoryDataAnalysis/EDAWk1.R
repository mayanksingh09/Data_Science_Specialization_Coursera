data <- read.csv("https://raw.githubusercontent.com/mayanksingh09/courses/master/04_ExploratoryAnalysis/exploratoryGraphs/data/avgpm25.csv", colClasses = c("numeric", "character", "factor", "numeric", "numeric"))


## Graphs

summary(data$pm25) #five number summary (6 in R but actually 5, no mean)

boxplot(data$pm25, col = "blue") #boxplot

hist(data$pm25, col = "green", breaks = 100) #histogram
rug(data$pm25) #rug representation (1-d plot)

boxplot(data$pm25, col = "blue") #boxplot
abline(h = 12) #adding a line to the plot

hist(data$pm25, col = "orange")
abline(v = 12, lwd = 2)
abline(v = median(data$pm25), col = "magenta", lwd = 4)

barplot(table(data$region), col = "wheat", main = "Number of Counties in Each Region") #barplot

boxplot(pm25 ~ region, data = data, col = "red") #boxplot

par(mfrow = c(2,1), mar = c(4,4,2,1)) # multiple histograms
hist(subset(data, region == "east")$pm25, col = "green")
hist(subset(data, region == "west")$pm25, col = "green")


with(data, plot(latitude, pm25, col = region)) #scatterplot with region as color dimension
abline(h = 12, lwd = 2, lty = 2)

par(mfrow = c(1,2), mar = c(5,4,2,1)) # multiple scatterplots
with(subset(data, region == "west"), plot(latitude, pm25, main = "West"))
with(subset(data, region == "east"), plot(latitude, pm25, main = "East"))


## Plotting


### base plot

library(datasets)
data(cars)
with(cars, plot(speed, dist)) #dist v/s speed

### lattice system

library(lattice)
state <- data.frame(state.x77, region = state.region)
xyplot(Life.Exp ~ Income | region, data = state, layout = c(4,1))


### ggplot2

library(ggplot2)
data(mpg)
qplot(displ, hwy, data = mpg)


library(datasets)
hist(airquality$Ozone) # histogram

with(airquality, plot(Wind, Ozone)) # scatterplot

airquality <- transform(airquality, Month = factor(Month))
boxplot(Ozone ~ Month, airquality, xlab = "Month", ylab = "Ozone (ppb)") # boxplot

par("lty") # line type check

par("col") # color 

par("pch") # plotting symbol

par("mar") # margin size

library(datasets)
with(airquality, plot(Wind, Ozone))
title(main = "Ozone and Wind in New York City")

with(airquality, plot(Wind, Ozone, main = "Ozone and Wind in New York City")) # scatterplot
with(subset(airquality, Month == 5), points(Wind, Ozone, col = "blue")) #month 5 data points are blue


with(airquality, plot(Wind, Ozone, main = "Ozone and Wind in New York City")) # scatterplot
with(subset(airquality, Month == 5), points(Wind, Ozone, col = "blue")) #month 5 data points are blue
with(subset(airquality, Month != 5), points(Wind, Ozone, col = "red")) #month other than 5 red
legend("topright", pch = 1, col = c("blue", "red"), legend = c("May", "Other Months")) # add legend

with(airquality, plot(Wind, Ozone, main = "Ozone and Wind in New York City", pch = 20))
model <- lm(Ozone ~ Wind, airquality) #make a linear model
abline(model, lwd = 2) #made the linear line


### multiple base plots
par(mfrow = c(1,2))
with(airquality, {
  plot(Wind, Ozone, main = "Ozone and Wind")
  plot(Solar.R, Ozone, main = "Ozone and Solar Radiation")
})

par(mfrow = c(1,2), mar = c(4,4,2,1), oma = c(0,0,2,0))
with(airquality, {
  plot(Wind, Ozone, main = "Ozone and Wind")
  plot(Solar.R, Ozone, main = "Ozone and Solar Radiation")
  plot(Temp, Ozone, main = "Ozone and Temperature")
  mtext("Ozone and Weather in New York City", outer = TRUE)
})
