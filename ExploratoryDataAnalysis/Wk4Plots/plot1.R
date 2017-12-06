## Read in the data
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

## Plot 1

library(dplyr)

df1 <- NEI %>%
  group_by(year) %>%
  summarise(PMsum = sum(Emissions))

png("plot1.png", width=480, height=480)
plot(df1$year, df1$PMsum, pch = 19, main = "Yearly Total PM2.5 Emission", xlab = "Year", ylab = "PM2.5 Emission")
dev.off()