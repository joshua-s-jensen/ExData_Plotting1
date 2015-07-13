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