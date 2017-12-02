library(lattice)
library(datasets)

# LATTICE PLOTTING SYSTEM 

## Simple scatterplot
xyplot(Ozone ~ Wind, data = airquality)

## Convert month to factor variable
airquality <- transform(airquality, Month = factor(Month))

xyplot(Ozone ~ Wind | Month, data = airquality, layout = c(5,1)) #Ozone and Wind by month

p <- xyplot(Ozone ~ Wind, data = airquality) #doesn't print
print(p)

set.seed(10)
x <- rnorm(100)
f <- rep(0:1, each = 50)
y <- x + f - f * x + rnorm(100, sd = 0.5)
f <- factor(f, labels = c("Group 1", "Group 2"))
xyplot(y ~ x | f, layout = c(2, 1)) #Plot with 2 panels

## Custom panel function
xyplot(y ~ x | f, panel = function(x, y, ...){
  panel.xyplot(x, y, ...) ## First call the default panel function for xyplot
  panel.abline(h = median(y), lty = 2)
})

xyplot(y ~ x | f, panel = function(x, y, ...){
  panel.xyplot(x, y, ...) ## First call the default panel function for xyplot
  panel.lmline(x, y, col = 2) ## Overlay a simple linear regression line
})

## Lattice plot example

### Multi-Panel Lattice Plot (Lot of data in one view)


# GGPLOT2

library(ggplot2)

#qplot() # analogous to plot()
str(mpg)

qplot(displ, hwy, data = mpg) #base plot
qplot(displ, hwy, data = mpg, color = drv) #add color aesthetic for drive type

qplot(displ, hwy, data = mpg, geom = c("point", "smooth")) #loess smooth geom

## make a histogram by specifying only one variable
qplot(hwy, data = mpg, fill = drv) # added drive type by color (use fill instead of color)


## Facets (like Panels)
qplot(displ, hwy, data = mpg, facets = .~drv) #create panels by drive type (<rows of matrix> ~ <columns to separate by>)

qplot(hwy, data = mpg, facets = drv ~., binwidth = 2) #row-wise split in panels now
str(mpg)

qplot(log(cty), data = mpg, geom = "density", color = drv) #density plot, colored by drive type


## scatter plot
qplot(hwy, cyl, data = mpg)
qplot(hwy, cyl, data = mpg, shape = fl) #shape changed by fl type
qplot(hwy, cyl, data = mpg, color = fl) #color changed by fl type

## smooth the relationship
qplot(hwy, cyl, data = mpg, color = fl) + geom_smooth(method = "lm") #adding a linear line to find relationship b/w hwy & cyl

## split by facets
qplot(hwy, cyl, data = mpg, facets = .~fl) + geom_smooth(method = "lm")

## basic plot using qplot
qplot(hwy, cyl, data = mpg, facets = . ~fl , geom = c("point", "smooth"), method = "lm")

## building ggplot it layer by layer

g <- ggplot(mpg, aes(hwy, cyl)) #data with call to ggplot

g <- g + geom_point() + geom_smooth(method = "lm") + facet_grid(.~fl)# adding points to the plot # adding a smoother # adding the facet function

g + geom_point(color = "steelblue", size = 4, alpha = 1/2) #changing parameters of geom fn

g + geom_point(aes(color = fl), size = 4, alpha = 1/2) #wrap color in the aes() fn

g + geom_point(aes(color = fl), size = 4, alpha = 1/2) + labs(title = "Highway Milage Behavior") + labs(x = "Highway Milage (MPG)", y = "Number of Cylinders") #adding labels and titles to the plot

g + geom_point(aes(color = fl), size = 4, alpha = 1/2) + geom_smooth(size = 4, linetype = 3, method = "lm", se = FALSE) #modifying the smoother line

g + geom_point(aes(color = fl), size = 4, alpha = 1/2) + theme_bw(base_family = "Times") #modifying base theme and also all the fonts

## Axis limits
testdata <- data.frame(x = 1:100, y = rnorm(100))
testdata[50,2] <- 100 ## outlier
plot(testdata$x, testdata$y, type = "l", ylim = c(-3,3)) #outlier not displayed on the base plot

g <- ggplot(testdata, aes(x = x, y = y))
g + geom_line() #oulier also present in the ggplot plot

g + geom_line() + ylim(-3, 3) # will remove the data points beyond this limits

g + geom_line() + coord_cartesian(ylim = c(-3,3)) #will create a plot with the proper scaling

## check relationship b/w hwy and cty

### deciles of data
cutpoints <- quantile(mpg$cty, seq(0,1, length = 4), na.rm = TRUE)

### cut the data at deciles and create a new factor variable
mpg$ctydec <- cut(mpg$cty, cutpoints) ## categorizes continuous variables

### levels of the new factor variables
levels(mpg$ctydec)

## plot with new features
g <- ggplot(mpg, aes(hwy, cyl)) #data with call to ggplot
g + geom_point(alpha = 1/3) + facet_wrap(fl ~ ctydec, nrow = 5, ncol = 4) + geom_smooth(method = "lm", se = FALSE, col = "steelblue") + theme_bw(base_family = "Avenir", base_size = 10) + labs(x = "Highway Mileage (MPG)") + labs(y = "Number of Cylinders") + labs(title = "Highway Mileage Behavior")


### Swirl exercises
## Lattice plots

xyplot(Ozone ~ Wind, data = airquality, pch = 8, col = "red", main = "Big Apple Data") #adding color and point types along with Chart title

xyplot(Ozone ~ Wind | as.factor(Month), data = airquality, layout = c(5,1)) # splitting the plot by month, layout also specified

### Wk 2 questions
library(datasets)
data(airquality)

qplot(Wind, Ozone, data = airquality, facets = . ~ factor(Month))

airquality = transform(airquality, Month = factor(Month))
qplot(Wind, Ozone, data = airquality, facets = . ~ Month)

library(ggplot2)
library(ggplot2movies)
g <- ggplot(movies, aes(votes, rating))
print(g)

qplot(votes, rating, data = movies) + geom_smooth()
