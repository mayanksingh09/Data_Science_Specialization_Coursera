## Read in the data
NEI <- readRDS("./data/Wk4Assignmentdata/summarySCC_PM25.rds")
SCC <- readRDS("./data/Wk4Assignmentdata/Source_Classification_Code.rds")

## Plot 5

library(dplyr)
NEI$SCC <- as.character(NEI$SCC)
SCC$SCC <- as.character(SCC$SCC)

df5 <- NEI %>%
  left_join(SCC, by = "SCC") %>%
  mutate(vehicle_chk = grepl("Vehicles", Short.Name)) %>%
  filter((fips == "24510") & (vehicle_chk == TRUE)) %>%
  group_by(year) %>%
  summarise(PMvehiclesum = sum(Emissions))

png("plot5.png", width=480, height=480)
qplot(year, PMvehiclesum, data = df5) + labs(title = "Yearly PM2.5 Emission (Baltimore - Motor Vehicle Sources)") + labs(x = "Year", y = "PM2.5 Emission")
dev.off()