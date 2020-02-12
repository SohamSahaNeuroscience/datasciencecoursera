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

head(sccData$Short.Name)


par("mar"=c(5.1, 4.5, 4.1, 2.1))
png(filename = "plot4.png", 
    width = 480, height = 480, 
    units = "px")
coal <- grep("coal", sccData$Short.Name, ignore.case = T)
coal <- sccData[coal, ]
coal <- neiData[neiData$SCC %in% coal$SCC, ]

coalEmissions <- aggregate(coal$Emissions, list(coal$year), FUN = "sum")
plot(coalEmissions, type = "l", xlab = "Year", 
     main = "Total Emissions From Coal Combustion-related\n Sources from 1999 to 2008", 
     ylab = expression('Total PM'[2.5]*" Emission"))
dev.off()