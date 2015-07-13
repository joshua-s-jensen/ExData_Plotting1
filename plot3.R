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