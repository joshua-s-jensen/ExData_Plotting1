setwd(choose.dir())

library(dplyr)
library(readr)
library(ggplot2)
library(lubridate)

## read in data, test with 1000 entries first due to file size
hpcdata <- read_csv2("household_power_consumption.txt") #  ,n_max = 1000)


## clean date & time variables

# base
# hpcdata$Date <- as.Date(hpcdata$Date, "%d/%m/%Y")

# lubridate
hpcdata$Date <- dmy(hpcdata$Date)

hpcdata <- filter(hpcdata, Date==ymd("2007-02-01")|Date==ymd("2007-02-02"))

hpcdata$Time <- hms(hpcdata$Time)
hpcdata$datetime <- ymd_hms(paste(hpcdata$Date,hpcdata$Time))
hpcdata$weekdate <- wday(hpcdata$datetime, label = TRUE)


#
### Plot 1
#

plot1 <- ggplot(data = hpcdata, aes(x= Global_active_power)) +
  geom_histogram(aes(y=..count..), binwidth = .5, fill = "red", colour = "black") +
  scale_y_continuous(labels = comma) +
  labs(title="Global Active Power", x="Global Active Power (kilowatts)", y="Frequency")
plot1

# save
png("plot1.png", width=480, height=480)
plot1
dev.off()



#
### Plot 2
#

plot2 <- ggplot(data = hpcdata, aes(x = datetime, y = Global_active_power)) +
  geom_line() +
  labs(y="Global Active Power (kilowatts)", x=element_blank())
plot2

# save
png("plot2.png", width=480, height=480)
plot2
dev.off()



#
### Plot 3
#

library(reshape2)

plot3data <- select(hpcdata, starts_with("Sub_metering"),datetime,weekdate)
plot3data <- melt(plot3data, id = c("datetime","weekdate"))

plot3 <- ggplot(data = plot3data, aes(x = datetime, y = value, color = variable)) +
  geom_line() +
  labs(y="Energy sub metering", x=element_blank()) +
  theme(legend.position = "top")
plot3

# save
png("plot3.png", width=480, height=480)
plot3
dev.off()



#
### Plot 4
#

library(gridExtra)

voltage <- ggplot(data = hpcdata, aes(x = datetime, y = Voltage)) +
  geom_line() +
  labs(y="Voltage", x=element_blank())
# voltage
reactive <- ggplot(data = hpcdata, aes(x = datetime, y = Global_reactive_power)) +
  geom_line() +
  labs(y="Global Reactive Power", x=element_blank())
# reactive


grid.arrange(plot2,voltage,plot3, reactive, ncol = 2)


# save
png("plot4.png", width=480, height=480)
grid.arrange(plot2,voltage,plot3, reactive, ncol = 2)
dev.off()