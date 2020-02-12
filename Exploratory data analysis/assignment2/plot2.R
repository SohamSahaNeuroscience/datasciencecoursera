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

##subset Baltimore data
subset <- neiData[neiData$fips == "24510", ] 

##plot the data and save as png
par("mar"=c(5.1, 4.5, 4.1, 2.1))
png(filename = "plot2.png", 
    width = 480, height = 480, 
    units = "px")
totalEmissions <- aggregate(subset$Emissions, list(subset$year), FUN = "sum")
plot(totalEmissions, type = "l", xlab = "Year", 
     main = "Total Emissions in Baltimore City from 1999 to 2008", 
     ylab = expression('Total PM'[2.5]*" Emission"))

dev.off()