## Plotly

library(plotly)
data(mtcars)

# Scatterplot color
plot_ly(mtcars, x = mtcars$wt, y = mtcars$mpg, mode = "markers", color = as.factor(mtcars$cyl))

# Continuous color
plot_ly(mtcars, x = mtcars$wt, y = mtcars$mpg, mode = "markers", color = mtcars$disp)

# Scatterplot sizing

plot_ly(mtcars, x = mtcars$wt, y = mtcars$mpg, mode = "markers", color = as.factor(mtcars$cyl), size = mtcars$hp)

# 3D Scatterplot

set.seed(100)
temp <- rnorm(100, mean = 30, sd = 5)
pressure <- rnorm(100)

dtime <- 1:100
plot_ly(x = temp, y = pressure, z = dtime,
        type = "scatter3d", mode = "markers", color = temp)


# Line Graph

data("airmiles")
plot_ly(x = time(airmiles), y = airmiles, mode = "line")


library(tidyr)
library(dplyr)

data("EuStockMarkets")

stocks <- as.data.frame(EuStockMarkets) %>% 
    gather(index, price) %>% 
    mutate(time = rep(time(EuStockMarkets), 4))

plot_ly(stocks, x = stocks$time, y = stocks$price, color = stocks$index, mode = "line")

# Histogram

plot_ly(x = mtcars$mpg, type = "histogram")


# Box plot
data(iris)

plot_ly(data = iris, y = iris$Petal.Length, color = iris$Species, type = "box")


# Heatmap

terrain1 <- matrix(rnorm(100*100), nrow = 100, ncol = 100)

plot_ly(z = terrain1, type = "heatmap")

# 3D surface heatmap

terrain2 <- matrix(sort(rnorm(100*100)), nrow= 100, ncol = 100)

plot_ly(z = terrain2, type = "surface")
#understand what the smooth


# Choropleth Maps

#Create data frame
state_pop <- data.frame(State = state.abb, Pop = as.vector(state.x77[,1]))

# Create hover text
state_pop$hover <- with(state_pop, paste(State, '<br>', "Population:", Pop))
