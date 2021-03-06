## Google Vis
library(googleVis)
data("Fruits")
chart_1 <- gvisMotionChart(Fruits, "Fruit", "Year", options = list(width = 600, height = 400))

plot(chart_1) # plot for the gvis
print(chart_1) # the html for the plot

# Charts in googleVis
# Check the documentation for Google Viz

# Can be used with knitr and slidify

# Set results = "asis" in chunk options

# Plots on maps
G <- gvisGeoChart(Exports, locationvar = "Country",
                  colorvar = "Profit", options = list(width = 600, height = 400))
plot(G)

# Specifying a region
G2 <- gvisGeoChart(Exports, locationvar = "Country",
                  colorvar = "Profit", options = list(width = 600, height = 400, region = "150"))
plot(G2)

# Setting more options

df <- data.frame(label = c("US", "GB", "BR"), val1 = c(1,3,4), val2 = c(23, 12, 32))

Line <- gvisLineChart(df, xvar = "label", yvar = c("val1", "val2"),
                      options = list(title = "Line Plot", legend = "bottom", titleTextStyle = "{color:'red', fontSize:18}",
                                     vAxis = "{gridlines:{color:'red', count:3}}",
                                     hAxis = "{title:'My Label', titleTextStyle:{color:'blue'}}",
                                     series = "[{color:'green', targetAxisIndex:0},
                                     {color: 'blue', targetAxisIndex:1}]",
                                     vAxes = "[{title:'Value 1 (%)', format:'##,######%'},
                                     {title: 'Value 2 (\U00A3)'}]",
                                     curveType = "function", width = 500, height = 300))

plot(Line) # plot the line chart

## Combining multiple plots

G <- gvisGeoChart(Exports, "Country", "Profit", options = list(width = 200, height = 100))

T1 <- gvisTable(Exports, options = list(width = 200, height = 270))
M <- gvisMotionChart(Fruits, "Fruit", "Year", options = list(width = 400, height = 370))
GT <- gvisMerge(G, T1, horizontal = F)
GTM <- gvisMerge(GT, M, horizontal = T, tableOptions = "bgcolor=\"#CCCCCC\" cellspacing = 10")

plot(GTM)