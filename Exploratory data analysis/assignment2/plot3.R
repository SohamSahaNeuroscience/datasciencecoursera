setwd("~/Data science specialization/Exploratory data analysis/assignment 2/data")
zipF<-file.choose() # lets you choose a file and save its file path in R
outdir = "./data/" #output directory
unzip(zipF, exdir = outdir)

neiData <- readRDS("./data/summarySCC_PM25.rds")
sccData <- readRDS("./data/Source_Classification_Code.rds")

head(neiData)
head(sccData)
dim(neiData) 
dim(sccData)

##subset data on flips = 24510
subset <- neiData[neiData$fips == "24510", ] 

##use ggplot2, plot the data and save as png
library(ggplot2)
par("mar"=c(5.1, 4.5, 4.1, 2.1))
png(filename = "plot3.png", 
    width = 480, height = 480, 
    units = "px")
g <- ggplot(subset, aes(year, Emissions, color = type))
g + geom_line(stat = "summary", fun.y = "sum") +
  ylab(expression('Total PM'[2.5]*" Emissions")) +
  ggtitle("Total Emissions in Baltimore City from 1999 to 2008")
dev.off()
