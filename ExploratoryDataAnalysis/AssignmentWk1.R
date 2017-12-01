## Assignment Week 1
library(lubridate)




## Plot 1
opt <- options("scipen" = 20)
getOption("scipen")
hist(epc_data$Global_active_power, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)")


## Plot 2

date_time <- strptime(paste(epc_data$Date, epc_data$Time, sep=" "), "%Y-%m-%d %H:%M:%S")

plot(date_time, epc_data$Global_active_power, type = "l", lty = 1, xlab = "", ylab = "Global Active Power (kilowatts)")


## Plot 3

plot(date_time, epc_data$Sub_metering_1, type="l", ylab="Energy Submetering", xlab="")
lines(date_time, epc_data$Sub_metering_2, type="l", col="red")
lines(date_time, epc_data$Sub_metering_3, type="l", col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1, lwd=2, col=c("black", "red", "blue"))


## Plot 4

par(mfrow = c(2, 2))
plot(date_time, epc_data$Global_active_power, type="l", xlab="", ylab="Global Active Power")
plot(date_time, epc_data$Voltage, type="l", xlab="datetime", ylab="Voltage")
plot(date_time, epc_data$Sub_metering_1, type="l", xlab="", ylab="Energy Submetering")
lines(date_time, epc_data$Sub_metering_2, type="l", col="red")
lines(date_time, epc_data$Sub_metering_3, type="l", col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=, lwd=2, col=c("black", "red", "blue"), bty="n")
plot(date_time, epc_data$Global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power")
