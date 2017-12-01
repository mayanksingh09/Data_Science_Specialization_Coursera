## Plot 3
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

# Create a date_time column
date_time <- strptime(paste(epc_data$Date, epc_data$Time, sep=" "), "%Y-%m-%d %H:%M:%S")

# Plot

png("plot3.png", width=480, height=480)
plot(date_time, epc_data$Sub_metering_1, type="l", ylab="Energy Submetering", xlab="")
lines(date_time, epc_data$Sub_metering_2, type="l", col="red")
lines(date_time, epc_data$Sub_metering_3, type="l", col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1, lwd=2, col=c("black", "red", "blue"))
dev.off()