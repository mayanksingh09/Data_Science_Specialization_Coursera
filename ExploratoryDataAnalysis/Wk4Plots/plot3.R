## Read in the data
NEI <- readRDS("./data/Wk4Assignmentdata/summarySCC_PM25.rds")
SCC <- readRDS("./data/Wk4Assignmentdata/Source_Classification_Code.rds")

## Plot 3

library(dplyr)

df3 <- NEI %>%
  filter(fips == "24510") %>%
  group_by(year, type) %>%
  summarise(PMsum = sum(Emissions))

png("plot2.png", width=480, height=480)
qplot(year, PMsum, data = df3, facets = .~type) + labs(title = "Type-wise Yearly PM2.5 Emission(Baltimore City)") + labs(x = "Year", y = "PM2.5 Emission")
dev.off()