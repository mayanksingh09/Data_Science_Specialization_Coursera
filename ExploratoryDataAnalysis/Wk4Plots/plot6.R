## Read in the data
NEI <- readRDS("./data/Wk4Assignmentdata/summarySCC_PM25.rds")
SCC <- readRDS("./data/Wk4Assignmentdata/Source_Classification_Code.rds")

## Plot 6

library(dplyr)
NEI$SCC <- as.character(NEI$SCC)
SCC$SCC <- as.character(SCC$SCC)

df6 <- NEI %>%
  left_join(SCC, by = "SCC") %>%
  mutate(vehicle_chk = grepl("Vehicles", Short.Name)) %>%
  filter(fips %in% c("24510", "06037") & (vehicle_chk == TRUE)) %>%
  group_by(year, fips) %>%
  summarise(PMvehiclesum = sum(Emissions))

df6$county <- ifelse(df6$fips == "24510", "Baltimore City", "Los Angeles County")

png("plot6.png", width=480, height=480)
qplot(year, PMvehiclesum, data = df6, facets = .~county) + labs(title = "Yearly PM2.5 Emission (Motor Vehicle Sources)") + labs(x = "Year", y = "PM2.5 Emission")
dev.off()