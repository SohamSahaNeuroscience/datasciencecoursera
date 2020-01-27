img <- readJPEG("~/Data science specialization/Extracting data/getdata_jeff.jpg", native = TRUE)
dat<-tbl_df(img)
quantile(img, probs= c(0.3, 0.8))



gdp <- read.csv(url("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"))
edu <- read.csv(url("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"))
s<-left_join(gdp, edu, by = c("X" = "CountryCode"))
c<-s %>%
  filter(s$Income.Group == "High income: OECD")%>%
  print
sum(as.numeric(as.character(c$Gross.domestic.product.2012))/length(c$Gross.domestic.product.2012))

c1<-s %>%
  filter(s$Income.Group == "High income: nonOECD")%>%
  print
sum(as.numeric(as.character(c1$Gross.domestic.product.2012)),na.rm  = FALSE)/length(c1$Gross.domestic.product.2012)


