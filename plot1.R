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

