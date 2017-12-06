## Read in the data
NEI <- readRDS("./data/Wk4Assignmentdata/summarySCC_PM25.rds")
SCC <- readRDS("./data/Wk4Assignmentdata/Source_Classification_Code.rds")

## Plot 2

library(dplyr)

df2 <- NEI %>%
  filter(fips == "24510") %>%
  group_by(year) %>%
  summarise(PMsum = sum(Emissions))

png("plot2.png", width=480, height=480)
plot(df2$year, df2$PMsum, pch = 19, main = "Yearly Total PM2.5 Emission(Baltimore City)", xlab = "Year", ylab = "PM2.5 Emission (Baltimore)")
dev.off()