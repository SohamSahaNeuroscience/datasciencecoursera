# download data from the link
Url_data <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"

File_data <- "StormData.csv.bz2"
if (!file.exists(File_data)) {
  download.file(Url_data, File_data, mode = "wb")
}

# reading data
data <- read.csv(file = File_data, header=TRUE, sep=",")
head(data)


# date subsets
Main_data <- data
Main_data$BGN_DATE <- strptime(data$BGN_DATE, "%m/%d/%Y %H:%M:%S")
Main_data <- subset(Main_data, BGN_DATE > "1995-12-31")

# subsetting to required columns
Main_data <- subset(Main_data, select = c(EVTYPE, FATALITIES, INJURIES, PROPDMG, PROPDMGEXP, CROPDMG, CROPDMGEXP))
#main event types
unique(Main_data$EVTYPE)

#cleaning event types names
Main_data$EVTYPE <- toupper(Main_data$EVTYPE)
unique(Main_data$EVTYPE)

# eliminating zero data
Main_data <- Main_data[Main_data$FATALITIES !=0 | 
                         Main_data$INJURIES !=0 | 
                         Main_data$PROPDMG !=0 | 
                         Main_data$CROPDMG !=0, ]
unique(Main_data$EVTYPE)

#Population health data pre-process

Health_data <- aggregate(cbind(FATALITIES, INJURIES) ~ EVTYPE, data = Main_data, FUN=sum)
Health_data$PEOPLE_LOSS <- Health_data$FATALITIES + Health_data$INJURIES
Health_data <- Health_data[order(Health_data$PEOPLE_LOSS, decreasing = TRUE), ]
Top15_events_people <- Health_data[1:15,]
print(Top15_events_people)


#Economic consequences

#transforming letters and symbols to numbers

Main_data$PROPDMGEXP <- gsub("[Hh]", "2", Main_data$PROPDMGEXP)
Main_data$PROPDMGEXP <- gsub("[Kk]", "3", Main_data$PROPDMGEXP)
Main_data$PROPDMGEXP <- gsub("[Mm]", "6", Main_data$PROPDMGEXP)
Main_data$PROPDMGEXP <- gsub("[Bb]", "9", Main_data$PROPDMGEXP)
Main_data$PROPDMGEXP <- gsub("\\+", "1", Main_data$PROPDMGEXP)
Main_data$PROPDMGEXP <- gsub("\\?|\\-|\\ ", "0",  Main_data$PROPDMGEXP)
Main_data$PROPDMGEXP <- as.numeric(Main_data$PROPDMGEXP)

Main_data$CROPDMGEXP <- gsub("[Hh]", "2", Main_data$CROPDMGEXP)
Main_data$CROPDMGEXP <- gsub("[Kk]", "3", Main_data$CROPDMGEXP)
Main_data$CROPDMGEXP <- gsub("[Mm]", "6", Main_data$CROPDMGEXP)
Main_data$CROPDMGEXP <- gsub("[Bb]", "9", Main_data$CROPDMGEXP)
Main_data$CROPDMGEXP <- gsub("\\+", "1", Main_data$CROPDMGEXP)
Main_data$CROPDMGEXP <- gsub("\\-|\\?|\\ ", "0", Main_data$CROPDMGEXP)
Main_data$CROPDMGEXP <- as.numeric(Main_data$CROPDMGEXP)

Main_data$PROPDMGEXP[is.na(Main_data$PROPDMGEXP)] <- 0
Main_data$CROPDMGEXP[is.na(Main_data$CROPDMGEXP)] <- 0

#creating total damage values
library(dplyr)
Main_data <- mutate(Main_data, 
                    PROPDMGTOTAL = PROPDMG * (10 ^ PROPDMGEXP), 
                    CROPDMGTOTAL = CROPDMG * (10 ^ CROPDMGEXP))

#analyzing
Economic_data <- aggregate(cbind(PROPDMGTOTAL, CROPDMGTOTAL) ~ EVTYPE, data = Main_data, FUN=sum)
Economic_data$ECONOMIC_LOSS <- Economic_data$PROPDMGTOTAL + Economic_data$CROPDMGTOTAL
Economic_data <- Economic_data[order(Economic_data$ECONOMIC_LOSS, decreasing = TRUE), ]
Top15_events_economy <- Economic_data[1:15,]
print(Top15_events_economy)


#plotting health loss
library(ggplot2)
g <- ggplot(data = Top15_events_people, aes(x = reorder(EVTYPE, PEOPLE_LOSS), y = PEOPLE_LOSS))
g <- g + geom_bar(stat = "identity", colour = "black")
g <- g + labs(title = "Total people loss in USA by weather events in 1996-2011")
g <- g + theme(plot.title = element_text(hjust = 0.5))
g <- g + labs(y = "Number of fatalities and injuries", x = "Event Type")
g <- g + coord_flip()
print(g)

#plotting economic loss
g <- ggplot(data = Top15_events_economy, aes(x = reorder(EVTYPE, ECONOMIC_LOSS), y = ECONOMIC_LOSS))
g <- g + geom_bar(stat = "identity", colour = "black")
g <- g + labs(title = "Total economic loss in USA by weather events in 1996-2011")
g <- g + theme(plot.title = element_text(hjust = 0.5))
g <- g + labs(y = "Size of property and crop loss", x = "Event Type")
g <- g + coord_flip()
print(g)

#correlate health and economic loss
library(ggcorrplot)
library(corrplot)
library(Hmisc)
merged_data = merge(Top15_events_economy, Top15_events_people, by.x = "EVTYPE")
mc_data <- merged_data[,2:length(merged_data)]
corr = round(cor(mc_data),2)

ggcorrplot(corr[1:3,4:6], method = "circle")



