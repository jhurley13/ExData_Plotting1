
# This assignment uses data from the UC Irvine Machine Learning Repository, a
# popular repository for machine learning datasets. In particular, we will be
# using the "Individual household electric power consumption Data Set" which I
# have made available on the course web site:
#
# Dataset: Electric power consumption [20Mb]
# https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
#
# Description: Measurements of electric power consumption in one household with
# a one-minute sampling rate over a period of almost 4 years. Different
# electrical quantities and some sub-metering values are available.

library(dplyr)
library(lubridate)
library(magrittr)

#------------------------------------------------------------------------
#   Get the data
#------------------------------------------------------------------------

data_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
data_dest <- "exdata-data-household_power_consumption.zip"
    
if (!file.exists(data_dest)) {
    download.file(data_url, data_dest, method="curl")
    downloadtime=date()
    print(downloadtime)
    unzip(data_dest, overwrite=TRUE)
    # dest is "household_power_consumption.txt"
}

#------------------------------------------------------------------------
#   Load data into data.frame
#------------------------------------------------------------------------

hpc_file <- "household_power_consumption.txt"
hpc_all <- read.csv(hpc_file, header = TRUE, sep = ";", stringsAsFactors = FALSE)

# Note: mutate doesn't support as.POSIXlt, so would degrade to plain "Date" class
hpc_all$DateTime = with(hpc_all, as.POSIXct(strptime(paste(Date, Time, sep = " "), "%d/%m/%Y %H:%M:%S")))

# We will only be using data from the dates 2007-02-01 and 2007-02-02.
hpc <- hpc_all %>%
    filter(hpc_all$Date == "1/2/2007" | hpc_all$Date == "2/2/2007")

# Convert non-date columns from character to numeric
hpc[,c(3:9)] %<>% lapply(function(x) as.numeric(as.character(x)))

#------------------------------------------------------------------------
#   Make the plot
#------------------------------------------------------------------------

# Construct the plot and save it to a PNG file with a width of 480 pixels and a height of 480 pixels.
# Name each of the plot files as plot1.png, plot2.png, etc.

png(filename = "plot2.png", width = 480, height = 480)
with(hpc, plot(DateTime, Global_active_power, type = 'l', xlab = "", ylab = "Global Active Power (kilowatts)"))
dev.off()

