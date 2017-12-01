## Plot 1
library(lubridate)

# Set working directory
setwd("/Users/workingdirectory")

# Read raw_data from a data folder within working directory
epc_data <- read.table("./data/household_power_consumption.txt", sep = ";", header = TRUE, na.strings = "?", colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))

# Change into date format
epc_data$Date <- dmy(epc_data$Date)

# Subset only for the two days
date1 <- as.POSIXct("2007-02-01")
date2 <- as.POSIXct("2007-02-02")
int <- interval(date1, date2)
epc_data <- epc_data[epc_data$Date %within% int,]

# Plot
opt <- options("scipen" = 20)
getOption("scipen")
png("plot1.png", width=480, height=480)
hist(epc_data$Global_active_power, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)")
dev.off()