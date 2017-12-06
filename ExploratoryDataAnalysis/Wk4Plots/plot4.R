## Read in the data
NEI <- readRDS("./data/Wk4Assignmentdata/summarySCC_PM25.rds")
SCC <- readRDS("./data/Wk4Assignmentdata/Source_Classification_Code.rds")

## Plot 4

library(dplyr)
NEI$SCC <- as.character(NEI$SCC)
SCC$SCC <- as.character(SCC$SCC)

df4 <- NEI %>%
  left_join(SCC, by = "SCC") %>%
  mutate(coal_chk = grepl("Coal", Short.Name)) %>%
  filter(coal_chk == TRUE) %>%
  group_by(year) %>%
  summarise(PMcoalsum = sum(Emissions))

png("plot4.png", width=480, height=480)
qplot(year, PMcoalsum, data = df4) + labs(title = "Yearly PM2.5 Emission (Coal Sources)") + labs(x = "Year", y = "PM2.5 Emission")
dev.off()